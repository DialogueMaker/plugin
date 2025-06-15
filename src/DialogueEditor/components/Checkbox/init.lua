--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useStudioIcons = require(root.DialogueEditor.hooks.useStudioIcons);

export type CheckboxProperties = {
  text: string;
  isChecked: boolean;
  isDisabled: boolean?;
  layoutOrder: number?;
  onChanged: (isChecked: boolean) -> ();
}

local function Checkbox(properties: CheckboxProperties)

  local text = properties.text;
  local isChecked = properties.isChecked;
  local isDisabled = properties.isDisabled or false;
  local layoutOrder = properties.layoutOrder or 0;
  local onChanged = properties.onChanged;
  local colors = useStudioColors();
  local icons = useStudioIcons();

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
      HorizontalAlignment = Enum.HorizontalAlignment.Left;
      VerticalAlignment = Enum.VerticalAlignment.Center;
      Padding = UDim.new(0, 10);
    });
    Checkbox = React.createElement("TextButton", {
      Size = UDim2.fromOffset(20, 20);
      BackgroundColor3 = if isChecked then Color3.new(0.2, 0.6, 0.2) else Color3.new(0.4, 0.4, 0.4);
      BackgroundTransparency = if isDisabled then 0.5 else 0;
      LayoutOrder = 1;
      Text = "";
      [React.Event.Activated] = function()

        if not isDisabled then

          onChanged(not isChecked);
        
        end;

      end;
    }, {
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 5);
      });
      CheckImageLabel = if isChecked then
        React.createElement("ImageLabel", {
          Size = UDim2.fromScale(1, 1);
          BackgroundTransparency = 1;
          Image = icons.check;
          ImageColor3 = Color3.new(1, 1, 1);
          ImageTransparency = if isDisabled then 0.5 else 0;
        })
      else nil;
    });
    TextLabel = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = text;
      LayoutOrder = 2;
      TextSize = 14;
      FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
      TextColor3 = colors.text;
      TextTransparency = if isDisabled then 0.5 else 0;
      BackgroundTransparency = 1;
    });
  });

end;

return React.memo(Checkbox);