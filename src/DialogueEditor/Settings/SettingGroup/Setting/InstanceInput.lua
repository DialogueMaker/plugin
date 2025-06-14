--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type InstanceInputProperties = {
  value: Instance?;
  defaultValue: Instance?;
  className: string?;
  onChanged: (value: Instance?) -> ();
}

local function InstanceInput(properties: InstanceInputProperties)

  local onChanged = properties.onChanged;

  local colors = useStudioColors();

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

  return React.createElement("TextButton", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundColor3 = colors.primaryButton;
    Text = "";
    LayoutOrder = 2;
    [React.Event.Activated] = function()
    
      setIsSelecting(not isSelecting);

    end;
  }, {
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 5);
      PaddingBottom = UDim.new(0, 5);
      PaddingLeft = UDim.new(0, 5);
      PaddingRight = UDim.new(0, 5);
    });
    ObjectName = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = properties.value and properties.value.Name or properties.defaultValue and properties.defaultValue.Name or `Select{if isSelecting then "ing" else ""} {className}`;
      TextSize = 12;
      FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
      TextColor3 = colors.text;
      BackgroundTransparency = 1;
    });
  });

end;

return React.memo(InstanceInput);