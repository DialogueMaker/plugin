--!strict
local React = require(script.Parent.Parent.Packages.react);
local Types = require(script.Parent.Parent.types);
local Player = game:GetService("Players").LocalPlayer;
local TweenService = game:GetService("TweenService");
type ClientSettings = Types.ClientSettings;
type NPCSettings = Types.NPCSettings;

local function useLookAtPlayer(npc: Model, npcSettings: NPCSettings)

  React.useEffect(function(): ()
  
    -- Check if the NPC needs to look at the player.
    if npcSettings.general.npcLooksAtPlayerDuringDialogue and npcSettings.general.npcNeckRotationMaxY then

      -- Handle this in a coroutine because the look shouldn't stop the dialogue.
      local lookTask = task.spawn(function()

        local NPCHead: BasePart? = npc:FindFirstChild("Head") :: BasePart;
        local NPCPrimaryPart: BasePart? = npc.PrimaryPart :: BasePart;
        local NPCHumanoid: Humanoid? = npc:FindFirstChild("Humanoid") :: Humanoid;
        local NPCTorso: BasePart? = NPCHumanoid and NPCHumanoid.RigType == Enum.HumanoidRigType.R6 and (npc:FindFirstChild("Torso") :: BasePart) or nil;
        local NPCNeckParent = NPCTorso or NPCHead;
        local NPCNeck: Motor6D? = NPCNeckParent and NPCNeckParent:FindFirstChild("Neck") :: Motor6D;
        local PlayerCharacter: Model? = Player.Character;
        local PlayerHead: BasePart? = (PlayerCharacter and PlayerCharacter:FindFirstChild("Head") :: BasePart);
        if NPCNeck then
    
          -- Set the base position.
          NPCNeck.C0 = CFrame.new(NPCNeck.C0.Position) * CFrame.fromOrientation(0, 0, 0);
          NPCNeck.C1 = CFrame.new(NPCNeck.C1.Position) * CFrame.fromOrientation(0, 0, 0);
          local OriginalC0 = NPCNeck.C0;
          local OriginalC1 = NPCNeck.C1;
    
          while NPCPrimaryPart and NPCHead and NPCNeck and PlayerHead and task.wait() do
    
            local maxRotationX = npcSettings.general.npcNeckRotationMaxX;
            local maxRotationY = npcSettings.general.npcNeckRotationMaxY;
            local maxRotationZ = npcSettings.general.npcNeckRotationMaxZ;
            local goalRotationX, goalRotationY, goalRotationZ = CFrame.new(NPCHead.Position, PlayerHead.Position):ToOrientation();
            local rotationOffsetX = goalRotationX - math.rad(NPCPrimaryPart.Orientation.X);
            local rotationOffsetY = goalRotationY - math.rad(NPCPrimaryPart.Orientation.Y);
            local rotationOffsetZ = goalRotationZ - math.rad(NPCPrimaryPart.Orientation.Z);
            local rotationXAbs = math.abs(rotationOffsetX);
            local rotationYAbs = math.abs(rotationOffsetY);
            local rotationZAbs = math.abs(rotationOffsetZ);
            TweenService:Create(NPCNeck, TweenInfo.new(0.3), {
              C0 = CFrame.new(NPCNeck.C0.Position) * CFrame.fromOrientation(
              ((rotationXAbs > maxRotationX and maxRotationX * (rotationOffsetX / rotationXAbs) * ((rotationXAbs > math.pi and -1) or 1)) or rotationOffsetX), 
              ((rotationYAbs > maxRotationY and maxRotationY * (rotationOffsetY / rotationYAbs) * ((rotationYAbs > math.pi and -1) or 1)) or rotationOffsetY), 
              ((rotationZAbs > maxRotationZ and maxRotationZ * (rotationOffsetZ / rotationZAbs) * ((rotationZAbs > math.pi and -1) or 1)) or rotationOffsetZ)
              )
            }):Play();
    
          end
    
          TweenService:Create(NPCNeck, TweenInfo.new(0.3), {C0 = OriginalC0, C1 = OriginalC1}):Play();
    
        end
    
      end);

      return function()

        task.cancel(lookTask);

      end;

    end

  end, {});

end;

return useLookAtPlayer;