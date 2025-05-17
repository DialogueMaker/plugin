--!strict

local Players = game:GetService("Players");

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
  if dialogueServer.settings.promptRegion.enabled then

    local PromptRegionPart = dialogueServer.settings.promptRegion.location;
    if PromptRegionPart and PromptRegionPart:IsA("BasePart") then

      PromptRegionPart.Touched:Connect(function(part)

        -- Make sure our player touched it and not someone else
        local PlayerFromCharacter = Players:GetPlayerFromCharacter(part.Parent);
        if PlayerFromCharacter == player then

          api.dialogue:readDialogue(npc, dialogueSettings);

        end;

      end);

    else

      warn("[Dialogue Maker]: The PromptRegionPart for " .. npc.Name .. " is not a Part.");

    end;

  end;

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

      warn("[Dialogue Maker]: The proximity prompt location for " .. dialogueServer.instance.Name .. " is not a ProximityPrompt.");

    end;

  end;

  -- Almost there: it's time for the click detectors.
  if dialogueServer.settings.clickDetector.enabled then

    local ClickDetector = dialogueServer.settings.clickDetector.location;
    if dialogueServer.settings.clickDetector.autoCreate then

      local ClickDetectorTemp = Instance.new("ClickDetector");
      ClickDetectorTemp.Parent = dialogueServer.instance.Parent;
      ClickDetector = ClickDetectorTemp;

    end;

    if ClickDetector and ClickDetector:IsA("ClickDetector") then

      

      ClickDetector.MouseClick:Connect(function()
        
        readDialogue(npc, dialogueSettings);
        
      end);

    else

      warn("[Dialogue Maker]: The ClickDetectorLocation for " .. npc.Name .. " is not a ClickDetector.");

    end;

  end;

  return dialogueServer;

end;

return DialogueServer;