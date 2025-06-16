--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent;
local Button = require(root.DialogueEditor.components.Button);
local React = require(root.roblox_packages.react);

export type InstanceInputProperties = {
  value: Instance?;
  defaultValue: Instance?;
  className: string?;
  onChanged: (value: Instance?) -> ();
}

local function InstanceInput<InstanceType>(properties: InstanceInputProperties)

  local onChanged = properties.onChanged;

  local className = properties.className or "Instance";
  local isSelecting, setIsSelecting = React.useState(false);
  
  React.useEffect(function(): ()
  
    if isSelecting then

      local previousSelection = Selection:Get()[1];

      local selectionChangedConnection = Selection.SelectionChanged:Once(function()
        
        local selectedInstance = Selection:Get()[1];

        if previousSelection then

          Selection:Set({previousSelection});

        end;

        setIsSelecting(false);

        if selectedInstance and (not properties.className or selectedInstance:IsA(properties.className)) then

          onChanged(selectedInstance);
          
        else
          
          onChanged(nil);
          
        end;

      end);

      return function()

        selectionChangedConnection:Disconnect();
      
      end;

    end;

  end, {isSelecting});

  return React.createElement(Button, {
    layoutOrder = 2;
    text = if isSelecting then `Selecting {className}...` else (if properties.value then properties.value.Name elseif properties.defaultValue then properties.defaultValue.Name else nil) or `Select {className}`;
    onClick = function()
    
      setIsSelecting(not isSelecting);

    end;
  });

end;

return React.memo(InstanceInput);