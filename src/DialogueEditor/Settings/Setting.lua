--!strict

local Selection = game:GetService("Selection");

local packages = script.Parent.Parent.Parent.roblox_packages;
local React = require(packages.react);

export type SettingProperties = {
  name: string;
  description: string;
  defaultValue: any;
  type: "boolean" | "string" | "number" | nil;
  value: any?;
  className: string?;
  onChanged: (value: any) -> ();
  layoutOrder: number;
}

local function Setting(properties: SettingProperties)

  local previousSelection, setPreviousSelection = React.useState(nil :: Instance?);
  
  React.useEffect(function(): ()
  
    if previousSelection then

      local selectionChangedConnection = Selection.SelectionChanged:Once(function()
      
        properties.onChanged(previousSelection);
        Selection:Set({previousSelection});
        setPreviousSelection(nil);

      end);

      return function()

        selectionChangedConnection:Disconnect();
      
      end;

    end;

  end, {previousSelection, properties.onChanged});

  local inputValue = React.useMemo(function(): React.ReactElement
    
    if properties.type == "boolean" then

      local isEnabled = if properties.value ~= nil then properties.value else properties.defaultValue;

      return React.createElement("TextButton", {
        AnchorPoint = Vector2.new(if isEnabled then 1 else 0, 0);
        Position = UDim2.fromScale(if isEnabled then 1 else 0, 0);
        AutomaticSize = Enum.AutomaticSize.XY;
        BackgroundColor3 = Color3.new(1, 1, 1);
        LayoutOrder = 2;
        Text = "";
        TextSize = 14;
        Size = UDim2.fromOffset(50, 30);
        BackgroundTransparency = 0.2;
        [React.Event.Activated] = function()

          properties.onChanged(not properties.value);

        end;
      }, {
        UIPadding = React.createElement("UIPadding", {
          PaddingLeft = UDim.new(0, 5);
          PaddingRight = UDim.new(0, 5);
        });
        UICorner = React.createElement("UICorner", {
          CornerRadius = UDim.new(0, 20);
        });
        Frame = React.createElement("Frame", {
          Size = UDim2.fromOffset(20, 20);
          BackgroundColor3 = if isEnabled then Color3.fromRGB(44, 121, 79) else Color3.fromRGB(121, 121, 121);
        }, {
          UICorner = React.createElement("UICorner", {
            CornerRadius = UDim.new(1, 0);
          });
        });
      });

    elseif properties.className then

      return React.createElement("TextButton", {
        AutomaticSize = Enum.AutomaticSize.XY;
        Text = "";
      }, {
        UICorner = React.createElement("UICorner", {
          CornerRadius = UDim.new(0, 5);
        });
        ObjectName = React.createElement("TextLabel", {
          AutomaticSize = Enum.AutomaticSize.XY;
          Text = properties.value and properties.value.Name or properties.defaultValue and properties.defaultValue.Name or "Select " .. properties.className;
          TextSize = 14;
          TextColor3 = Color3.fromRGB(255, 255, 255);
          BackgroundTransparency = 1;
          LayoutOrder = 2;
        });
      });

    else

      error(`Unsupported setting type: {properties.type}`);

    end;

  end, {properties.type :: unknown, properties.value, properties.defaultValue, properties.onChanged, previousSelection});

  return React.createElement("Frame", {
    BackgroundTransparency = 1;
    AutomaticSize = Enum.AutomaticSize.Y;
    Size = UDim2.fromScale(1, 0);
    LayoutOrder = properties.layoutOrder;
  }, {
    FirstRow = React.createElement("Frame", {}, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
      });
      NameLabel = React.createElement("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY;
        LayoutOrder = 1;
        Text = properties.name;
        TextSize = 14;
        TextColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1;
      });
      InputValue = inputValue;
    });
    DescriptionLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = properties.description;
      TextSize = 12;
      TextColor3 = Color3.fromRGB(200, 200, 200);
      BackgroundTransparency = 1;
    }),
  });

end;

return React.memo(Setting);