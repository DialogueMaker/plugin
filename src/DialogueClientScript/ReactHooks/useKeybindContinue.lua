--!strict

local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");

local DialogueClientScript = script.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);

local IDialogueClient = require(DialogueClientScript.Interfaces.DialogueClient);

type DialogueClient = IDialogueClient.DialogueClient;

function useKeybindContinue(dialogueClient: DialogueClient, continueDialogueFunction: () -> ())

  React.useEffect(function(): ()
  
    local defaultChatContinueKey = dialogueClient.settings.triggers.defaultChatContinueKey;
    local defaultChatContinueKeyGamepad = dialogueClient.settings.triggers.defaultChatContinueKeyGamepad;

    if dialogueClient.settings.triggers.keybindsEnabled then

      local function checkKeybinds(keybind: Enum.KeyCode)

        if keybind and not UserInputService:IsKeyDown(defaultChatContinueKey) and not UserInputService:IsKeyDown(defaultChatContinueKeyGamepad) then

          continueDialogueFunction();

        end;

      end;

      ContextActionService:BindAction("ContinueDialogue", checkKeybinds, false, defaultChatContinueKey, defaultChatContinueKeyGamepad);

      return function()

        ContextActionService:UnbindAction("ContinueDialogue");

      end;

    end;

  end, {dialogueClient});

end;

return useKeybindContinue;