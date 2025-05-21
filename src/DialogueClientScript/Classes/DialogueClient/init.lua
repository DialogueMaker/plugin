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
type OptionalDialogueClientSettings = IDialogueClient.OptionalDialogueClientSettings;

local DialogueClient = {
  sharedDialogueClient = nil :: DialogueClient?;
  defaultSettings = {
    general = {
      theme = DialogueClientScript.Themes.StandardTheme;
      shouldEndConversationOnCharacterRemoval = true;
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

function DialogueClient:waitForSharedDialogueClient(): DialogueClient

  repeat task.wait() until DialogueClient.sharedDialogueClient;

  return self:getSharedDialogueClient();

end;

function DialogueClient:getSharedDialogueClient(): DialogueClient

  assert(DialogueClient.sharedDialogueClient, "[Dialogue Maker] Shared dialogue client not set.");

  return DialogueClient.sharedDialogueClient;

end;

function DialogueClient:setSharedDialogueClient(dialogueClient: DialogueClient?): ()

  assert(not DialogueClient.sharedDialogueClient, "[Dialogue Maker] Shared dialogue client already set.");
  DialogueClient.sharedDialogueClient = dialogueClient;

end;

function DialogueClient.new(dialogueClientSettings: OptionalDialogueClientSettings?): DialogueClient

  local player = Players.LocalPlayer;
  local settings: DialogueClientSettings = {
    general = {
      theme = if dialogueClientSettings and dialogueClientSettings.general and dialogueClientSettings.general.theme then dialogueClientSettings.general.theme else DialogueClient.defaultSettings.general.theme;
      shouldEndConversationOnCharacterRemoval = if dialogueClientSettings and dialogueClientSettings.general and dialogueClientSettings.general.shouldEndConversationOnCharacterRemoval then dialogueClientSettings.general.shouldEndConversationOnCharacterRemoval else DialogueClient.defaultSettings.general.shouldEndConversationOnCharacterRemoval;
    };
    responses = {
      clickSound = if dialogueClientSettings and dialogueClientSettings.responses then dialogueClientSettings.responses.clickSound else DialogueClient.defaultSettings.responses.clickSound;
    };
    keybinds = {
      interactKey = if dialogueClientSettings and dialogueClientSettings.keybinds then dialogueClientSettings.keybinds.interactKey else DialogueClient.defaultSettings.keybinds.interactKey; 
      interactKeyGamepad = if dialogueClientSettings and dialogueClientSettings.keybinds then dialogueClientSettings.keybinds.interactKeyGamepad else DialogueClient.defaultSettings.keybinds.interactKeyGamepad; 
    };
  };

  local settingsChangedEvent = Instance.new("BindableEvent");
  local dialogueServerChangedEvent = Instance.new("BindableEvent");

  local function freezePlayer(self: DialogueClient): ()
  
    (require(player.PlayerScripts:WaitForChild("PlayerModule")) :: any):GetControls():Disable();
    
  end;

  local function getDialogueServer(self: DialogueClient): DialogueServer?

    return self.dialogueServer;

  end;

  local function setDialogueServer(self: DialogueClient, dialogueServer: DialogueServer?): ()

    self.dialogueServer = dialogueServer;
    dialogueServerChangedEvent:Fire();

  end;

  local function interact(self: DialogueClient, dialogueServer: DialogueServer)

    -- Make sure we aren't already talking to an NPC
    assert(not self.dialogueServer, "[Dialogue Maker] Cannot read dialogue because player is currently talking with another NPC.");
    self:setDialogueServer(dialogueServer);
    
    -- Freeze the player if the dialogue server has a setting for it.
    local dialogueServerSettings = dialogueServer:getSettings();
    local shouldFreezePlayer = dialogueServerSettings.general.shouldFreezePlayer;
    if shouldFreezePlayer then 

      self:freezePlayer(); 

    end;

    -- Initialize the theme, then listen for changes
    local themeModuleScript = dialogueServerSettings.general.theme or settings.general.theme;
    local dialogueGUI = Instance.new("ScreenGui");
    local root = ReactRoblox.createRoot(dialogueGUI);
    dialogueGUI.Parent = player.PlayerGui;

    -- Start the dialogue loop.
    local queue = dialogueServer:getChildren();
    local priorityIndex = 1;

    while self.dialogueServer and task.wait() do

      local dialogue = queue[priorityIndex];
      if not dialogue then

        break;

      end

      if dialogue:verifyCondition() then
        
        if dialogue.redirectModuleScript then

          local parent = dialogue.redirectModuleScript.Parent;
          local parentDialogue = require(parent) :: Dialogue;
          queue = parentDialogue:getChildren();
          local newPriorityIndex: number? = nil;

          for index, childDialogue in queue do

            if childDialogue.moduleScript == dialogue.redirectModuleScript then

              newPriorityIndex = index;
              break;

            end;

          end;

          assert(newPriorityIndex, "[Dialogue Maker] Could not find redirect dialogue in queue.");
          priorityIndex = newPriorityIndex;
          
          continue;

        end;
        
        -- Run the dialogue's initialization action.
        dialogue:runAction(1);

        -- Show the dialogue to the player.
        local completionEvent = Instance.new("BindableEvent");
        local function renderRoot()

          print(dialogue:getContent())

          root:render(React.createElement(require(themeModuleScript) :: any, {
            dialogue = dialogue;
            onComplete = function(newParent: Dialogue?)
        
              -- Run the dialogue's completion action.
              dialogue:runAction(2);
    
              -- Continue through the dialogue tree.
              local parent = newParent or dialogue;
              queue = parent:getChildren();
              priorityIndex = 1;
              completionEvent:Fire(false);
        
            end;
            onTimeout = function()
    
              completionEvent:Fire(true);
    
            end;
            dialogueClient = self;
            dialogueServer = dialogueServer;
          }));

        end;

        local settingsChangedSignal = self.SettingsChanged:Connect(function()

          if settings.general.theme ~= themeModuleScript then

            themeModuleScript = settings.general.theme;
            renderRoot();

          end;
      
        end);

        renderRoot();
        
        local didTimeout = completionEvent.Event:Wait();
        if didTimeout then

          break;

        end;

        settingsChangedSignal:Disconnect();

      else

        -- There is a message; however, the player failed the condition.
        -- Let's check if there's something else available.
        priorityIndex += 1;

      end;

    end;

    -- No more dialogue to show, so let's clean up.
    if freezePlayer then 

      self:unfreezePlayer(); 

    end;

    root:unmount();
    dialogueGUI:Destroy();
    self:setDialogueServer();

  end;

  local function unfreezePlayer(self: DialogueClient): ()

    (require(player.PlayerScripts:WaitForChild("PlayerModule")) :: any):GetControls():Enable();
    
  end;

  local function getSettings(self: DialogueClient): DialogueClientSettings

    return table.clone(settings);

  end;

  local function setSettings(self: DialogueClient, newSettings: DialogueClientSettings): ()

    dialogueClientSettings = newSettings;
    settingsChangedEvent:Fire();

  end;

  local dialogueClient: DialogueClient = {
    freezePlayer = freezePlayer;
    interact = interact;
    getSettings = getSettings;
    setSettings = setSettings;
    unfreezePlayer = unfreezePlayer;
    getDialogueServer = getDialogueServer;
    setDialogueServer = setDialogueServer;
    SettingsChanged = settingsChangedEvent.Event;
    DialogueServerChanged = dialogueServerChangedEvent.Event;
  };

  player.CharacterRemoving:Connect(function()

    dialogueClient.dialogueServer = nil;

  end);

  dialogueClient.SettingsChanged:Connect(function()
  
  end);

  return dialogueClient;

end;

return DialogueClient;