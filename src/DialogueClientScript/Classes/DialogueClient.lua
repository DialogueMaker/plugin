--!strict

local Players = game:GetService("Players");

local DialogueClientScript = script.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local ReactRoblox = require(DialogueClientScript.Packages["react-roblox"]);
local IDialogueClient = require(DialogueClientScript.Interfaces.DialogueClient);
local IDialogueServer = require(DialogueClientScript.Interfaces.DialogueServer);

type DialogueClient = IDialogueClient.DialogueClient;
type DialogueServer = IDialogueServer.DialogueServer;

local DialogueClient = {};

function DialogueClient.new(): DialogueClient

  local themeChangedEvent = Instance.new("BindableEvent");

  local player = Players.LocalPlayer;
  local function freezePlayer(): ()
  
    (require(player.PlayerScripts:WaitForChild("PlayerModule")) :: any):GetControls():Disable();
    
  end;

  local function unfreezePlayer(): ()

    (require(player.PlayerScripts:WaitForChild("PlayerModule")) :: any):GetControls():Enable();
    
  end;

  local function toggleAllTriggers(self: DialogueClient, shouldEnable: boolean): ()

    for _, dialogueServer in self.dialogueServers do

      dialogueServer:toggleTriggers(shouldEnable);

    end;

  end;

  local function interact(self: DialogueClient, dialogueServer: DialogueServer)

    -- Make sure we aren't already talking to an NPC
    assert(not self.isTalkingWithNPC, "[Dialogue Maker] Cannot read dialogue because player is currently talking with another NPC.");
    self.isTalkingWithNPC = true;

    -- Make sure we can't talk to another NPC
    self:toggleAllTriggers(false);
    
    local freezePlayer = dialogueServer.settings.general.freezePlayer;
    if freezePlayer then 

      self:freezePlayer(); 

    end;

    -- Initialize the theme, then listen for changes
    local themeModuleScript = dialogueServer:getTheme(true);
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
      local dialogue = require(contentScript) :: types.Dialogue;

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

        local onCompletionEvent = Instance.new("BindableEvent");
        local function renderRoot()

          root:render(React.createElement(require(themeModuleScript) :: any, {
            responseContentScripts = responses;
            dialogue = dialogue;
            onComplete = function(selectedResponseContentScript: ModuleScript?)
        
              dialogue:runAction();
    
              -- Check if there is more dialogue.
              parent = if selectedResponseContentScript then selectedResponseContentScript else contentScript;
              updatePriorities();
    
              if Dialogue.isPlayerTalkingWithNPC then
    
                priorityIndex = 1;
    
              else
    
                Dialogue.isPlayerTalkingWithNPC = false;
    
              end;
    
              onCompletionEvent:Fire();
        
            end;
            onTimeout = function()
    
              Dialogue.isPlayerTalkingWithNPC = false;
              onCompletionEvent:Fire();
    
            end;
            clientSettings = clientSettings;
            npcSettings = npcSettings;
            npc = npc;
          }));

        end;

        local themeChangedEvent = Dialogue.onThemeChanged:Connect(function()

          renderRoot();
      
        end);

        renderRoot();
        onCompletionEvent.Event:Wait();
        themeChangedEvent:Disconnect();

      elseif Dialogue.isPlayerTalkingWithNPC then

        -- There is a message; however, the player failed the condition.
        -- Let's check if there's something else available.
        priorityIndex += 1;

      end;

    end;

    -- Free the player :)
    self:toggleAllTriggers(true);
    root:unmount();
    dialogueGUI:Destroy();
    Dialogue.isPlayerTalkingWithNPC = false;

  end;

  local function setTheme(self: DialogueClient, theme: ModuleScript)

    self.theme = theme;
    themeChangedEvent:Fire(theme);

  end;

  local function addDialogueServer(self: DialogueClient, dialogueServer: DialogueServer)

    local speechBubble = dialogueServer.speechBubble;
    if speechBubble then

      (speechBubble:FindFirstChild("speechBubbleButton") :: ImageButton).MouseButton1Click:Connect(function()

        self:interact(dialogueServer);

      end);

    end;
    
    local proximityPrompt = dialogueServer.proximityPrompt;
    if proximityPrompt then

      proximityPrompt.Triggered:Connect(function()

        self:interact(dialogueServer);

      end);

    end;

    table.insert(self.dialogueServers, dialogueServer);

  end;

  local dialogueClient: DialogueClient = {
    dialogueServers = {};
    isTalkingWithNPC = false;
    addDialogueServer = addDialogueServer;
    interact = interact;
    setTheme = setTheme;
    toggleAllTriggers = toggleAllTriggers;
    ThemeChanged = themeChangedEvent.Event;
  };

  player.CharacterRemoving:Connect(function()

    dialogueClient.isTalkingWithNPC = false;

  end);

  return dialogueClient;

end;

return DialogueClient;