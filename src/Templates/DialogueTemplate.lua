--!strict

local Players = game:GetService("Players");

local loaderScript;
for _, possibleScript in Players.LocalPlayer.PlayerScripts:GetDescendants() do

  if possibleScript:HasTag("DialogueMaker_Loader") then
    
    loaderScript = possibleScript;
    break;

  end;

end;

local packages = loaderScript.roblox_packages;
local Dialogue = require(packages.dialogue);
local IDialogue = require(packages.dialogue_types);
local IEffect = require(packages.effect_types);

type Dialogue = IDialogue.Dialogue;
type Page = IEffect.Page;
type OptionalDialogueSettings = IDialogue.OptionalDialogueSettings;

local function verifyCondition(self: Dialogue): boolean

  return true;

end;

local function getContent(self: Dialogue): Page

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