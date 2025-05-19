--!strict

local DialogueClientScript = script.Parent.Parent;

local IDialogueServer = require(DialogueClientScript.Interfaces.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;
type DialogueServerSettings = IDialogueServer.DialogueServerSettings;
type OptionalDialogueServerSettings = IDialogueServer.OptionalDialogueServerSettings;

local DialogueServer = {
  defaultSettings = {
    general = {
      name = nil;
      theme = nil;
      shouldFreezePlayer = true; 
      shouldEndConversationIfOutOfDistance = false;
      maxConversationDistance = 10;
    };
    typewriter = {
      characterDelaySeconds = 0.025; 
      canPlayerSkipDelay = true; 
    };
    humanoid = {
      shouldLookAtPlayer = true; 
      neckRotationMaxX = 0.8726;
      neckRotationMaxY = 1.0472; 
      neckRotationMaxZ = 0.8726; 
    };
    promptRegion = {
      basePart = nil; 
    };
    timeout = {	
      seconds = nil; 
      shouldWaitForResponse = true; 
    };
    clickDetector = { 
      shouldAutoCreate = true; 
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

export type ConstructorProperties = {
}

function DialogueServer.new(dialogueServerSettings: OptionalDialogueServerSettings?, instance: ModuleScript): DialogueServer

  local function toggleTriggers(self: DialogueServer, enabled: boolean): ()

    if self.clickDetector then

      if enabled then

        self.clickDetector.Parent = instance.Parent;

        local OriginalParent = self.clickDetector:FindFirstChild("OriginalParent");
        if OriginalParent and OriginalParent:IsA("ObjectValue") and OriginalParent.Value then

          self.clickDetector.Parent = OriginalParent.Value;
          OriginalParent:Destroy();

        end;

      elseif self.clickDetector.Parent then

        local OriginalParent = Instance.new("ObjectValue");
        OriginalParent.Name = "OriginalParent";
        OriginalParent.Value = self.clickDetector.Parent;
        OriginalParent.Parent = self.clickDetector;

        self.clickDetector.Parent = instance;

      end;

    end;

  end;

  local settings: DialogueServerSettings = {
    general = {
      name = if dialogueServerSettings and dialogueServerSettings.general then dialogueServerSettings.general.name else DialogueServer.defaultSettings.general.name;
      theme = if dialogueServerSettings and dialogueServerSettings.general then dialogueServerSettings.general.theme else DialogueServer.defaultSettings.general.theme;
      shouldFreezePlayer = if dialogueServerSettings and dialogueServerSettings.general and dialogueServerSettings.general.shouldFreezePlayer ~= nil then dialogueServerSettings.general.shouldFreezePlayer else DialogueServer.defaultSettings.general.shouldFreezePlayer; 
      shouldEndConversationIfOutOfDistance = if dialogueServerSettings and dialogueServerSettings.general and dialogueServerSettings.general.shouldEndConversationIfOutOfDistance ~= nil then dialogueServerSettings.general.shouldEndConversationIfOutOfDistance else DialogueServer.defaultSettings.general.shouldEndConversationIfOutOfDistance;
      maxConversationDistance = if dialogueServerSettings and dialogueServerSettings.general and dialogueServerSettings.general.maxConversationDistance ~= nil then dialogueServerSettings.general.maxConversationDistance else DialogueServer.defaultSettings.general.maxConversationDistance;
    };
    typewriter = {
      characterDelaySeconds = if dialogueServerSettings and dialogueServerSettings.typewriter and dialogueServerSettings.typewriter.characterDelaySeconds ~= nil then dialogueServerSettings.typewriter.characterDelaySeconds else DialogueServer.defaultSettings.typewriter.characterDelaySeconds; 
      canPlayerSkipDelay = if dialogueServerSettings and dialogueServerSettings.typewriter and dialogueServerSettings.typewriter.canPlayerSkipDelay ~= nil then dialogueServerSettings.typewriter.canPlayerSkipDelay else DialogueServer.defaultSettings.typewriter.canPlayerSkipDelay; 
    };
    humanoid = {
      shouldLookAtPlayer = if dialogueServerSettings and dialogueServerSettings.humanoid and dialogueServerSettings.humanoid.shouldLookAtPlayer ~= nil then dialogueServerSettings.humanoid.shouldLookAtPlayer else DialogueServer.defaultSettings.humanoid.shouldLookAtPlayer; 
      neckRotationMaxX = if dialogueServerSettings and dialogueServerSettings.humanoid and dialogueServerSettings.humanoid.neckRotationMaxX ~= nil then dialogueServerSettings.humanoid.neckRotationMaxX else DialogueServer.defaultSettings.humanoid.neckRotationMaxX;
      neckRotationMaxY = if dialogueServerSettings and dialogueServerSettings.humanoid and dialogueServerSettings.humanoid.neckRotationMaxY ~= nil then dialogueServerSettings.humanoid.neckRotationMaxY else DialogueServer.defaultSettings.humanoid.neckRotationMaxY; 
      neckRotationMaxZ = if dialogueServerSettings and dialogueServerSettings.humanoid and dialogueServerSettings.humanoid.neckRotationMaxZ ~= nil then dialogueServerSettings.humanoid.neckRotationMaxZ else DialogueServer.defaultSettings.humanoid.neckRotationMaxZ; 
    };
    promptRegion = {
      basePart = if dialogueServerSettings and dialogueServerSettings.promptRegion then dialogueServerSettings.promptRegion.basePart else DialogueServer.defaultSettings.promptRegion.basePart; 
    };
    timeout = {	
      seconds = if dialogueServerSettings and dialogueServerSettings.timeout and dialogueServerSettings.timeout.seconds ~= nil then dialogueServerSettings.timeout.seconds else DialogueServer.defaultSettings.timeout.seconds; 
      shouldWaitForResponse = if dialogueServerSettings and dialogueServerSettings.timeout and dialogueServerSettings.timeout.shouldWaitForResponse ~= nil then dialogueServerSettings.timeout.shouldWaitForResponse else DialogueServer.defaultSettings.timeout.shouldWaitForResponse; 
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

  local dialogueServer: DialogueServer = {
    toggleTriggers = toggleTriggers;
    instance = instance;
    settings = settings;
  };

  -- Set up the prompt regions.
  local parent = dialogueServer.instance.Parent;
  assert(parent, "[Dialogue Maker]: The parent of the dialogue server instance is nil. Please check your setup.");

  -- Almost there: it's time for the click detectors.
  local clickDetector = dialogueServer.settings.clickDetector.instance;
  if dialogueServer.settings.clickDetector.shouldAutoCreate then

    local clickDetectorTemp = Instance.new("ClickDetector");
    clickDetectorTemp.Parent = dialogueServer.instance.Parent;
    clickDetector = clickDetectorTemp;

  end;
  
  dialogueServer.clickDetector = clickDetector;

  return dialogueServer;

end;

return DialogueServer;