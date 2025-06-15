--!strict

local root = script.Parent.Parent;
local React = require(root.roblox_packages.react);
local DialogueGroupContainer = require(script.DialogueGroupContainer);
local Preview = require(script.Preview);

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

  return React.createElement("Frame", {
    Size = UDim2.fromScale(1, 1);
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
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