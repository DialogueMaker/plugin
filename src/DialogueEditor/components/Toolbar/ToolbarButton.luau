--!strict

local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");

local root = script.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type ToolbarButtonProps = {
  iconImage: string;
  text: string?;
  layoutOrder: number;
  isDisabled: boolean?;
  onClick: () -> ();
  plugin: Plugin;
};

local function ToolbarButton(props: ToolbarButtonProps)

  local colors = useStudioColors();
  local buttonRef = React.useRef(nil :: TextButton?);
  local plugin = props.plugin;

  React.useEffect(function()
  
    local button = buttonRef.current;
    if not button then

      return;

    end;

    local isUserHovering = false;
    local isMouseDown = false;
    local function playTween()

      local tween = TweenService:Create(button, TweenInfo.new(0.1), {
        BackgroundTransparency = if isMouseDown then 0.75 elseif isUserHovering then 0.25 else 1;
      });

      tween:Play();

    end;

    local mouseEnterConnection = button.MouseEnter:Connect(function()

      isUserHovering = true;
      playTween();

    end);

    local mouseLeaveConnection = button.MouseLeave:Connect(function()

      isUserHovering = false;
      playTween();

    end);

    local mouseButton1DownConnection = button.InputBegan:Connect(function(input)

      if input.UserInputType == Enum.UserInputType.MouseButton1 and isUserHovering and not isMouseDown then

        isMouseDown = true;
        playTween();

      end;

    end);

    local mouseButton1UpConnection = button.InputEnded:Connect(function(input)

      if input.UserInputType == Enum.UserInputType.MouseButton1 then

        isMouseDown = false;
        playTween();

      end;

    end);

    return function()

      mouseEnterConnection:Disconnect();
      mouseLeaveConnection:Disconnect();
      mouseButton1DownConnection:Disconnect();
      mouseButton1UpConnection:Disconnect();

    end;

  end, {props.isDisabled});

  return React.createElement("TextButton", {
    LayoutOrder = props.layoutOrder;
    BackgroundColor3 = colors.toolbarButton;
    BackgroundTransparency = 1;
    AutoButtonColor = false;
    ref = buttonRef;
    Text = "";
    Size = UDim2.new();
    AutomaticSize = Enum.AutomaticSize.XY;
    BorderSizePixel = 0;
    [React.Event.Activated] = function()
      
      if (not props.isDisabled) then

        props.onClick();

      end;

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
    UISizeConstraint = React.createElement("UISizeConstraint", {
      MinSize = Vector2.new(0, 35);
    });
    IconImageLabel = React.createElement("ImageLabel", {
      LayoutOrder = 1;
      BackgroundTransparency = 1;
      Image = props.iconImage;
      Size = UDim2.new(0, 24, 0, 24);
      ImageColor3 = if props.isDisabled then colors.textDisabled else colors.text;
    });
    TextLabel = if props.text then
      React.createElement("TextLabel", {
        LayoutOrder = 2;
        BackgroundTransparency = 1;
        Text = props.text;
        TextSize = 12;
        Size = UDim2.new(0, 0, 1, 0);
        AutomaticSize = Enum.AutomaticSize.X;
        TextColor3 = if props.isDisabled then colors.textDisabled else colors.text;
        FontFace = Font.fromId(11702779517);
      })
    else nil;
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
  });

end;

return React.memo(ToolbarButton);