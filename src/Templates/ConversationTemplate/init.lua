--!strict

local StarterPlayer = game:GetService("StarterPlayer");

local packages = StarterPlayer.StarterPlayerScripts.DialogueClientScript.roblox_packages;

local Conversation = require(packages.conversation);

-- See documentation: https://github.com/DialogueMaker/conversation
local conversation = Conversation.new({}, script);

return conversation; 
