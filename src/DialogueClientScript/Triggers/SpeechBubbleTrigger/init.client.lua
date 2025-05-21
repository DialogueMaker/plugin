--!strict
-- Automatically triggers the dialogue server when the player clicks on a floating speech bubble.
--
-- Programmers: Christian Toney (Christian_Toney)
-- © 2023 – 2025 Dialogue Maker Group

local CollectionService = game:GetService("CollectionService");
local StarterPlayer = game:GetService("StarterPlayer");

local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts");
local DialogueClient = require(StarterPlayerScripts.DialogueClientScript.Classes.DialogueClient);
local IDialogueServer = require(StarterPlayerScripts.DialogueClientScript.Interfaces.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;

local dialogueClient = DialogueClient:waitForSharedDialogueClient();

for _, dialogueServerModuleScript in CollectionService:GetTagged("DialogueMaker_DialogueServer") do

  local didInitialize, errorMessage = pcall(function()

    -- We're using pcall because require can throw an error if the module is invalid.
    local dialogueServer = require(dialogueServerModuleScript) :: DialogueServer;
    local dialogueServerSettings = dialogueServer:getSettings();
    local speechBubbleGUI: BillboardGui? = dialogueServerSettings.speechBubble.billboardGUI;
    local autoCreatedButton: GuiButton? = nil;
    
    if not speechBubbleGUI and dialogueServerSettings.speechBubble.shouldAutoCreate then
      
      assert(dialogueServerSettings.speechBubble.adornee, "SpeechBubble adornee must be set if shouldAutoCreate is enabled.");

      local autoCreatedSpeechBubbleGUI = script.SpeechBubbleGUI:Clone();
      autoCreatedSpeechBubbleGUI.Adornee = dialogueServerSettings.speechBubble.adornee;
      autoCreatedSpeechBubbleGUI.Parent = dialogueServerSettings.speechBubble.adornee;
      autoCreatedButton = autoCreatedSpeechBubbleGUI.Button;

    end;

    if speechBubbleGUI then

      assert(speechBubbleGUI:IsA("BillboardGui"), "SpeechBubble instance must be a BillboardGui.");

      local button = dialogueServerSettings.speechBubble.button or autoCreatedButton;
      assert(button and button:IsA("GuiButton"), "SpeechBubble button must be a GuiButton.");

      dialogueClient.DialogueServerChanged:Connect(function()
      
        speechBubbleGUI.Enabled = dialogueClient.dialogueServer == nil;

      end);

      button.MouseButton1Click:Connect(function()

        if not dialogueClient.dialogueServer then

          dialogueClient:interact(dialogueServer);

        end;
        
      end);

    end;

  end);

  if not didInitialize then

    local fullName = dialogueServerModuleScript:GetFullName();
    warn(`[Dialogue Maker] Failed to initialize speech bubble for {fullName}: {errorMessage}`);

  end;

end;