--!strict
local root = script.Parent.Parent.Parent;
local React = require(root.Packages.react);
local Colors = require(root.Colors);

export type ToolbarButtonProps = {
  iconImage: string;
  text: string;
  layoutOrder: number;
  isDisabled: boolean?;
  isHighlighted: boolean?;
  onClick: () -> ();
};

local function ToolbarButton(props: ToolbarButtonProps)

  return React.createElement("TextButton", {
    LayoutOrder = props.layoutOrder;
    BackgroundTransparency = 0;
    BackgroundColor3 = if props.isHighlighted then Colors.backgroundWarning else Color3.fromRGB(74, 74, 74);
    AutoButtonColor = not props.isDisabled;
    Text = "";
    Size = UDim2.new(0, 0, 0, 0);
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
    IconImageLabel = React.createElement("ImageLabel", {
      LayoutOrder = 1;
      BackgroundTransparency = 1;
      Image = props.iconImage;
      Size = UDim2.new(0, 24, 0, 24);
      ImageColor3 = if props.isDisabled then Colors.textDisabled else Colors.text;
    });
    TextLabel = React.createElement("TextLabel", {
      LayoutOrder = 2;
      BackgroundTransparency = 1;
      Text = props.text;
      TextSize = 12;
      Size = UDim2.new(0, 0, 1, 0);
      AutomaticSize = Enum.AutomaticSize.X;
      TextColor3 = if props.isDisabled then Colors.textDisabled else Colors.text;
      FontFace = Font.fromId(11702779517);
    });
  });

end;

return ToolbarButton;