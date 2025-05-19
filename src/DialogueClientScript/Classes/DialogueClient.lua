--!strict

local ContextActionService = game:GetService("ContextActionService");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");

local DialogueClientScript = script.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local ReactRoblox = require(DialogueClientScript.Packages["react-roblox"]);
local IDialogueClient = require(DialogueClientScript.Interfaces.DialogueClient);
local IDialogueServer = require(DialogueClientScript.Interfaces.DialogueServer);
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);

type Dialogue = IDialogue.Dialogue;
type DialogueClient = IDialogueClient.DialogueClient;
type DialogueClientSettings = IDialogueClient.DialogueClientSettings;
type DialogueServer = IDialogueServer.DialogueServer;

local DialogueClient = {
  sharedDialogueClient = nil :: DialogueClient?;
};

function DialogueClient.new(dialogueClientSettings: IDialogueClient.DialogueClientSettings): DialogueClient

  local themeChangedEvent = Instance.new("BindableEvent");
  local player = Players.LocalPlayer;

  local function freezePlayer(): ()
  
    (require(player.PlayerScripts:WaitForChild("PlayerModule")) :: any):GetControls():Disable();
    
  end;

  local function interact(self: DialogueClient, dialogueServer: DialogueServer)

    -- Make sure we aren't already talking to an NPC
    assert(not self.isTalkingWithNPC, "[Dialogue Maker] Cannot read dialogue because player is currently talking with another NPC.");
    self.isTalkingWithNPC = true;

    -- Make sure we can't talk to another NPC
    self:toggleAllTriggers(false);
    
    local freezePlayer = dialogueServer.settings.general.shouldFreezePlayer;
    if freezePlayer then 

      self:freezePlayer(); 

    end;

    -- Initialize the theme, then listen for changes
    local themeModuleScript = dialogueServer.settings.general.theme or dialogueClientSettings.theme.defaultTheme;
    local dialogueGUI = Instance.new("ScreenGui");
    dialogueGUI.Parent = player.PlayerGui;
    local root = ReactRoblox.createRoot(dialogueGUI);
    self:setTheme(themeModuleScript);

    -- Show the dialogue to the player
    local parent: Instance = dialogueServer.instance;
    local priorities = {};
    local priorityIndex = 1;

    local function updatePriorities()

      priorities = {};

      for _, possibleContentScript in parent:GetChildren() do
    
        local possibleDialogueType = possibleContentScript:GetAttribute("DialogueType");
        if possibleContentScript:IsA("ModuleScript") and tonumber(possibleContentScript.Name) and (possibleDialogueType == "Message" or possibleDialogueType == "Redirect") then

          table.insert(priorities, possibleContentScript.Name);

        end

      end

    end;

    updatePriorities();

    while self.isTalkingWithNPC and task.wait() do

      local priority = priorities[priorityIndex];
      local contentScript = if priority then parent:FindFirstChild(priority) else nil;
      if not contentScript then

        -- No more content scripts available. Let's free the player.
        break;

      end

      local dialogueType = contentScript:GetAttribute("DialogueType");
      local dialogue = require(contentScript) :: Dialogue;

      if dialogue:verifyCondition() then
        
        if dialogueType == "Redirect" then

          -- A redirect is available, so let's switch priorities.
          local redirectObjectValue = contentScript:FindFirstChild("Redirect");
          assert(redirectObjectValue and redirectObjectValue:IsA("ObjectValue"), "[Dialogue Maker] Redirect object value not found.");

          local goalRedirect = redirectObjectValue.Value;
          assert(goalRedirect and goalRedirect:IsA("ModuleScript"), "[Dialogue Maker] Redirect object value is not a ModuleScript.");
          assert(goalRedirect.Parent, "[Dialogue Maker] Redirect object value has no parent.");

          parent = goalRedirect.Parent;
          updatePriorities();
          local index = table.find(priorities, goalRedirect.Name);
          assert(index, "[Dialogue Maker] Redirect object value not found in priorities.");
          priorityIndex = index;
          
          continue;

        end;

        -- Get a list of responses from the dialogue.
        local responses: {ModuleScript} = {};
        for _, possibleResponse in contentScript:GetChildren() do

          if possibleResponse:IsA("ModuleScript") and tonumber(possibleResponse.Name) and possibleResponse:GetAttribute("DialogueType") == "Response" then

            local response = require(possibleResponse) :: any;

            if response:verifyCondition() then

              table.insert(responses, possibleResponse);

            end;

          end

        end

        -- Sort responses because :GetChildren() doesn't guarantee it
        table.sort(responses, function(responseScript1, responseScript2)

          return responseScript1.Name < responseScript2.Name;
    
        end);

        local completionSignal = Instance.new("BindableEvent");
        local function renderRoot()

          root:render(React.createElement(require(themeModuleScript) :: any, {
            responseContentScripts = responses;
            dialogue = dialogue;
            onComplete = function(selectedResponseContentScript: ModuleScript?)
        
              dialogue:runAction();
    
              -- Check if there is more dialogue.
              parent = if selectedResponseContentScript then selectedResponseContentScript else contentScript;
              updatePriorities();
    
              if self.isTalkingWithNPC then
    
                priorityIndex = 1;
    
              end;
    
              completionSignal:Fire();
        
            end;
            onTimeout = function()
    
              self.isTalkingWithNPC = false;
              completionSignal:Fire();
    
            end;
            dialogueClient = self;
            dialogueServer = dialogueServer;
          }));

        end;

        local themeChangedSignal = self.ThemeChanged:Connect(function()

          renderRoot();
      
        end);

        renderRoot();
        completionSignal.Event:Wait();
        themeChangedSignal:Disconnect();

      elseif self.isTalkingWithNPC then

        -- There is a message; however, the player failed the condition.
        -- Let's check if there's something else available.
        priorityIndex += 1;

      end;

    end;

    -- Free the player :)
    self:toggleAllTriggers(true);

    if freezePlayer then 

      self:unfreezePlayer(); 

    end;

    root:unmount();
    dialogueGUI:Destroy();
    self.isTalkingWithNPC = false;

  end;

  local function setTheme(self: DialogueClient, theme: ModuleScript)

    self.theme = theme;
    themeChangedEvent:Fire(theme);

  end;

  local function toggleAllTriggers(self: DialogueClient, shouldEnable: boolean): ()

    for _, dialogueServer in self.dialogueServers do

      dialogueServer:toggleTriggers(shouldEnable);

    end;

  end;

  local function unfreezePlayer(): ()

    (require(player.PlayerScripts:WaitForChild("PlayerModule")) :: any):GetControls():Enable();
    
  end;

  local settings: DialogueClientSettings = {
    theme = {
      defaultTheme = script.Themes.StandardTheme;
    };
    responses = {
      showResponsesAfterMessageFinished = true;
      defaultClickSound = 0;
    };
    keybinds = {
      minimumDistanceFromCharacter = 10; 
      keybindsEnabled = true; 
      interactKey = Enum.KeyCode.F; 
      interactKeyGamepad = Enum.KeyCode.ButtonX; 
      defaultChatContinueKey = Enum.KeyCode.F; 
      defaultChatContinueKeyGamepad = Enum.KeyCode.ButtonA; 
    }
  };

  local dialogueClient: DialogueClient = {
    dialogueServers = {};
    isTalkingWithNPC = false;
    settings = settings;
    freezePlayer = freezePlayer;
    interact = interact;
    setTheme = setTheme;
    toggleAllTriggers = toggleAllTriggers;
    unfreezePlayer = unfreezePlayer;
    ThemeChanged = themeChangedEvent.Event;
  };

  player.CharacterRemoving:Connect(function()

    dialogueClient.isTalkingWithNPC = false;

  end);

  local keybinds = dialogueClient.settings.keybinds;
  if keybinds.interactKey or keybinds.interactKeyGamepad then

    local nearestDialogueServer: DialogueServer? = nil;
    local ReadDialogueWithKeybind;
    ReadDialogueWithKeybind = function()

      if nearestDialogueServer and (UserInputService:IsKeyDown(keybinds.interactKey) or UserInputService:IsKeyDown(keybinds.interactKeyGamepad)) then
          
        dialogueClient:interact(nearestDialogueServer);

      end;

    end;
    ContextActionService:BindAction("OpenDialogueWithKeybind", ReadDialogueWithKeybind, false, keybinds.interactKey, keybinds.interactKeyGamepad);

    -- Check if the player is in range
    RunService.Heartbeat:Connect(function()

      local newNearestDialogueServer: DialogueServer? = nil;
      local nearestDistance: number? = nil;
      for _, dialogueServer in pairs(dialogueClient.dialogueServers) do

        local parent = dialogueServer.instance.Parent;
        if not parent then continue; end;

        local parentPosition = if parent:IsA("PVInstance") then parent:GetPivot().Position else nil;
        if not parentPosition then continue; end;

        local distance = player:DistanceFromCharacter(parentPosition);
        if distance <= dialogueClient.settings.keybinds.minimumDistanceFromCharacter and (not nearestDistance or distance < nearestDistance) then

          newNearestDialogueServer = dialogueServer;
          nearestDistance = distance;
          break;

        end;

      end;

      nearestDialogueServer = newNearestDialogueServer;

    end);

  end;

  return dialogueClient;

end;

function DialogueClient:getFromSharedObject(shouldWaitForObject: boolean?): DialogueClient

  if not DialogueClient.sharedDialogueClient then

    if shouldWaitForObject then

      repeat task.wait() until DialogueClient.sharedDialogueClient;

    end;

  end;

  assert(DialogueClient.sharedDialogueClient, "[Dialogue Maker] Shared dialogue client not set. Please call DialogueClient:setSharedObject() before calling this function.");

  return DialogueClient.sharedDialogueClient;

end;

function DialogueClient:setSharedObject(dialogueClient: DialogueClient?): ()

  assert(not DialogueClient.sharedDialogueClient, "[Dialogue Maker] Shared dialogue client already set.");
  DialogueClient.sharedDialogueClient = dialogueClient;

end;

return DialogueClient;