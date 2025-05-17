--!strict
local DialogueClientScript = script.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");
local Types = require(DialogueClientScript.Types);
type ClientSettings = Types.ClientSettings;

function useKeybindContinue(clientSettings: ClientSettings, continueDialogueFunction: () -> ())

  React.useEffect(function(): ()
  
    local defaultChatContinueKey = clientSettings.defaultChatContinueKey;
    local defaultChatContinueKeyGamepad = clientSettings.defaultChatContinueKeyGamepad;

    if clientSettings.keybindsEnabled then

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

  end, {clientSettings});

end;

return useKeybindContinue;