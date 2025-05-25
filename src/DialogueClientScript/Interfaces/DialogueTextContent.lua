--!strict

local DialogueClientScript = script.Parent.Parent;
local IDialogueContentFitter = require(DialogueClientScript.Interfaces.DialogueContentFitter);

type Page = IDialogueContentFitter.Page;

export type DialogueTextContent = DialogueTextContentProperties & DialogueTextContentMethods;

export type DialogueTextContentProperties = {
  text: string;
};

export type DialogueTextContentMethods = {
  getPages: (self: DialogueTextContent, contentContainer: GuiObject, pages: {Page}, currentPage: Page) -> {Page};
};

return {};