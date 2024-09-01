--!strict
local React = require(script.Parent.Parent.Packages.react);
local Colors = require(script.Parent.Parent.Colors);

local function DialogueTableHeader()

  return React.createElement("Frame", {
    LayoutOrder = 1;
    BackgroundColor3 = Colors.backgroundTableHeader;
    Size = UDim2.new(1, -12, 0, 22);
    BorderSizePixel = 0;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
    });
    PriorityTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 1;
      Text = "Priority";
      BackgroundTransparency = 1;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
      Size = UDim2.new(0.17, 0, 1, 0);
    });
    TypeTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 2;
      BackgroundTransparency = 1;
      Text = "Type";
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
      Size = UDim2.new(0.286, 0, 1, 0);
    });
    ScriptsTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 3;
      Text = "";
      BackgroundTransparency = 1;
      Size = UDim2.new(0.075, 0, 1, 0);
    }, {
      ImageLabel = React.createElement("ImageLabel", {
        BackgroundTransparency = 1;
        AnchorPoint = Vector2.new(0.5, 0.5);
        Position = UDim2.new(0.5, 0, 0.5, 0);
        Size = UDim2.new(0, 24, 0, 22);
        Image = "rbxassetid://14098739279";
      })
    });
    ContentTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 4;
      Text = "Content";
      BackgroundTransparency = 1;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
      Size = UDim2.new(0.191, 0, 1, 0);
    });
    ChildrenTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 5;
      Text = "Children";
      BackgroundTransparency = 1;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
      Size = UDim2.new(0.254, -12, 1, 0);
    });
  })

end;

return DialogueTableHeader;