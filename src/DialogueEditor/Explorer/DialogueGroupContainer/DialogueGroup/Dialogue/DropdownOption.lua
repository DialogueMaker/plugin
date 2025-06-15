--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type DropdownOptionProperties = {
  layoutOrder: number;
  onClick: () -> ();
  iconImage: string?;
  text: string;
}

local function DropdownOption(props: DropdownOptionProperties)

  local colors = useStudioColors();

  return React.createElement("TextButton", {
    LayoutOrder = props.layoutOrder;
    Size = UDim2.new(1, 0, 0, 25);
    BackgroundColor3 = colors.backgroundTableRow;
    Text = "";
    [React.Event.Activated] = function()

      props.onClick();

    end;
    BorderSizePixel = 0;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
      VerticalAlignment = Enum.VerticalAlignment.Center;
      Padding = UDim.new(0, 5);
    });
    IconLabel = if props.iconImage then React.createElement("ImageLabel", {
      LayoutOrder = 1;
      Image = props.iconImage;
      Size = UDim2.new(0, 20, 0, 20);
      BackgroundTransparency = 1;
      ImageColor3 = colors.text;
    }) else nil;
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 5);
      PaddingRight = UDim.new(0, 5);
    });
    TextLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Size = UDim2.new(0, 0, 0, 0);
      LayoutOrder = 2;
      Text = props.text;
      FontFace = Font.fromId(11702779517);
      BackgroundTransparency = 1;
      TextSize = 14;
      TextColor3 = colors.text;
    });
  });

end;

return React.memo(DropdownOption);