--!strict
local React = require(script.Parent.Packages.react);

export type ContentArray = {string | Effect};

export type Effect = {
  
  type: "effect";
  
  run: (skipPageEvent: BindableEvent?) -> any;

  getMaxDimensions: () -> {x: number, y: number};

  getBreakpoints: () -> {number};

  onSkip: () -> any;
  
  name: string;

}

export type UseEffectFunction = (effectName: string, effectProperties: {[string]: any}) -> Effect;

export type RichTextTagInformation = {
  attributes: string?;
  endOffset: number?;
  name: string;
  startOffset: number;
}

export type NPCSettings = {

  general: {

    npcName: string; 

    showName: boolean; 

    fitName: boolean; 

    textBoundsOffset: number; 

    themeName: string; 

    letterDelay: number; 

    allowPlayerToSkipDelay: boolean; 

    freezePlayer: boolean; 

    endConversationIfOutOfDistance: boolean;

    maxConversationDistance: number;

    npcLooksAtPlayerDuringDialogue: boolean;

    npcNeckRotationMaxX: number;

    npcNeckRotationMaxY: number;

    npcNeckRotationMaxZ: number;

  };

  promptRegion: {

    enabled: boolean;

    location: BasePart?;

  };

  timeout: {

    enabled: boolean;

    seconds: number;

    waitForResponse: boolean;

  };

  speechBubble: {

    enabled: boolean;

    location: BasePart?;

  };

  clickDetector: {

    enabled: boolean;

    autoCreate: boolean;

    disappearsWhenDialogueActive: boolean;

    location: ClickDetector?;

  };

  proximityPrompt: {

    enabled: boolean;

    autoCreate: boolean;

    location: ProximityPrompt?;

  };

};

export type ClientSettings = {

  -- This is the default theme that will be used when talking with NPCs
  defaultTheme: string;

  -- Prevents the player from selecting responses without first viewing the dialogue
  showResponsesAfterMessageFinished: boolean;

  -- Replace this with an audio ID that'll play every time a player continues a conversation or selects a response. Replace with 0 to not play any sound.
  defaultClickSound: number;

  -- Minimum distance from a character required for keybinds should work
  minimumDistanceFromCharacter: number;

  -- Whether keybinds should work
  keybindsEnabled: boolean;

  -- Keyboard keybind to start a conversation with an NPC
  defaultChatTriggerKey: Enum.KeyCode;

  -- Gamepad keybind to start a conversation with an NPC
  defaultChatTriggerKeyGamepad: Enum.KeyCode;

  -- Keyboard keybind to continue a conversation with an NPC
  defaultChatContinueKey: Enum.KeyCode;

  -- Gamepad keybind to continue a conversation with an NPC
  defaultChatContinueKeyGamepad: Enum.KeyCode;
};

export type ThemeProperties = {
  responseContentScripts: {ModuleScript};
  clientSettings: ClientSettings;
  npcSettings: NPCSettings;
  dialogue: Dialogue;
  npc: Model;
  onComplete: (selectedResponseContentScript: ModuleScript?) -> ();
  onTimeout: () -> ();
}

export type Page = {
  {
    type: "text"; 
    text: string; 
    size: Vector2;
  } | Effect
};

export type Dialogue = {

  --[[
    This is the code that's ran when the dialogue is shown.
    If this is a message or a response, then the string array will be the message or response content.

    The dialogue box will be blank until this function returns.

    This function returns an array instead of a string because Dialogue Maker will support text effects in the future.

    This function does not run if the dialogue is a redirect.
  ]]
  getContent: (self: Dialogue) -> {string};

  --[[
    In order for this dialogue to show, the condition must pass by returning true. 
    Otherwise, lower priority dialogue will be used. 
  ]]
  verifyCondition: (self: Dialogue) -> boolean;

  --[[
    This is the code that's ran when the action is called.

    This function does not run if the dialogue is a redirect.
  ]]
  runAction: (self: Dialogue) -> ();
  
};

export type TextSegmentProperties = {
  text: string;
  skipPageEvent: RBXScriptSignal?;
  letterDelay: number;
  layoutOrder: number;
  textSize: number;
  onComplete: () -> ();
  ref2: React.Ref<TextLabel>?;
}

return {};
