--!strict

local root = script.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type TabSelectorButtonProperties = {
  isSelected: boolean;
  isDisabled: boolean?;
  layoutOrder: number;
  text: string;
  onSelected: () -> ();
}

local function TabSelectorButton(properties: TabSelectorButtonProperties)

  local layoutOrder = properties.layoutOrder;
  local text = properties.text;
  local isSelected = properties.isSelected;
  local isDisabled = properties.isDisabled or false;

  local colors = useStudioColors();

  return React.createElement("TextButton", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundColor3 = if isSelected then colors.primaryButton else colors.toolbar;
    Text = text;
    TextColor3 = colors.text;
    TextTransparency = if isDisabled then 0.5 else 0;
    AutoButtonColor = if isDisabled then false else true;
    TextSize = 12;
    FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
    LayoutOrder = layoutOrder;
    [React.Event.Activated] = function()

      if not isSelected and not isDisabled then

        properties.onSelected();

      end;

    end;
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 10);
      PaddingRight = UDim.new(0, 10);
      PaddingTop = UDim.new(0, 5);
      PaddingBottom = UDim.new(0, 5);
    });
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(1, 0);
    });
  });

end;

return React.memo(TabSelectorButton);