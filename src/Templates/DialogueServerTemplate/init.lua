--!strict

local Players = game:GetService("Players");

local loaderScript;
for _, possibleScript in Players.LocalPlayer.PlayerScripts:GetDescendants() do

  if possibleScript:HasTag("DialogueMaker_Loader") then
    
    loaderScript = possibleScript;
    break;

  end;

end;

local packages = loaderScript.roblox_packages;
local Conversation = require(packages.conversation) :: any;

-- See documentation: https://github.com/DialogueMaker/conversation
local conversation = Conversation.new({}, script);

return conversation; 
