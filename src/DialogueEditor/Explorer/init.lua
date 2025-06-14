--!strict

local root = script.Parent.Parent;
local React = require(root.roblox_packages.react);
local DialogueTableHeader = require(script.DialogueTableHeader);
local DialogueTableBody = require(script.DialogueTableBody);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type DialogueTableProperties = {
  selectedScript: ModuleScript?;
  plugin: Plugin;
  setSettingsTarget: (target: ModuleScript?) -> ();
}

local function Explorer(props: DialogueTableProperties)

  local setSettingsTarget = props.setSettingsTarget;

  local colors = useStudioColors();

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 1, 0);
    BackgroundTransparency = 1;
    LayoutOrder = 2;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 2);
    });
    UIFlexItem = React.createElement("UIFlexItem", {
      FlexMode = Enum.UIFlexMode.Shrink;
    });
    TopBorder = React.createElement("Frame", {
      LayoutOrder = 1;
      Size = UDim2.new(1, 0, 0, 1);
      BackgroundColor3 = colors.border;
      BorderSizePixel = 0;
    });
    DialogueTableHeader = React.createElement(DialogueTableHeader);
    DialogueTableBody = React.createElement(DialogueTableBody, {
      selectedScript = props.selectedScript;
      plugin = props.plugin;
      setSettingsTarget = setSettingsTarget;
    });
  })

end;

return React.memo(Explorer);