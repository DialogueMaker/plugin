--!strict

local IEffect = require(script.Parent.Effect);
local IDialogue = require(script.Parent.Dialogue);

type Effect = IEffect.Effect;
type Content = IDialogue.Content;

export type DialogueContentFitter = DialogueContentFitterProperties & DialogueContentFitterMethods;

export type DialogueContentFitterMethods = {
  getPages: (self: DialogueContentFitter, content: {Content}) -> ({Page});
}

export type DialogueContentFitterProperties = {
  textLabel: TextLabel;
  textContainer: GuiObject;
}

export type Page = {
  {
    type: "Text"; 
    text: string; 
  } | Effect
};

export type RichTextTag = {
  attributes: string?;
  endOffset: number?;
  name: string;
  startOffset: number;
}

return {};