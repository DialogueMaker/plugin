--!strict
local React = require(script.Parent.Packages.react);
local Toolbar = require(script.Toolbar);
local StatusSection = require(script.StatusSection);
local DialogueTable = require(script.DialogueTable);

export type WindowProperties = {
  model: Model;
  repairNPC: () -> ();
  plugin: Plugin;
}

local function Window(props: WindowProperties)

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
      dialogueParent = dialogueParent;
      setDialogueParent = setDialogueParent;
      plugin = props.plugin;
      repairNPC = props.repairNPC;
      model = props.model;
    });
    DialogueTable = React.createElement(DialogueTable, {
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