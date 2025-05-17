--!strict

local CollectionService = game:GetService("CollectionService");
local DialogueClient = require(script.Classes.DialogueClient);
local IDialogueServer = require(script.Interfaces.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;

local dialogueServers: {DialogueServer} = {};

local dialogueClient = DialogueClient.new({
  theme = {
    defaultTheme = script.Themes.StandardTheme;
  };
  responses = {
    showResponsesAfterMessageFinished = true;
    defaultClickSound = 0;
  };
  triggers = {
    minimumDistanceFromCharacter = 10; 
    keybindsEnabled = true; 
    defaultChatTriggerKey = Enum.KeyCode.F; 
    defaultChatTriggerKeyGamepad = Enum.KeyCode.ButtonX; 
    defaultChatContinueKey = Enum.KeyCode.F; 
    defaultChatContinueKeyGamepad = Enum.KeyCode.ButtonA; 
  }
});

print("[Dialogue Maker]: Preparing dialogue...");
for _, dialogueServerModuleScript in CollectionService:GetTagged("DialogueMaker_DialogueServer") do
  
  local didInitializeDialogueServer, errorMessage = pcall(function()

    local dialogueServer = require(dialogueServerModuleScript) :: DialogueServer;
    table.insert(dialogueServers, dialogueServer);

  end);

  if not didInitializeDialogueServer then

    warn(`[Dialogue Maker]: {errorMessage}`);

  end;

end;

print("[Dialogue Maker]: Finished preparing dialogue.");
