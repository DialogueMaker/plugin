--!strict

local DialogueClient = require(script.Classes.DialogueClient);
local IDialogueClient = require(script.Interfaces.DialogueClient);
local IDialogueServer = require(script.Interfaces.DialogueServer);

local initializeClickDetectorTrigger = require(script.Triggers.ClickDetectorTrigger);
local initializePromptRegionTrigger = require(script.Triggers.PromptRegionTrigger);
local initializeProximityPromptTrigger = require(script.Triggers.ProximityPromptTrigger);
local initializeSpeechBubbleTrigger = require(script.Triggers.SpeechBubbleTrigger);

type DialogueServer = IDialogueServer.DialogueServer;
type OptionalDialogueClientSettings = IDialogueClient.OptionalDialogueClientSettings;

local dialogueClientSettings: OptionalDialogueClientSettings = {};
local dialogueClient = DialogueClient.new(dialogueClientSettings);
DialogueClient:setSharedDialogueClient(dialogueClient);

for _, initialize in {initializeClickDetectorTrigger, initializePromptRegionTrigger, initializeProximityPromptTrigger, initializeSpeechBubbleTrigger} do

  task.spawn(function()
    
    initialize(dialogueClient);

  end);

end