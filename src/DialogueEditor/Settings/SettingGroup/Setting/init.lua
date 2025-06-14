--!strict

local root = script.Parent.Parent.Parent.Parent;
local packages = root.roblox_packages;
local React = require(packages.react);
local InstanceInput = require(script.InstanceInput);
local ToggleInput = require(script.ToggleInput);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type SettingProperties = {
  name: string;
  description: string;
  defaultValue: any;
  type: "boolean" | "string" | "number" | "Instance";
  value: any?;
  className: string?;
  onChanged: (value: any) -> ();
  layoutOrder: number;
}

local function Setting(properties: SettingProperties)

  local colors = useStudioColors();

  local inputValue = React.useMemo(function(): React.ReactElement
    
    if properties.type == "boolean" then

      local isEnabled = if properties.value ~= nil then properties.value else properties.defaultValue;

      return React.createElement(ToggleInput, {
        isEnabled = isEnabled;
        onChanged = function(value: boolean): ()
        
          properties.onChanged(value);

        end;
      });

    elseif properties.type == "string" or properties.type == "number" then

      return React.createElement("TextBox", {
        Text = properties.value or "";
        PlaceholderText = properties.defaultValue;
        TextSize = 12;
        BackgroundTransparency = 0.5;
        LayoutOrder = 2;
        FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
        Size = UDim2.new(1, 0, 0, 30);
        [React.Event.FocusLost] = function(self: TextBox): ()
        
          properties.onChanged(self.Text);

        end;
      }, {
        UIPadding = React.createElement("UIPadding", {
          PaddingLeft = UDim.new(0, 10);
          PaddingRight = UDim.new(0, 10);
        });
        UICorner = React.createElement("UICorner", {
          CornerRadius = UDim.new(0, 5);
        });
        UISizeConstraint = React.createElement("UISizeConstraint", {
          MaxSize = Vector2.new(100, math.huge);
        });
      });

    elseif properties.type == "Instance" then

      return React.createElement(InstanceInput, {
        value = properties.value;
        defaultValue = properties.defaultValue;
        className = properties.className;
        onChanged = function(value: Instance?): ()
        
          properties.onChanged(value);

        end;
      });

    else

      error(`Unsupported setting type: {properties.type}`);

    end;

  end, {properties.type :: unknown, properties.value, properties.defaultValue, properties.onChanged});

  return React.createElement("Frame", {
    BackgroundTransparency = 0;
    BackgroundColor3 = colors.toolbar;
    AutomaticSize = Enum.AutomaticSize.Y;
    Size = UDim2.fromScale(1, 0);
    LayoutOrder = properties.layoutOrder;
    BorderSizePixel = 0;
  }, {
    UIStroke = React.createElement("UIStroke", {
      Color = colors.border;
      Thickness = 1;
      ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 10);
      PaddingBottom = UDim.new(0, 10);
      PaddingLeft = UDim.new(0, 10);
      PaddingRight = UDim.new(0, 10);
    });
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
      HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween;
      VerticalAlignment = Enum.VerticalAlignment.Center;
      Padding = UDim.new(0, 15);
    });
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
    Information = React.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.Y;
      LayoutOrder = 1;
      BackgroundTransparency = 1;
    }, {
      UIFlexItem = React.createElement("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Fill;
      }),
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      NameLabel = React.createElement("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY;
        LayoutOrder = 1;
        Text = properties.name;
        TextSize = 14;
        FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Bold);
        TextColor3 = colors.text;
        BackgroundTransparency = 1;
        TextWrapped = true;
        TextXAlignment = Enum.TextXAlignment.Left;
      });
      DescriptionLabel = React.createElement("TextLabel", {
        LayoutOrder = 2;
        AutomaticSize = Enum.AutomaticSize.XY;
        Text = properties.description;
        TextSize = 12;
        FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
        TextColor3 = colors.text;
        TextTransparency = 0.1;
        BackgroundTransparency = 1;
        TextWrapped = true;
        TextXAlignment = Enum.TextXAlignment.Left;
      }),
    });
    InputValue = inputValue;
  });

end;

return React.memo(Setting);