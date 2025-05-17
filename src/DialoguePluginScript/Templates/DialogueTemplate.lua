--!strict

local Players = game:GetService("Players");
local StarterPlayer = game:GetService("StarterPlayer");

local DialogueClientScript = StarterPlayer.StarterPlayerScripts.DialogueClientScript;
local Dialogue = require(DialogueClientScript.Classes.Dialogue);

function verifyCondition(): boolean

  return true;

end;

function getContent(): {string}

  local player = Players.LocalPlayer;
  return {`Hi {player.Name}!`};

end;

function runAction(): ()

end;

return Dialogue.new({
  getContent = getContent,
  verifyCondition = verifyCondition,
  runAction = runAction,
});