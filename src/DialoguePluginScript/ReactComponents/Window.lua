--!strict
local React = require(script.Parent.Parent.Packages.react);
local Toolbar = require(script.Parent.Toolbar);
local StatusSection = require(script.Parent.StatusSection);
local DialogueTable = require(script.Parent.DialogueTable);

export type WindowProperties = {
  model: Model;
  plugin: Plugin;
}

local function Window(props: WindowProperties)

  local isDeleteModeEnabled, setIsDeleteModeEnabled = React.useState(false);
  local dialogueParent, setDialogueParent = React.useState(props.model:FindFirstChild("DialogueContainer") :: (ModuleScript | Folder));

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 1, 0);
    BackgroundTransparency = 1;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 0);
    });
    Toolbar = React.createElement(Toolbar, {
      isDeleteModeEnabled = isDeleteModeEnabled;
      setIsDeleteModeEnabled = setIsDeleteModeEnabled;
      dialogueParent = dialogueParent;
      setDialogueParent = setDialogueParent;
    });
    DialogueTable = React.createElement(DialogueTable, {
      isDeleteModeEnabled = isDeleteModeEnabled;
      dialogueParent = dialogueParent;
      setDialogueParent = setDialogueParent;
      plugin = props.plugin;
    });
    StatusSection = React.createElement(StatusSection, {
      dialogueParent = dialogueParent;
    });
  });

end;

return Window;