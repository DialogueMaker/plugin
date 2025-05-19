--!strict

export type ClickDetectorDialogueServerSettings = {
  -- If true, this automatically creates a ClickDetector inside of the NPC's model. 
  shouldAutoCreate: boolean; 
  -- If true, the ClickDetector's parent will be nil until the dialogue is over. This hides the cursor from the player. 
  shouldDisappearDuringConversation: boolean; 
  -- Replace this with the location of the ClickDetector. (Ex. workspace.Model.ClickDetector) This setting will be ignored if AutomaticallyCreateClickDetector is true. 
  instance: ClickDetector?;
  adornee: Instance?;
}

export type DialogueServerSettings = {
  clickDetector: ClickDetectorDialogueServerSettings;
  general: GeneralDialogueServerSettings;
  humanoid: HumanoidDialogueServerSettings;
  promptRegion: PromptRegionDialogueServerSettings;
  proximityPrompt: ProximityPromptDialogueServerSettings;
  speechBubble: SpeechBubbleDialogueServerSettings;
  timeout: TimeoutDialogueServerSettings;
  typewriter: TypewriterDialogueServerSettings;
}

export type GeneralDialogueServerSettings = {
  --[[
    The character's name. Themes may show this name to the player during the conversation.
  ]]
  name: string?;

  --[[
    Change this to a theme you've added to the Themes folder in order to override default theme settings.
  ]]
  theme: ModuleScript?;

  -- If true, the player will freeze when the dialogue starts and will be unfrozen when the dialogue ends.
  shouldFreezePlayer: boolean; 
  -- If true, the conversation will end if the PrimaryParts of the NPC and the player exceed the MaximumConversationDistance.
  shouldEndConversationIfOutOfDistance: boolean;
  -- Maximum magnitude between the NPC's HumanoidRootPart and the player's PrimaryPart before the conversation ends. Requires EndConversationIfOutOfDistance to be true.
  maxConversationDistance: number;
}

export type HumanoidDialogueServerSettings = {
  -- If true, the NPC will look at the player during the conversation.
  shouldLookAtPlayer: boolean; 
  -- The maximum angle of the NPC's neck on the X axis. Requires NPCLooksAtPlayerDuringDialogue to be true. 
  neckRotationMaxX: number;
  -- The maximum angle of the NPC's neck on the Y axis. Requires NPCLooksAtPlayerDuringDialogue to be true. 
  neckRotationMaxY: number; 
  -- The maximum angle of the NPC's neck on the Z axis. Requires NPCLooksAtPlayerDuringDialogue to be true.
  neckRotationMaxZ: number; 
}

export type OptionalDialogueServerSettings = {
  general: {
    --[[
      The character's name. Themes may show this name to the player during the conversation.
    ]]
    name: string?;

    --[[
      Change this to a theme you've added to the Themes folder in order to override default theme settings.
    ]]
    theme: ModuleScript?;

    -- If true, the player will freeze when the dialogue starts and will be unfrozen when the dialogue ends.
    shouldFreezePlayer: boolean?; 
    -- If true, the conversation will end if the PrimaryParts of the NPC and the player exceed the MaximumConversationDistance.
    shouldEndConversationIfOutOfDistance: boolean?;
    -- Maximum magnitude between the NPC's HumanoidRootPart and the player's PrimaryPart before the conversation ends. Requires EndConversationIfOutOfDistance to be true.
    maxConversationDistance: number?;
  }?;
  typewriter: {
    -- The delay between each letter being typed. 
    characterDelaySeconds: number?; 
    -- If true, the player can skip the typing delay by pressing a keybind or clicking the theme. 
    canPlayerSkipDelay: boolean?; 
  }?;
  humanoid: {
    -- If true, the NPC will look at the player during the conversation.
    shouldLookAtPlayer: boolean?; 
    -- The maximum angle of the NPC's neck on the X axis. Requires NPCLooksAtPlayerDuringDialogue to be true. 
    neckRotationMaxX: number?;
    -- The maximum angle of the NPC's neck on the Y axis. Requires NPCLooksAtPlayerDuringDialogue to be true. 
    neckRotationMaxY: number?; 
    -- The maximum angle of the NPC's neck on the Z axis. Requires NPCLooksAtPlayerDuringDialogue to be true.
    neckRotationMaxZ: number?; 
  }?;
  promptRegion: {
    -- The conversation will automatically start when the player touches this part.
    basePart: BasePart?; 
  }?;
  timeout: {
    -- Set this to the amount of seconds you want to wait before closing the dialogue. 
    -- [accepts number >= 0]
    seconds: number?; 
    -- If true, this causes dialogue to ignore the set timeout in order to wait for the player's response. 
    shouldWaitForResponse: boolean?; 
  }?;
  clickDetector: {
    -- If true, this automatically creates a ClickDetector inside of the NPC's model. 
    shouldAutoCreate: boolean?; 
    -- If true, the ClickDetector's parent will be nil until the dialogue is over. This hides the cursor from the player. 
    shouldDisappearDuringConversation: boolean?; 
    -- Replace this with the location of the ClickDetector. (Ex. workspace.Model.ClickDetector) This setting will be ignored if AutomaticallyCreateClickDetector is true. 
    instance: ClickDetector?;
    adornee: Instance?;
  }?;
  proximityPrompt: {
    -- If true, this automatically creates a ProximityPrompt inside of the NPC's model.
    shouldAutoCreate: boolean?; 
    -- The location of the ProximityPrompt. (Ex. workspace.Model.ProximityPrompt) This setting will be ignored if AutoCreate is true. 
    instance: ProximityPrompt?; 
  }?;
  speechBubble: {
    -- If true, this automatically creates a BillboardGui inside of the NPC's model.
    shouldAutoCreate: boolean?; 
    adornee: Instance?;
    button: GuiButton?;
    billboardGUI: BillboardGui?;
  }?;
}

export type PromptRegionDialogueServerSettings = {
  -- The conversation will automatically start when the player touches this part.
  basePart: BasePart?; 
}

export type ProximityPromptDialogueServerSettings = {
  -- If true, this automatically creates a ProximityPrompt inside of the NPC's model.
  shouldAutoCreate: boolean; 
  -- The location of the ProximityPrompt. (Ex. workspace.Model.ProximityPrompt) This setting will be ignored if AutoCreate is true. 
  instance: ProximityPrompt?; 
}

export type SpeechBubbleDialogueServerSettings = {
  -- If true, this automatically creates a BillboardGui inside of the NPC's model.
  shouldAutoCreate: boolean; 
  adornee: Instance?;
  button: GuiButton?;
  billboardGUI: BillboardGui?;
}

export type TimeoutDialogueServerSettings = {
  -- Set this to the amount of seconds you want to wait before closing the dialogue.
  seconds: number?; 
  -- If true, this causes dialogue to ignore the set timeout in order to wait for the player's response. 
  shouldWaitForResponse: boolean; 
}

export type TypewriterDialogueServerSettings = {
  -- The delay between each letter being typed. 
  characterDelaySeconds: number; 
  -- If true, the player can skip the typing delay by pressing a keybind or clicking the theme. 
  canPlayerSkipDelay: boolean; 
}

export type DialogueServerProperties = {
  settings: DialogueServerSettings;
};

export type DialogueServerMethods = {
};

export type DialogueServer = DialogueServerProperties & DialogueServerMethods;

return {}