--!strict

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");

local player = game:GetService("Players").LocalPlayer;
local playerGUI = player:WaitForChild("PlayerGui");
local DialogueClientScript = script.Parent.Parent;

local DialogueServer = {};

export type ConstructorProperties = {
}

function DialogueServer.new(properties: ConstructorProperties, instance: ModuleScript): DialogueServer

  -- @since v5.0.0
  local function getTheme(self: DialogueServer, useDefaultIfNotFound: boolean?): ModuleScript

    -- Check if we have the theme
    local ThemeFolder = DialogueClientScript.Themes;
    local themeModuleScript = ThemeFolder:FindFirstChild(themeName);
    if themeName and not themeModuleScript and useDefaultIfNotFound then

      if themeName ~= "" then

        warn("[Dialogue Maker]: Can't find theme \"" .. themeName .. "\" in the Themes folder of the DialogueClientScript. Using default theme...");

      end

      themeModuleScript = ThemeFolder:FindFirstChild(clientSettings.defaultTheme);

    end

    -- Return the theme module script.
    assert(themeModuleScript, "There isn't an available theme.");
    return themeModuleScript;

  end;

  local function toggleTriggers(self: DialogueServer, enabled: boolean): ()
    
    if self.speechBubble then

      self.speechBubble.Enabled = enabled;

    end;

    if self.proximityPrompt then

      self.proximityPrompt.Enabled = enabled;

    end;

    if self.clickDetector then

      self.clickDetector.Enabled = enabled;

    end;

  end;

  local dialogueOwner = {
    getTheme = getTheme;
    instance = instance;
  };
    
    -- Set up speech bubbles.
    if properties.settings.speechBubble.enabled then

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
    if properties.settings.promptRegion.enabled then

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
    if properties.settings.proximityPrompt.enabled then

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
    if dialogueSettings.clickDetector.enabled then

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

    -- Finally, the keybinds.
    if clientSettings.keybindsEnabled then

      local CanPressButton = false;
      local ReadDialogueWithKeybind;
      local defaultChatTriggerKey = clientSettings.defaultChatTriggerKey;
      local defaultChatTriggerKeyGamepad = clientSettings.defaultChatTriggerKeyGamepad;
      ReadDialogueWithKeybind = function()

        if CanPressButton and (UserInputService:IsKeyDown(defaultChatTriggerKey) or UserInputService:IsKeyDown(defaultChatTriggerKeyGamepad)) then
            
          readDialogue(npc, dialogueSettings);

        end;

      end;
      ContextActionService:BindAction("OpenDialogueWithKeybind", ReadDialogueWithKeybind, false, defaultChatTriggerKey, defaultChatTriggerKeyGamepad);

      -- Check if the player is in range
      RunService.Heartbeat:Connect(function()

        CanPressButton = Player:DistanceFromCharacter(npc:GetPivot().Position) < clientSettings.minimumDistanceFromCharacter;

      end);

    end;

  return dialogueOwner;

end;

function TriggerModule:createspeechBubble(npc: Model, properties: {[string]: any}): BillboardGui

  

  return speechBubbles[npc];

end;

function TriggerModule:disableAllspeechBubbles(): ()

  for _, speechBubble in pairs(speechBubbles) do

    speechBubble.Enabled = false;

  end;

end;

function TriggerModule:enableAllspeechBubbles(): ()

  for _, speechBubble in pairs(speechBubbles) do

    speechBubble.Enabled = true;

  end;

end;

function TriggerModule:addClickDetector(npc: Model, clickDetector: ClickDetector): ()

  ClickDetectors[npc] = clickDetector;

end;

function TriggerModule:addProximityPrompt(npc: Model, proximityPrompt: ProximityPrompt): ()

  ProximityPrompts[npc] = proximityPrompt

end

function TriggerModule:disableAllClickDetectors(): ()

  for _, clickDetector in pairs(ClickDetectors) do

    -- Keep track of the original parent
    local OriginalParentTag = Instance.new("ObjectValue");
    OriginalParentTag.Name = "OriginalParent"
    OriginalParentTag.Value = clickDetector.Parent;
    OriginalParentTag.Parent = clickDetector;

    clickDetector.Parent = nil;

  end;

end;

function TriggerModule:enableAllClickDetectors(): ()

  for _, clickDetector in pairs(ClickDetectors) do
    
    local OriginalParent = clickDetector:FindFirstChild("OriginalParent");
    if OriginalParent and OriginalParent:IsA("ObjectValue") and OriginalParent.Value then

      clickDetector.Parent = OriginalParent.Value;
      OriginalParent:Destroy();

    end;

  end;

end;

function TriggerModule:disableAllProximityPrompts(): ()

  for _, proximityPrompt in pairs(ProximityPrompts) do

    -- Keep track of the original parent
    local OriginalParentTag = Instance.new("ObjectValue");
    OriginalParentTag.Name = "OriginalParent"
    OriginalParentTag.Value = proximityPrompt.Parent;
    OriginalParentTag.Parent = proximityPrompt;

    proximityPrompt.Parent = nil;

  end;
end;

function TriggerModule:enableAllProximityPrompts(): ()

  for _, proximityDetector in pairs(ProximityPrompts) do
    
    local OriginalParent = proximityDetector:FindFirstChild("OriginalParent");
    if OriginalParent and OriginalParent:IsA("ObjectValue") and OriginalParent.Value then

      proximityDetector.Parent = OriginalParent.Value;
      OriginalParent:Destroy();

    end;

  end;

end;

return DialogueOwner;