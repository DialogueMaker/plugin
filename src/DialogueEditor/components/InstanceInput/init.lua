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

local function InstanceInput(properties: InstanceInputProperties)

  local onChanged = properties.onChanged;

  local className = properties.className or "Instance";
  local isSelecting, setIsSelecting = React.useState(false);
  local previousSelection, setPreviousSelection = React.useState(nil :: Instance?);
  
  React.useEffect(function(): ()
  
    if isSelecting then

      setPreviousSelection(Selection:Get()[1]);

      local selectionChangedConnection = Selection.SelectionChanged:Connect(function()
        
        local selectedInstance = Selection:Get()[1];

        if previousSelection then

          Selection:Set({previousSelection});
          setPreviousSelection(nil);

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
    text = properties.value and properties.value.Name or properties.defaultValue and properties.defaultValue.Name or `Select{if isSelecting then "ing" else ""} {className}`;
    onClick = function()
    
      setIsSelecting(not isSelecting);

    end;
  });

end;

return React.memo(InstanceInput);