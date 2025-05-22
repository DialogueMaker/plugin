--!strict

local StarterPlayer = game:GetService("StarterPlayer");

local DialogueServer = require(StarterPlayer.StarterPlayerScripts.DialogueClientScript.Classes.DialogueServer);

-- See documentation: https://github.com/DialogueMaker/plugin/blob/a9f39cc11f9b33cece65dc2b48d6544b638f5575/src/DialogueClientScript/Classes/DialogueServer/README.md
local dialogueServer = DialogueServer.new({}, script);

return dialogueServer; 
