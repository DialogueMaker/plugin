--!strict

local DialogueClientScript = script.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local Types = require(DialogueClientScript.Types);
type NPCSettings = Types.NPCSettings;
local Players = game:GetService("Players");

local function useOutOfDistanceDetection(npc: Model, npcSettings: NPCSettings, endConversationFunction: () -> ())

  React.useEffect(function(): ()
  
    local NPCPrimaryPart = npc.PrimaryPart;
    local MaxConversationDistance = npcSettings.general.maxConversationDistance;
    local EndConversationIfOutOfDistance = npcSettings.general.endConversationIfOutOfDistance;
    if EndConversationIfOutOfDistance and MaxConversationDistance and NPCPrimaryPart then

      local detectionTask = task.spawn(function() 

        while task.wait() do

          if math.abs(NPCPrimaryPart.Position.Magnitude - Players.LocalPlayer.Character.PrimaryPart.Position.Magnitude) > MaxConversationDistance then

            endConversationFunction();
            break;

          end;

        end;

      end);

      return function()

        task.cancel(detectionTask);

      end;

    end;

  end, {npc :: any, npcSettings, endConversationFunction});

end;

return useOutOfDistanceDetection;