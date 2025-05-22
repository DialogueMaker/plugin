--!strict

export type Content = string;

export type Dialogue = {

  type: "Message" | "Response" | "Redirect";

  redirectModuleScript: ModuleScript?;

  --[[
    ]]
  theme: ModuleScript?;

  --[[
    This is the code that's ran when the dialogue is shown.
    If this is a message or a response, then the string array will be the message or response content.

    The dialogue box will be blank until this function returns.

    This function returns an array instead of a string because Dialogue Maker will support text effects in the future.

    This function does not run if the dialogue is a redirect.
  ]]
  getContent: (self: Dialogue) -> {Content};

  --[[
    In order for this dialogue to show, the condition must pass by returning true. 
    Otherwise, lower priority dialogue will be used. 
  ]]
  verifyCondition: (self: Dialogue) -> boolean;

  --[[
    This is the code that's ran when the action is called.

    This function does not run if the dialogue is a redirect.
  ]]
  runAction: (self: Dialogue, actionID: number) -> ();

  getSettings: (self: Dialogue) -> DialogueSettings;

  setSettings: (self: Dialogue, newSettings: DialogueSettings) -> ();

  getChildren: (self: Dialogue) -> {Dialogue};

  moduleScript: ModuleScript;
  
};

export type DialogueSettings = {
  timeout: TimeoutDialogueSettings;
  typewriter: TypewriterDialogueSettings;
}

export type OptionalDialogueSettings = {
  timeout: OptionalTimeoutDialogueSettings?;
  typewriter: OptionalTypewriterDialogueSettings?;
}

export type OptionalTimeoutDialogueSettings = {
  -- Set this to the amount of seconds you want to wait before closing the dialogue.
  seconds: number?;
  -- If true, this causes dialogue to ignore the set timeout in order to wait for the player's response. 
  shouldWaitForResponse: boolean?;
}

export type OptionalTypewriterDialogueSettings = {
  -- The delay between each letter being typed. 
  characterDelaySeconds: number?;
  -- If true, the player can skip the typing delay by pressing a keybind or clicking the theme. 
  canPlayerSkipDelay: boolean?;
  shouldShowResponseWhileTyping: boolean?;
}

export type TimeoutDialogueSettings = {
  -- Set this to the amount of seconds you want to wait before closing the dialogue.
  seconds: number?; 
  -- If true, this causes dialogue to ignore the set timeout in order to wait for the player's response. 
  shouldWaitForResponse: boolean; 
}

export type TypewriterDialogueSettings = {
  -- The delay between each letter being typed. 
  characterDelaySeconds: number; 
  -- If true, the player can skip the typing delay by pressing a keybind or clicking the theme. 
  canPlayerSkipDelay: boolean;
  shouldShowResponseWhileTyping: boolean;
}

return {};