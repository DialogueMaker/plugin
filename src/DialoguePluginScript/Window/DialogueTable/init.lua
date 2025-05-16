--!strict
local root = script.Parent.Parent;
local React = require(root.Packages.react);
local DialogueTableHeader = require(script.DialogueTableHeader);
local DialogueTableBody = require(script.DialogueTableBody);
local useStudioColors = require(root.useStudioColors);

export type DialogueTableProperties = {
  dialogueParent: ModuleScript | Folder;
  plugin: Plugin;
}

local function DialogueTable(props: DialogueTableProperties)

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
      dialogueParent = props.dialogueParent;
      plugin = props.plugin;
    });
  })

end;

return DialogueTable;