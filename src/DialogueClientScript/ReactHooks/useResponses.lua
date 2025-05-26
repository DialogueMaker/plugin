--!strict

local StarterPlayer = game:GetService("StarterPlayer");
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts;

local DialogueClientScript = StarterPlayerScripts.DialogueClientScript;
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);

type Dialogue = IDialogue.Dialogue;

local function useResponses(dialogue: Dialogue): {Dialogue}

  local responses = {};
  for _, possibleResponse in dialogue:getChildren() do

    if possibleResponse.type == "Response" and possibleResponse:verifyCondition() then

      table.insert(responses, possibleResponse);

    end

  end

  return responses;

end;

return useResponses;