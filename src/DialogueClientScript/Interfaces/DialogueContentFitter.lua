--!strict

local IDialogue = require(script.Parent.Dialogue);
local IEffect = require(script.Parent.Effect);

type DialogueContent = IDialogue.DialogueContent;
type Effect = IEffect.Effect;

export type DialogueContentFitter = DialogueContentFitterProperties & DialogueContentFitterMethods;

export type DialogueContentFitterMethods = {
  getPages: (self: DialogueContentFitter, rawPage: Page) -> ({Page});
}

export type DialogueContentFitterProperties = {
  textLabel: TextLabel;
  contentContainer: GuiObject;
}

export type Page = {string | Effect}

export type RichTextTag = {
  attributes: string?;
  endOffset: number?;
  name: string;
  startOffset: number;
}

return {};