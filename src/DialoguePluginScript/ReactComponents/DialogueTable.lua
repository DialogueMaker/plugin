--!strict
local React = require(script.Parent.Parent.Packages.react);

local function StatusSection()

  return React.createElement("Frame", {}, {
    UIListLayout = React.createElement("UIListLayout");
    ModelLocationTextLabel = React.createElement("TextLabel");
    DialoguePriorityTextLabel = React.createElement("TextLabel");
  })

end;

return StatusSection;