--!strict

local CollectionService = game:GetService("CollectionService");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);

local function useDialogueMakerPackages()

  local getDialogueMakerPackages = React.useCallback(function()
  
    local dialogueMakerKits = CollectionService:GetTagged("DialogueMakerKit");
    local dialogueMakerKit;
    for _, kit in dialogueMakerKits do
      
      if not kit:IsDescendantOf(root) then
        
        dialogueMakerKit = kit;
        break;
        
      end;
      
    end;

    local dialogueMakerPackageContainers = CollectionService:GetTagged("DialogueMakerPackages");
    local dialogueMakerPackages = if dialogueMakerKit then dialogueMakerKit:FindFirstChild("Packages") else nil;

    if not dialogueMakerPackages then

      for _, packageContainer in dialogueMakerPackageContainers do
        
        if not packageContainer:IsDescendantOf(root) then
          
          dialogueMakerPackages = packageContainer;
          break;
          
        end;
        
      end;

    end;

    return dialogueMakerPackages;

  end, {});

  local dialogueMakerPackages: Instance?, setDialogueMakerPackages = React.useState(getDialogueMakerPackages());

  React.useEffect(function()

    local function updateDialogueMakerPackages()
      
      setDialogueMakerPackages(getDialogueMakerPackages());
      
    end;
  
    local dialogueMakerPackagesAddedConnection = CollectionService:GetInstanceAddedSignal("DialogueMakerPackages"):Connect(updateDialogueMakerPackages);
    local dialogueMakerPackagesRemovedConnection = CollectionService:GetInstanceAddedSignal("DialogueMakerKit"):Connect(updateDialogueMakerPackages);
    local dialogueMakerKitAddedConnection = CollectionService:GetInstanceRemovedSignal("DialogueMakerPackages"):Connect(updateDialogueMakerPackages);
    local dialogueMakerKitRemovedConnection = CollectionService:GetInstanceRemovedSignal("DialogueMakerKit"):Connect(updateDialogueMakerPackages);

    return function()
      
      dialogueMakerPackagesAddedConnection:Disconnect();
      dialogueMakerPackagesRemovedConnection:Disconnect();
      dialogueMakerKitAddedConnection:Disconnect();
      dialogueMakerKitRemovedConnection:Disconnect();
      
    end;

  end, {getDialogueMakerPackages});

  return dialogueMakerPackages;

end;

return useDialogueMakerPackages;