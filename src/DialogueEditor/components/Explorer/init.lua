--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local DialogueGroupContainer = require(script.components.DialogueGroupContainer);
local Preview = require(script.components.Preview);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type DialogueTableProperties = {
  selectedScript: ModuleScript?;
  plugin: Plugin;
  setSettingsTarget: (target: ModuleScript?) -> ();
  layoutOrder: number;
}

local function Explorer(props: DialogueTableProperties)

  local plugin = props.plugin;
  local selectedScript = props.selectedScript;
  local setSettingsTarget = props.setSettingsTarget;
  local layoutOrder = props.layoutOrder;
  local colors = useStudioColors();

  return React.createElement("ScrollingFrame", {
    Size = UDim2.fromScale(1, 1);
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
    AutomaticCanvasSize = Enum.AutomaticSize.Y;
    CanvasSize = UDim2.fromScale(1, 0);
    ScrollingDirection = Enum.ScrollingDirection.Y;
    BorderSizePixel = 0;
    ScrollBarImageColor3 = colors.border;
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
      PaddingTop = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
    });
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 15);
    });
    UIFlexItem = React.createElement("UIFlexItem", {
      FlexMode = Enum.UIFlexMode.Shrink;
    });
    Preview = if selectedScript then
      React.createElement(Preview, {
        layoutOrder = 1;
        selectedScript = selectedScript;
        plugin = plugin;
      })
    else nil;
    DialogueGroupContainer = React.createElement(DialogueGroupContainer, {
      selectedScript = selectedScript;
      layoutOrder = 2;
      plugin = plugin;
      setSettingsTarget = setSettingsTarget;
    });
  })

end;

return React.memo(Explorer);