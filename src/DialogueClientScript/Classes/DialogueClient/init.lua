--!strict

local Players = game:GetService("Players");

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
  defaultSettings = {
    general = {
      theme = script.Themes.StandardTheme;
    };
    responses = {
      clickSound = nil;
    };
    keybinds = {
      interactKey = nil;
      interactKeyGamepad = nil;
    };
  } :: DialogueClientSettings;
};

function DialogueClient.new(dialogueClientSettings: IDialogueClient.OptionalDialogueClientSettings?, module: ModuleScript): DialogueClient

  local themeChangedEvent = Instance.new("BindableEvent");
  local dialogueServerChangedEvent = Instance.new("BindableEvent");
  local player = Players.LocalPlayer;

  local function freezePlayer(): ()
  
    (require(player.PlayerScripts:WaitForChild("PlayerModule")) :: any):GetControls():Disable();
    
  end;

  local function interact(self: DialogueClient, dialogueServer: DialogueServer)

    -- Make sure we aren't already talking to an NPC
    assert(not self.dialogueServer, "[Dialogue Maker] Cannot read dialogue because player is currently talking with another NPC.");
    self.dialogueServer = dialogueServer;
    dialogueServerChangedEvent:Fire();
    
    local freezePlayer = dialogueServer.settings.general.shouldFreezePlayer;
    if freezePlayer then 

      self:freezePlayer(); 

    end;

    -- Initialize the theme, then listen for changes
    local themeModuleScript = dialogueServer.settings.general.theme or self.settings.general.theme;
    local dialogueGUI = Instance.new("ScreenGui");
    dialogueGUI.Parent = player.PlayerGui;
    local root = ReactRoblox.createRoot(dialogueGUI);
    self:setTheme(themeModuleScript);

    -- Show the dialogue to the player
    local parent: Instance = module;
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

    while self.dialogueServer and task.wait() do

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
    
              if self.dialogueServer then
    
                priorityIndex = 1;
    
              end;
    
              completionSignal:Fire(false);
        
            end;
            onTimeout = function()
    
              completionSignal:Fire(true);
    
            end;
            dialogueClient = self;
            dialogueServer = dialogueServer;
          }));

        end;

        local themeChangedSignal = self.ThemeChanged:Connect(function()

          renderRoot();
      
        end);

        renderRoot();
        local didTimeout = completionSignal.Event:Wait();
        if didTimeout then

          break;

        end;
        themeChangedSignal:Disconnect();

      elseif self.dialogueServer then

        -- There is a message; however, the player failed the condition.
        -- Let's check if there's something else available.
        priorityIndex += 1;

      end;

    end;

    self.dialogueServer = nil;
    dialogueServerChangedEvent:Fire();

    if freezePlayer then 

      self:unfreezePlayer(); 

    end;

    root:unmount();
    dialogueGUI:Destroy();

  end;

  local function setTheme(self: DialogueClient, theme: ModuleScript)

    self.theme = theme;
    themeChangedEvent:Fire(theme);

  end;

  local function unfreezePlayer(): ()

    (require(player.PlayerScripts:WaitForChild("PlayerModule")) :: any):GetControls():Enable();
    
  end;

  local settings: DialogueClientSettings = {
    general = {
      theme = (if dialogueClientSettings and dialogueClientSettings.general then dialogueClientSettings.general.theme else nil) or DialogueClient.defaultSettings.general.theme;
    };
    responses = {
      clickSound = if dialogueClientSettings and dialogueClientSettings.responses then dialogueClientSettings.responses.clickSound else DialogueClient.defaultSettings.responses.clickSound;
    };
    keybinds = {
      interactKey = if dialogueClientSettings and dialogueClientSettings.keybinds then dialogueClientSettings.keybinds.interactKey else DialogueClient.defaultSettings.keybinds.interactKey; 
      interactKeyGamepad = if dialogueClientSettings and dialogueClientSettings.keybinds then dialogueClientSettings.keybinds.interactKeyGamepad else DialogueClient.defaultSettings.keybinds.interactKeyGamepad; 
    };
  };

  local dialogueClient: DialogueClient = {
    dialogueServer = nil;
    settings = settings;
    freezePlayer = freezePlayer;
    interact = interact;
    setTheme = setTheme;
    unfreezePlayer = unfreezePlayer;
    ThemeChanged = themeChangedEvent.Event;
    DialogueServerChanged = dialogueServerChangedEvent.Event;
  };

  player.CharacterRemoving:Connect(function()

    dialogueClient.dialogueServer = nil;

  end);

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