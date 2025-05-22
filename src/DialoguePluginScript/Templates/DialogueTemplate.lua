--!strict

local Players = game:GetService("Players");
local StarterPlayer = game:GetService("StarterPlayer");

local DialogueClientScript = StarterPlayer.StarterPlayerScripts.DialogueClientScript;
local Dialogue = require(DialogueClientScript.Classes.Dialogue);
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);

type Dialogue = IDialogue.Dialogue;
type Content = IDialogue.Content;
type OptionalDialogueSettings = IDialogue.OptionalDialogueSettings;

local function verifyCondition(self: Dialogue): boolean

  return true;

end;

local function getContent(self: Dialogue): {Content}

  local player = Players.LocalPlayer;
  return {`Hi {player.Name}!`};

end;

local function runAction(self: Dialogue, actionID: number): ()

  if actionID == 1 then

    -- This runs before the current message is displayed.

  elseif actionID == 2 then

    -- This runs before the next message is displayed.

  end;

end;

local dialogueSettings: OptionalDialogueSettings = {};
local dialogue = Dialogue.new({
  getContent = getContent;
  verifyCondition = verifyCondition;
  runAction = runAction;
  settings = dialogueSettings;
}, script);

return dialogue;