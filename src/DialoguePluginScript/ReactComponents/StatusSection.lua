--!strict
local React = require(script.Parent.Parent.Packages.react);

export type StatusSectionProperties = {
  viewingPriority: string;
  model: Model;
}

local function StatusSection(props: StatusSectionProperties)

  return React.createElement("Frame", {}, {
    UIListLayout = React.createElement("UIListLayout");
    ModelLocationTextLabel = React.createElement("TextLabel", {
      Text = props.model.Name;
    });
    DialoguePriorityTextLabel = React.createElement("TextLabel", {
      Text = `Viewing {if props.viewingPriority == "" then "the beginning of the conversation" else props.viewingPriority}`;
    });
  })

end;

return StatusSection;