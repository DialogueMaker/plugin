--!strict

local DialogueClient = require(script.Classes.DialogueClient);
local IDialogueClient = require(script.Interfaces.DialogueClient);
local IDialogueServer = require(script.Interfaces.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;
type OptionalDialogueClientSettings = IDialogueClient.OptionalDialogueClientSettings;

local dialogueClientSettings: OptionalDialogueClientSettings = {};
local dialogueClient = DialogueClient.new(dialogueClientSettings, script);
DialogueClient:setSharedDialogueClient(dialogueClient);