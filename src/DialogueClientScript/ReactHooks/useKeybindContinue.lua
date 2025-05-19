--!strict

local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");

local DialogueClientScript = script.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);

local IDialogueClient = require(DialogueClientScript.Interfaces.DialogueClient);

type DialogueClient = IDialogueClient.DialogueClient;

function useKeybindContinue(dialogueClient: DialogueClient, continueDialogueFunction: () -> ())

  React.useEffect(function(): ()
  
    local continueKey = dialogueClient.settings.keybinds.interactKey;
    local continueKeyGamepad = dialogueClient.settings.keybinds.interactKeyGamepad;

    if continueKey or continueKeyGamepad then

      local function checkKeybinds(keybind: Enum.KeyCode)

        if keybind and not UserInputService:IsKeyDown(continueKey) and not UserInputService:IsKeyDown(continueKeyGamepad) then

          continueDialogueFunction();

        end;

      end;

      ContextActionService:BindAction("ContinueDialogue", checkKeybinds, false, continueKey, continueKeyGamepad);

      return function()

        ContextActionService:UnbindAction("ContinueDialogue");

      end;

    end;

  end, {dialogueClient});

end;

return useKeybindContinue;