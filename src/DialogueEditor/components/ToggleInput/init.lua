--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type ToggleInputProperties = {
  isEnabled: boolean;
  onChanged: (value: boolean) -> ();
}

local function ToggleInput(properties: ToggleInputProperties)

  local isEnabled = properties.isEnabled;
  local colors = useStudioColors();

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    LayoutOrder = 2;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
      HorizontalAlignment = Enum.HorizontalAlignment.Left;
      VerticalAlignment = Enum.VerticalAlignment.Center;
      Padding = UDim.new(0, 15);
    });
    TextLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      Text = if isEnabled then "On" else "Off";
      TextColor3 = colors.text;
      TextSize = 14;
      LayoutOrder = 1;
      FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
    });
    ToggleButton = React.createElement("TextButton", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundColor3 = colors.primaryButton;
      LayoutOrder = 2;
      Text = "";
      Size = UDim2.fromOffset(50, 30);
      BackgroundTransparency = if isEnabled then 0.2 else 1;
      [React.Event.Activated] = function()

        properties.onChanged(not isEnabled);

      end;
    }, {
      UIStroke = if not isEnabled then
        React.createElement("UIStroke", {
          Color = colors.text;
          Thickness = 1;
          ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        })
      else nil;
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 5);
        PaddingRight = UDim.new(0, 5);
      });
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 20);
      });
      Dot = React.createElement("Frame", {
        AnchorPoint = Vector2.new(if isEnabled then 1 else 0, 0.5);
        Position = UDim2.fromScale(if isEnabled then 1 else 0, 0.5);
        Size = UDim2.fromOffset(20, 20);
        BackgroundColor3 = colors.text;
      }, {
        UICorner = React.createElement("UICorner", {
          CornerRadius = UDim.new(1, 0);
        });
      });
    });
  });

end;

return React.memo(ToggleInput);