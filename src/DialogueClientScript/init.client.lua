--!strict

local DialogueClient = require(script.Classes.DialogueClient);
local IDialogueServer = require(script.Interfaces.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;

local dialogueClient = DialogueClient.new();
DialogueClient:setSharedObject(dialogueClient);