--!strict

local CollectionService = game:GetService("CollectionService");
local DialogueClient = require(script.Classes.DialogueClient);
local IDialogueServer = require(script.Interfaces.DialogueServer);

local Types = require(script.Types);
local dialogueServers: {DialogueServer} = {};

local dialogueClient = DialogueClient.new({

  -- [ Theme Settings ] --
  defaultTheme = "StandardTheme";

  -- [ Response Settings ] --
  showResponsesAfterMessageFinished = true; 
  defaultClickSound = 0; 

  -- [ Chat Triggers and Keybinds ] --
  minimumDistanceFromCharacter = 10; 
  keybindsEnabled = true; 
  defaultChatTriggerKey = Enum.KeyCode.F; 
  defaultChatTriggerKeyGamepad = Enum.KeyCode.ButtonX; 
  defaultChatContinueKey = Enum.KeyCode.F; 
  defaultChatContinueKeyGamepad = Enum.KeyCode.ButtonA; 

});

local function readDialogue(NPC: Model, npcSettings: Types.NPCSettings)
  
  
  
  -- Let the Dialogue module handle it.
  api.dialogue:readDialogue(NPC, npcSettings);
  
  -- Clean up.
  for _, dialogueServer in dialogueServers do

    dialogueServer:toggleTriggers(true);

  end;
  if freezePlayer then 

    api.player:unfreezePlayer(); 

  end;
  
end

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
