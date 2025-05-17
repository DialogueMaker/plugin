--!strict

local Players = game:GetService("Players");

local DialogueClientScript = script.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local IDialogueServer = require(DialogueClientScript.Interfaces.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;

local function useOutOfDistanceDetection(npc: Model, dialogueServer: DialogueServer, endConversation: () -> ())

  React.useEffect(function(): ()
  
    local NPCPrimaryPart = npc.PrimaryPart;
    local MaxConversationDistance = dialogueServer.settings.general.maxConversationDistance;
    local EndConversationIfOutOfDistance = dialogueServer.settings.general.endConversationIfOutOfDistance;
    if EndConversationIfOutOfDistance and MaxConversationDistance and NPCPrimaryPart then

      local detectionTask = task.spawn(function() 

        while task.wait() do

          if math.abs(NPCPrimaryPart.Position.Magnitude - Players.LocalPlayer.Character.PrimaryPart.Position.Magnitude) > MaxConversationDistance then

            endConversation();
            break;

          end;

        end;

      end);

      return function()

        task.cancel(detectionTask);

      end;

    end;

  end, {npc :: unknown, dialogueServer, endConversation});

end;

return useOutOfDistanceDetection;