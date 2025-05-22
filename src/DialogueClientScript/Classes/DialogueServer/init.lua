--!strict

local DialogueClientScript = script.Parent.Parent;

local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);
local IDialogueServer = require(DialogueClientScript.Interfaces.DialogueServer);

type Dialogue = IDialogue.Dialogue;
type DialogueServer = IDialogueServer.DialogueServer;
type DialogueServerSettings = IDialogueServer.DialogueServerSettings;
type OptionalDialogueServerSettings = IDialogueServer.OptionalDialogueServerSettings;

local DialogueServer = {
  defaultSettings = {
    general = {
      name = nil;
      theme = nil;
      shouldFreezePlayer = true;
    };
    distance = {
      relativePart = nil;
      maxConversationDistance = nil;
    };
    promptRegion = {
      basePart = nil; 
    };
    clickDetector = { 
      shouldAutoCreate = false; 
      shouldDisappearDuringConversation = true; 
      instance = nil;
    };
    proximityPrompt = { 
      shouldAutoCreate = true; 
      instance = nil; 
    };
    speechBubble = {
      shouldAutoCreate = false; 
      button = nil;
      billboardGUI = nil;
      adornee = nil;
    };
  } :: DialogueServerSettings;
};

function DialogueServer.new(dialogueServerSettings: OptionalDialogueServerSettings?, moduleScript: ModuleScript): DialogueServer

  local settingsChangedEvent = Instance.new("BindableEvent");
  local settings: DialogueServerSettings = {
    general = {
      name = if dialogueServerSettings and dialogueServerSettings.general then dialogueServerSettings.general.name else DialogueServer.defaultSettings.general.name;
      theme = if dialogueServerSettings and dialogueServerSettings.general then dialogueServerSettings.general.theme else DialogueServer.defaultSettings.general.theme;
      shouldFreezePlayer = if dialogueServerSettings and dialogueServerSettings.general and dialogueServerSettings.general.shouldFreezePlayer ~= nil then dialogueServerSettings.general.shouldFreezePlayer else DialogueServer.defaultSettings.general.shouldFreezePlayer; 
    };
    distance = {
      relativePart = if dialogueServerSettings and dialogueServerSettings.distance and dialogueServerSettings.distance.relativePart then dialogueServerSettings.distance.relativePart else DialogueServer.defaultSettings.distance.relativePart; 
      maxConversationDistance = if dialogueServerSettings and dialogueServerSettings.distance and dialogueServerSettings.distance.maxConversationDistance then dialogueServerSettings.distance.maxConversationDistance else DialogueServer.defaultSettings.distance.maxConversationDistance; 
    };
    promptRegion = {
      basePart = if dialogueServerSettings and dialogueServerSettings.promptRegion then dialogueServerSettings.promptRegion.basePart else DialogueServer.defaultSettings.promptRegion.basePart; 
    };
    clickDetector = { 
      shouldAutoCreate = if dialogueServerSettings and dialogueServerSettings.clickDetector and dialogueServerSettings.clickDetector.shouldAutoCreate ~= nil then dialogueServerSettings.clickDetector.shouldAutoCreate else DialogueServer.defaultSettings.clickDetector.shouldAutoCreate; 
      shouldDisappearDuringConversation = if dialogueServerSettings and dialogueServerSettings.clickDetector and dialogueServerSettings.clickDetector.shouldDisappearDuringConversation ~= nil then dialogueServerSettings.clickDetector.shouldDisappearDuringConversation else DialogueServer.defaultSettings.clickDetector.shouldDisappearDuringConversation; 
      instance = if dialogueServerSettings and dialogueServerSettings.clickDetector then dialogueServerSettings.clickDetector.instance else DialogueServer.defaultSettings.clickDetector.instance;
    };
    proximityPrompt = { 
      shouldAutoCreate = if dialogueServerSettings and dialogueServerSettings.proximityPrompt and dialogueServerSettings.proximityPrompt.shouldAutoCreate ~= nil then dialogueServerSettings.proximityPrompt.shouldAutoCreate else DialogueServer.defaultSettings.proximityPrompt.shouldAutoCreate; 
      instance = if dialogueServerSettings and dialogueServerSettings.proximityPrompt then dialogueServerSettings.proximityPrompt.instance else DialogueServer.defaultSettings.proximityPrompt.instance; 
    };
    speechBubble = {
      shouldAutoCreate = if dialogueServerSettings and dialogueServerSettings.speechBubble and dialogueServerSettings.speechBubble.shouldAutoCreate ~= nil then dialogueServerSettings.speechBubble.shouldAutoCreate else DialogueServer.defaultSettings.speechBubble.shouldAutoCreate; 
      billboardGUI = if dialogueServerSettings and dialogueServerSettings.speechBubble and dialogueServerSettings.speechBubble.billboardGUI ~= nil then dialogueServerSettings.speechBubble.billboardGUI else DialogueServer.defaultSettings.speechBubble.billboardGUI;
      button = if dialogueServerSettings and dialogueServerSettings.speechBubble and dialogueServerSettings.speechBubble.button ~= nil then dialogueServerSettings.speechBubble.button else DialogueServer.defaultSettings.speechBubble.button;
      adornee = if dialogueServerSettings and dialogueServerSettings.speechBubble and dialogueServerSettings.speechBubble.adornee ~= nil then dialogueServerSettings.speechBubble.adornee else DialogueServer.defaultSettings.speechBubble.adornee;
    }
  };

  local function getSettings(self: DialogueServer): DialogueServerSettings

    return table.clone(settings);

  end;

  local function getChildren(self: DialogueServer): {Dialogue}

    local children = {};
    for _, child in moduleScript:GetChildren() do

      if child:IsA("ModuleScript") and tonumber(child.Name) then

        local dialogue = require(child) :: Dialogue;
        table.insert(children, dialogue);

      end;

    end;

    return children;

  end;

  local function setSettings(self: DialogueServer, newSettings: DialogueServerSettings): ()

    settings = newSettings;
    settingsChangedEvent:Fire(newSettings);

  end;

  local dialogueServer: DialogueServer = {
    getChildren = getChildren;
    getSettings = getSettings;
    setSettings = setSettings;
    moduleScript = moduleScript;
  };

  return dialogueServer;

end;

return DialogueServer;