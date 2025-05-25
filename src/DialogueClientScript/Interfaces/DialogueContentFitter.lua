--!strict

local IEffect = require(script.Parent.Effect);

type Effect = IEffect.Effect;
type Page = IEffect.Page;

export type DialogueContentFitter = DialogueContentFitterProperties & DialogueContentFitterMethods;

export type DialogueContentFitterMethods = {
  getPages: (self: DialogueContentFitter, rawPage: Page) -> ({Page});
}

export type DialogueContentFitterProperties = {
  textLabel: TextLabel;
  contentContainer: GuiObject;
}

export type RichTextTag = {
  attributes: string?;
  endOffset: number?;
  name: string;
  startOffset: number;
}

return {};