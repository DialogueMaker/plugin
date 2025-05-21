--!strict
-- Automatically triggers the dialogue server when the player activates a click detector.
--
-- Programmers: Christian Toney (Christian_Toney)
-- © 2023 – 2025 Dialogue Maker Group

local CollectionService = game:GetService("CollectionService");
local StarterPlayer = game:GetService("StarterPlayer");

local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts");
local IDialogueClient = require(StarterPlayerScripts.DialogueClientScript.Interfaces.DialogueClient);
local IDialogueServer = require(StarterPlayerScripts.DialogueClientScript.Interfaces.DialogueServer);

type DialogueClient = IDialogueClient.DialogueClient;
type DialogueServer = IDialogueServer.DialogueServer;

return function(dialogueClient: DialogueClient)

  for _, dialogueServerModuleScript in CollectionService:GetTagged("DialogueMaker_DialogueServer") do

    local didInitialize, errorMessage = pcall(function()

      -- We're using pcall because require can throw an error if the module is invalid.
      local dialogueServer = require(dialogueServerModuleScript) :: DialogueServer;
      local dialogueServerSettings = dialogueServer:getSettings();
      local proximityPrompt = dialogueServerSettings.proximityPrompt.instance;
      if dialogueServerSettings.proximityPrompt.shouldAutoCreate then

        local autoCreatedProximityPrompt = Instance.new("ProximityPrompt");
        autoCreatedProximityPrompt.Parent = dialogueServer.moduleScript.Parent;
        proximityPrompt = autoCreatedProximityPrompt;

      end;

      if proximityPrompt then

        proximityPrompt.Triggered:Connect(function()

          proximityPrompt.Enabled = false;
          dialogueClient:interact(dialogueServer);

        end);

        dialogueClient.DialogueServerChanged:Connect(function()

          if dialogueClient.dialogueServer == nil then

            proximityPrompt.Enabled = true;

          else

            proximityPrompt.Enabled = false;

          end;

        end);

      end;

    end);

    if not didInitialize then

      local fullName = dialogueServerModuleScript:GetFullName();
      warn(`[Dialogue Maker] Failed to initialize proximity prompt for {fullName}: {errorMessage}`);

    end;

  end;

end;