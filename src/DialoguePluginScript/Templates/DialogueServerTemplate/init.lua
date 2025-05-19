--!strict

local StarterPlayer = game:GetService("StarterPlayer");

local DialogueServer = require(StarterPlayer.StarterPlayerScripts.DialogueClientScript.Classes.DialogueServer);

local dialogueServer = DialogueServer.new({}, script);

return dialogueServer; 
