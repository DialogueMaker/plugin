--!strict

local TweenService = game:GetService("TweenService");

local root = script.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type ToolbarButtonProps = {
  iconImage: string;
  text: string;
  layoutOrder: number;
  isDisabled: boolean?;
  isHighlighted: boolean?;
  onClick: () -> ();
};

local function ToolbarButton(props: ToolbarButtonProps)

  local colors = useStudioColors();
  local buttonRef = React.useRef(nil);
  local isUserHovering, setIsUserHovering = React.useState(false);

  React.useEffect(function()
  
    if buttonRef.current then
      local tween = TweenService:Create(buttonRef.current, TweenInfo.new(0.2), {
        BackgroundTransparency = if isUserHovering and not props.isDisabled then 0 elseif props.isHighlighted then 0.5 else 1;
      });
      tween:Play();
    end

  end, {isUserHovering :: unknown, props.isHighlighted, props.isDisabled});

  return React.createElement("TextButton", {
    LayoutOrder = props.layoutOrder;
    BackgroundColor3 = if props.isHighlighted then colors.backgroundWarning else colors.toolbarButton;
    AutoButtonColor = false;
    ref = buttonRef;
    Text = "";
    Size = UDim2.new(0, 0, 0, 0);
    AutomaticSize = Enum.AutomaticSize.XY;
    BorderSizePixel = 0;
    [React.Event.Activated] = function()
      
      if (not props.isDisabled) then

        props.onClick();

      end;

    end;
    [React.Event.MouseEnter] = function()

      setIsUserHovering(true);

    end;
    [React.Event.MouseLeave] = function()

      setIsUserHovering(false);

    end;
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 10);
      PaddingRight = UDim.new(0, 10);
    });
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
      VerticalAlignment = Enum.VerticalAlignment.Center;
      Padding = UDim.new(0, 5);
    });
    IconImageLabel = React.createElement("ImageLabel", {
      LayoutOrder = 1;
      BackgroundTransparency = 1;
      Image = props.iconImage;
      Size = UDim2.new(0, 24, 0, 24);
      ImageColor3 = if props.isDisabled then colors.textDisabled else colors.text;
    });
    TextLabel = React.createElement("TextLabel", {
      LayoutOrder = 2;
      BackgroundTransparency = 1;
      Text = props.text;
      TextSize = 12;
      Size = UDim2.new(0, 0, 1, 0);
      AutomaticSize = Enum.AutomaticSize.X;
      TextColor3 = if props.isDisabled then colors.textDisabled else colors.text;
      FontFace = Font.fromId(11702779517);
    });
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
  });

end;

return React.memo(ToolbarButton);