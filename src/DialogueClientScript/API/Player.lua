--!strict
local PlayerModule = {};
local Player = game:GetService("Players").LocalPlayer;

function PlayerModule:freezePlayer(): ()
  
  (require(Player.PlayerScripts:WaitForChild("PlayerModule")) :: any):GetControls():Disable();
  
end;

function PlayerModule:unfreezePlayer(): ()

  (require(Player.PlayerScripts:WaitForChild("PlayerModule")) :: any):GetControls():Enable();
  
end;

return PlayerModule;
