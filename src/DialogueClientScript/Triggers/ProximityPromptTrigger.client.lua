--!strict

local CollectionService = game:GetService("CollectionService");
local StarterPlayer = game:GetService("StarterPlayer");

local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts");
local DialogueClient = require(StarterPlayerScripts.DialogueClientScript.Classes.DialogueClient);
local IDialogueServer = require(StarterPlayerScripts.DialogueClientScript.Interfaces.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;

local dialogueClient = DialogueClient.getFromSharedObject(true);

for _, dialogueServerModuleScript in CollectionService:GetTagged("DialogueMaker_DialogueServer") do

  local dialogueServer = require(dialogueServerModuleScript) :: DialogueServer;

  if dialogueServer.settings.proximityPrompt.enabled then

    local proximityPrompt = dialogueServer.settings.proximityPrompt.location;
    if dialogueServer.settings.proximityPrompt.autoCreate then

      local proximityPromptTemp = Instance.new("ProximityPrompt");
      proximityPromptTemp.Parent = dialogueServer.instance.Parent;
      proximityPrompt = proximityPromptTemp;

    end;

    assert(proximityPrompt and proximityPrompt:IsA("ProximityPrompt"), "[Dialogue Maker] ProximityPrompt location must be a ProximityPrompt.");

    proximityPrompt.Triggered:Connect(function()

      dialogueClient:interact(dialogueServer);

    end);

  end;

end;