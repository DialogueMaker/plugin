--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);

local function useAutomaticClose(closeDialogueEditor: () -> ())

  React.useEffect(function(): ()
    
    local selectionChangedConnection = Selection.SelectionChanged:Connect(function()
      
      local selection = Selection:Get();
      if #selection == 0 then

        closeDialogueEditor();

      end;

    end);

    return function()

      selectionChangedConnection:Disconnect();
    
    end;

  end, { closeDialogueEditor });

end;

return useAutomaticClose;