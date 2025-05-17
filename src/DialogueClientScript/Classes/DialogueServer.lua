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
    
    if self.speechBubble then

      self.speechBubble.Enabled = enabled;

    end;

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

  local dialogueOwner: DialogueServer = {
    toggleTriggers = toggleTriggers;
    instance = instance;
    settings = dialogueServerSettings;
  };
    
  -- Set up speech bubbles.
  if dialogueOwner.settings.speechBubble.enabled then

    local speechBubblePart = properties.settings.speechBubble.location;
    if speechBubblePart and speechBubblePart:IsA("BasePart") then

      -- Listen if the player clicks the speech bubble
      local speechBubble = Instance.new("BillboardGui");
      speechBubble.Name = "SpeechBubble";
      speechBubble.Active = true;
      speechBubble.LightInfluence = 0;
      speechBubble.ResetOnSpawn = false;
      speechBubble.Size = properties.settings.speechBubble.Size;
      speechBubble.StudsOffset = properties.settings.speechBubble.StudsOffset;
      speechBubble.Adornee = properties.settings.speechBubble.BasePart;

      local speechBubbleButton = Instance.new("ImageButton");
      speechBubbleButton.BackgroundTransparency = 1;
      speechBubbleButton.BorderSizePixel = 0;
      speechBubbleButton.Name = "SpeechBubbleButton";
      speechBubbleButton.Size = UDim2.fromScale(1, 1);
      speechBubbleButton.Image = properties.settings.speechBubble.image;
      speechBubbleButton.Parent = instance.Parent;
      speechBubble.Parent = PlayerGui;

      dialogueServer.speechBubble = speechBubble;

    else

      warn("[Dialogue Maker]: The speechBubblePart for " .. npc.Name .. " is not a Part.");

    end;

  end;

  -- Next, the prompt regions.
  if dialogueOwner.settings.promptRegion.enabled then

    local PromptRegionPart = dialogueSettings.promptRegion.location;
    if PromptRegionPart and PromptRegionPart:IsA("BasePart") then

      PromptRegionPart.Touched:Connect(function(part)

        -- Make sure our player touched it and not someone else
        local PlayerFromCharacter = Players:GetPlayerFromCharacter(part.Parent);
        if PlayerFromCharacter == Player then

          api.dialogue:readDialogue(npc, dialogueSettings);

        end;

      end);

    else

      warn("[Dialogue Maker]: The PromptRegionPart for " .. npc.Name .. " is not a Part.");

    end;

  end;

  -- Now, the proximity prompts.
  if dialogueOwner.settings.proximityPrompt.enabled then

    local proximityPrompt = properties.settings.proximityPrompt.location;
    if properties.settings.proximityPrompt.autoCreate then

      local proximityPromptTemp = Instance.new("ProximityPrompt");
      proximityPromptTemp.Parent = instance.Parent;
      proximityPrompt = proximityPromptTemp;

    end;

    if proximityPrompt and proximityPrompt:IsA("ProximityPrompt") then

      api.triggers:addProximityPrompt(npc, ProximityPrompt);

    else

      warn("[Dialogue Maker]: The proximity prompt location for " .. npc.Name .. " is not a ProximityPrompt.");

    end;

  end;

  -- Almost there: it's time for the click detectors.
  if dialogueOwner.settings.clickDetector.enabled then

    local ClickDetector = dialogueSettings.clickDetector.location;
    if dialogueSettings.clickDetector.autoCreate then

      local ClickDetectorTemp = Instance.new("ClickDetector");
      ClickDetectorTemp.Parent = npc;
      ClickDetector = ClickDetectorTemp;

    end;

    if ClickDetector and ClickDetector:IsA("ClickDetector") then

      api.triggers:addClickDetector(npc, ClickDetector);

      ClickDetector.MouseClick:Connect(function()
        
        readDialogue(npc, dialogueSettings);
        
      end);

    else

      warn("[Dialogue Maker]: The ClickDetectorLocation for " .. npc.Name .. " is not a ClickDetector.");

    end;

  end;

  return dialogueOwner;

end;

return DialogueServer;