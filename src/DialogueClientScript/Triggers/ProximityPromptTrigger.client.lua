--!strict
-- Automatically triggers the dialogue server when the player activates a proximity prompt.
--
-- Programmers: Christian Toney (Christian_Toney)
-- © 2023 – 2025 Dialogue Maker Group

local CollectionService = game:GetService("CollectionService");
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

    local clickDetector = dialogueServer.settings.clickDetector.instance;
    if dialogueServer.settings.clickDetector.shouldAutoCreate then

      assert(dialogueServer.settings.clickDetector.adornee, "ClickDetector adornee must be set if shouldAutoCreate is enabled.");

      local autoCreatedClickDetector = Instance.new("ClickDetector");
      autoCreatedClickDetector.Parent = dialogueServer.settings.clickDetector.adornee;
      clickDetector = autoCreatedClickDetector;

    end;

    if clickDetector then

      local originalParent = clickDetector.Parent;
      dialogueClient.DialogueServerChanged:Connect(function()

        clickDetector.Parent = if dialogueClient.dialogueServer == nil then originalParent else nil;

      end);

      clickDetector.MouseClick:Connect(function()

        if dialogueClient.dialogueServer == nil then

          dialogueClient:interact(dialogueServer);

        end;

      end);

    end;

  end);

  if not didInitialize then

    local fullName = dialogueServerModuleScript:GetFullName();
    warn(`[Dialogue Maker] Failed to initialize proximity prompt for {fullName}: {errorMessage}`);

  end;

end;