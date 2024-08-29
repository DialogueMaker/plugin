--!strict
local React = require(script.Parent.Parent.Packages.react);
local Toolbar = require(script.Parent.Toolbar);
local StatusSection = require(script.Parent.StatusSection);
local DialogueTable = require(script.Parent.DialogueTable);

export type WindowProperties = {
  model: Model;
}

local function Window(props: WindowProperties)

  local isDeleteModeEnabled, setIsDeleteModeEnabled = React.useState(false);
  local dialogueParent, setDialogueParent = React.useState(nil);
  React.useEffect(function()
  
    print("[Dialogue Maker] " .. if isDeleteModeEnabled then "Warning: Delete Mode has been enabled!" else "Whew. Delete Mode has been disabled.");

  end, {isDeleteModeEnabled});

  return React.createElement("Frame", {}, {
    Toolbar = React.createElement(Toolbar, {
      isDeleteModeEnabled = isDeleteModeEnabled;
      setIsDeleteModeEnabled = setIsDeleteModeEnabled;
      dialogueParent = dialogueParent;
      setDialogueParent = setDialogueParent;
    });
    StatusSection = React.createElement(StatusSection, {
      model = props.model;
    });
    DialogueTable = React.createElement(DialogueTable, {
      isDeleteModeEnabled = isDeleteModeEnabled;
      dialogueParent = dialogueParent;
      setDialogueParent = setDialogueParent;
    });
  });

end;

return Window;