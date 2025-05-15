--!strict

local Players = game:GetService("Players");

local types = require(script.types);
type Dialogue = types.Dialogue;

local dialogue: Dialogue = {} :: Dialogue;

function dialogue:verifyCondition(): boolean

  return true;

end;

-- This doesn't run if the dialogue is a redirect.
function dialogue:getContent(): {string}

  local player = Players.LocalPlayer;
  return {`Hi {player.Name}!`};

end;

-- This doesn't run if the dialogue is a redirect.
function dialogue:runAction(): ()

end;

return dialogue;