--!strict

local DialogueClientScript = script.Parent.Parent;

local IDialogueServer = require(DialogueClientScript.Interfaces.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;

local DialogueServer = {};

export type ConstructorProperties = {
}

function DialogueServer.new(dialogueServerSettings: IDialogueServer.DialogueServerSettings, instance: ModuleScript): DialogueServer

  local function toggleTriggers(self: DialogueServer, enabled: boolean): ()

    if self.proximityPrompt then

      self.proximityPrompt.Enabled = enabled;

    end;

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

  local dialogueServer: DialogueServer = {
    toggleTriggers = toggleTriggers;
    instance = instance;
    settings = dialogueServerSettings;
  };

  -- Set up the prompt regions.
  local parent = dialogueServer.instance.Parent;
  assert(parent, "[Dialogue Maker]: The parent of the dialogue server instance is nil. Please check your setup.");

  -- Now, the proximity prompts.
  if dialogueServer.settings.proximityPrompt.enabled then

    local proximityPrompt = dialogueServer.settings.proximityPrompt.location;
    if dialogueServer.settings.proximityPrompt.autoCreate then

      local proximityPromptTemp = Instance.new("ProximityPrompt");
      proximityPromptTemp.Parent = instance.Parent;
      proximityPrompt = proximityPromptTemp;

    end;

    if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then



    else

      warn(`[Dialogue Maker]: The proximity prompt location for {parent.Name} is not a ProximityPrompt.`);

    end;

  end;

  -- Almost there: it's time for the click detectors.
  if dialogueServer.settings.clickDetector.enabled then

    local clickDetector = dialogueServer.settings.clickDetector.location;
    if dialogueServer.settings.clickDetector.autoCreate then

      local clickDetectorTemp = Instance.new("ClickDetector");
      clickDetectorTemp.Parent = dialogueServer.instance.Parent;
      clickDetector = clickDetectorTemp;

    end;
    
    dialogueServer.clickDetector = clickDetector;

  end;

  return dialogueServer;

end;

return DialogueServer;