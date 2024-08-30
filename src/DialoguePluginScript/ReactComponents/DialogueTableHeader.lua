--!strict
local React = require(script.Parent.Parent.Packages.react);

local function DialogueTableHeader()

  return React.createElement("Frame", {}, {
    UIListLayout = React.createElement("UIListLayout");
    PriorityTextLabel = React.createElement("TextLabel");
    TypeTextLabel = React.createElement("TextLabel");
    ScriptsTextLabel = React.createElement("TextLabel", {}, {
      ImageLabel = React.createElement("ImageLabel", {
        Image = "rbxassetid://14098739279";
      })
    });
    ContentTextLabel = React.createElement("TextLabel");
    ChildrenTextLabel = React.createElement("TextLabel");
  })

end;

return DialogueTableHeader;