--!strict
local React = require(script.Parent.Parent.Packages.react);
local DialogueTableHeader = require(script.Parent.DialogueTableHeader);
local DialogueTableBody = require(script.Parent.DialogueTableBody);

export type DialogueTableProperties = {
  isDeleteModeEnabled: boolean;
  dialogueParent: ModuleScript | Folder;
  setDialogueParent: (ModuleScript | Folder) -> ();
  plugin: Plugin;
}

local function DialogueTable(props: DialogueTableProperties)

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
    DialogueTableHeader = React.createElement(DialogueTableHeader);
    DialogueTableBody = React.createElement(DialogueTableBody, {
      dialogueParent = props.dialogueParent;
      isDeleteModeEnabled = props.isDeleteModeEnabled;
      setDialogueParent = props.setDialogueParent;
      plugin = props.plugin;
    });
  })

end;

return DialogueTable;