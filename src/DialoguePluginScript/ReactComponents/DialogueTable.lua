--!strict
local React = require(script.Parent.Parent.Packages.react);
local DialogueTableHeader = require(script.Parent.DialogueTableHeader);
local DialogueTableBody = require(script.Parent.DialogueTableBody);

local function DialogueTable()

  return React.createElement("Frame", {}, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    DialogueTableHeader = React.createElement(DialogueTableHeader);
    DialogueTableBody = React.createElement(DialogueTableBody);
  })

end;

return DialogueTable;