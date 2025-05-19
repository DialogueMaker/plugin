--!strict
-- Automatically triggers the dialogue server when the player touches a prompt region.
--
-- Programmers: Christian Toney (Christian_Toney)
-- © 2023 – 2025 Dialogue Maker Group

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local StarterPlayer = game:GetService("StarterPlayer");

local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts");
local DialogueClient = require(StarterPlayerScripts.DialogueClientScript.Classes.DialogueClient);
local IDialogueServer = require(StarterPlayerScripts.DialogueClientScript.Interfaces.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;

local dialogueClient = DialogueClient.getFromSharedObject(true);

for _, dialogueServerModuleScript in CollectionService:GetTagged("DialogueMaker_DialogueServer") do

  local didInitialize, errorMessage = pcall(function()

    -- We're using pcall because require can throw an error if the module is invalid.
    local dialogueServer = require(dialogueServerModuleScript) :: DialogueServer;

    local promptRegionPart = dialogueServer.settings.promptRegion.basePart;
    if promptRegionPart then

      promptRegionPart.Touched:Connect(function(part)

        -- Make sure our player touched it and not someone else
        local PlayerFromCharacter = Players:GetPlayerFromCharacter(part.Parent);
        if PlayerFromCharacter == Players.LocalPlayer and not dialogueClient.dialogueServer then

          dialogueClient:interact(dialogueServer);

        end;

      end);

    end;

  end);

  if not didInitialize then

    local fullName = dialogueServerModuleScript:GetFullName();
    warn(`[Dialogue Maker] Failed to initialize prompt region for {fullName}: {errorMessage}`);

  end;

end;