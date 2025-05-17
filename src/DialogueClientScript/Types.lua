--!strict
local React = require(script.Parent.Packages.react);
local IDialogueClient = require(script.Parent.Interfaces.DialogueClient);
local IDialogueServer = require(script.Parent.Interfaces.DialogueServer);
local IDialogue = require(script.Parent.Interfaces.Dialogue);

type Dialogue = IDialogue.Dialogue;
type DialogueClient = IDialogueClient.DialogueClient;
type DialogueServer = IDialogueServer.DialogueServer;

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

export type ThemeProperties = {
  responseContentScripts: {ModuleScript};
  dialogueClient: DialogueClient;
  dialogueServer: DialogueServer;
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

export type TextSegmentProperties = {
  text: string;
  skipPageEvent: RBXScriptSignal?;
  letterDelay: number;
  layoutOrder: number;
  textSize: number;
  onComplete: () -> ();

  --[[
     TODO: Use ref instead of ref2. Right now, ref is a reserved property. (https://github.com/jsdotlua/react-lua/issues/46) 
  ]]
  ref2: React.Ref<TextLabel>?; 
}

return {};
