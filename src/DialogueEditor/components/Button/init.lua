--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type ButtonProperties = {
  text: string;
  isDisabled: boolean?;
  backgroundColor: Color3?;
  layoutOrder: number?;
  onClick: () -> ();
}

local function Button(properties: ButtonProperties)

  local colors = useStudioColors();
  local backgroundColor = properties.backgroundColor or colors.primaryButton;
  local layoutOrder = properties.layoutOrder or 0;
  local text = properties.text;
  local isDisabled = properties.isDisabled;
  local onClick = properties.onClick;

  return React.createElement("TextButton", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundColor3 = backgroundColor;
    Text = "";
    LayoutOrder = layoutOrder;
    [React.Event.Activated] = function()
    
      if not isDisabled then

        onClick();
        
      end;

    end;
  }, {
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 10);
      PaddingBottom = UDim.new(0, 10);
      PaddingLeft = UDim.new(0, 10);
      PaddingRight = UDim.new(0, 10);
    });
    TextLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = text;
      TextSize = 12;
      FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
      TextColor3 = colors.text;
      BackgroundTransparency = 1;
    });
  })

end;

return React.memo(Button);