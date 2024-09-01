--!strict
local React = require(script.Parent.Parent.Packages.react);
local Colors = require(script.Parent.Parent.Colors);

local function DialogueTableHeader()

  return React.createElement("Frame", {
    LayoutOrder = 1;
    BackgroundColor3 = Color3.fromRGB(57, 57, 57);
    Size = UDim2.new(1, -12, 0, 22);
    BorderSizePixel = 0;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
      Padding = UDim.new(0, 3);
    });
    PriorityTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 1;
      Text = "Priority";
      BorderSizePixel = 0;
      BackgroundColor3 = Colors.backgroundTableHeader;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
      Size = UDim2.new(0.17, 0, 1, 0);
      TextSize = 14;
      TextColor3 = Colors.text;
      TextXAlignment = Enum.TextXAlignment.Center;
    });
    TypeTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 2;
      BorderSizePixel = 0;
      BackgroundColor3 = Colors.backgroundTableHeader;
      Text = "Type";
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
      Size = UDim2.new(0.286, 0, 1, 0);
      TextSize = 14;
      TextColor3 = Colors.text;
      TextXAlignment = Enum.TextXAlignment.Center;
    });
    ScriptsTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 3;
      Text = "";
      BorderSizePixel = 0;
      BackgroundColor3 = Colors.backgroundTableHeader;
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
      BorderSizePixel = 0;
      BackgroundColor3 = Colors.backgroundTableHeader;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
      Size = UDim2.new(0.191, 0, 1, 0);
      TextSize = 14;
      TextColor3 = Colors.text;
      TextXAlignment = Enum.TextXAlignment.Center;
    });
    ChildrenTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 5;
      Text = "Children";
      BorderSizePixel = 0;
      BackgroundColor3 = Colors.backgroundTableHeader;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
      Size = UDim2.new(0.254, 0, 1, 0);
      TextSize = 14;
      TextColor3 = Colors.text;
      TextXAlignment = Enum.TextXAlignment.Center;
    });
  })

end;

return DialogueTableHeader;