--!strict

local CollectionService = game:GetService("CollectionService");
local DialogueClient = require(script.Classes.DialogueClient);
local IDialogueServer = require(script.Interfaces.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;

local dialogueClient = DialogueClient.new({});

print("[Dialogue Maker]: Preparing dialogue...");
for _, dialogueServerModuleScript in CollectionService:GetTagged("DialogueMaker_DialogueServer") do
  
  local didInitializeDialogueServer, errorMessage = pcall(function()

    local dialogueServer = require(dialogueServerModuleScript) :: DialogueServer;
    dialogueClient:addDialogueServer(dialogueServer);

  end);

  if not didInitializeDialogueServer then

    warn(`[Dialogue Maker]: {errorMessage}`);

  end;

end;

print("[Dialogue Maker]: Finished preparing dialogue.");
