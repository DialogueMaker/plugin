--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local VirtualService = require(root.VirtualService);

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
  local buttonRef = React.useRef(nil);

  React.useEffect(function()

    local button = buttonRef.current;
    assert(button, "Button reference is nil.");

    local activatedConnection = VirtualService.events.GuiButton.Activated:getSignal(button):Connect(function(self)

      if not isDisabled then

        onClick();
        
      end;

    end);

    return function()

      activatedConnection:Disconnect();

    end;
  
  end, {onClick});

  return React.createElement("TextButton", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundColor3 = backgroundColor;
    Text = "";
    LayoutOrder = layoutOrder;
    Size = UDim2.fromOffset(0, 30);
    ref = buttonRef;
  }, {
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 8);
      PaddingBottom = UDim.new(0, 8);
      PaddingLeft = UDim.new(0, 10);
      PaddingRight = UDim.new(0, 10);
    });
    TextLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = text;
      TextSize = 14;
      FontFace = Font.fromName("BuilderSans");
      TextColor3 = colors.buttonText;
      BackgroundTransparency = 1;
    });
  })

end;

return React.memo(Button);