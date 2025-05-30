--!strict

local Players = game:GetService("Players");

local packages = Players.LocalPlayer.PlayerScripts.DialogueClientScript.roblox_packages;
local DialogueServer = require(packages.dialogue_server);

-- See documentation: https://github.com/DialogueMaker/dialogue_server
local dialogueServer = DialogueServer.new({}, script);

return dialogueServer; 
