--!strict

local StarterPlayer = game:GetService("StarterPlayer");
local Players = game:GetService("Players");

local packages = StarterPlayer.StarterPlayerScripts.DialogueClientScript.roblox_packages;
local Dialogue = require(packages.dialogue);
local DialogueMakerTypes = require(packages.dialogue_maker_types);

type Client = DialogueMakerTypes.Client;
type Dialogue = DialogueMakerTypes.Dialogue;
type Page = DialogueMakerTypes.Page;
type OptionalDialogueSettings = DialogueMakerTypes.OptionalDialogueSettings;

local function getContent(self: Dialogue): Page

  local player = Players.LocalPlayer;
  return {`Hi {player.Name}!`};

end;

local function verifyCondition(self: Dialogue): boolean

  return true;

end;

local function runInitializationAction()

  -- This runs before the current message is displayed.

end;

local function runCompletionAction(self: Dialogue, client: Client, requestedDialogue: Dialogue?): ()

  -- This runs before the next message is displayed.
  local nextDialogue = requestedDialogue or self:findNextVerifiedDialogue();
  client:setDialogue(nextDialogue);

end;

local dialogueSettings: OptionalDialogueSettings = {};
local dialogue = Dialogue.new({
  getContent = getContent;
  verifyCondition = verifyCondition;
  runInitializationAction = runInitializationAction;
  runCompletionAction = runCompletionAction;
  settings = dialogueSettings;
}, script);

return dialogue;