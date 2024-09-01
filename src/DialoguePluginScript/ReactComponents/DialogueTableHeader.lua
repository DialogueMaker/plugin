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
      Size = UDim2.new(0, 60, 1, 0);
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
      Size = UDim2.new(0, 0, 1, 0);
      AutomaticSize = Enum.AutomaticSize.X;
      TextSize = 14;
      TextColor3 = Colors.text;
      TextXAlignment = Enum.TextXAlignment.Left;
    }, {
      UIFlexItem = React.createElement("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Fill;
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 5);
        PaddingRight = UDim.new(0, 5);
      });
    });
    ScriptsImageLabel = React.createElement("ImageLabel", {
      LayoutOrder = 3;
      BackgroundColor3 = Colors.backgroundTableHeader;
      BorderSizePixel = 0;
      Size = UDim2.new(0, 24, 1, 0);
      Image = "rbxassetid://14098739279";
    }, {
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 10);
        PaddingRight = UDim.new(0, 10);
      })
    });
    ContentTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 4;
      Text = "Content";
      BorderSizePixel = 0;
      BackgroundColor3 = Colors.backgroundTableHeader;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
      Size = UDim2.new(0, 70, 1, 0);
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
      Size = UDim2.new(0, 70, 1, 0);
      TextSize = 14;
      TextColor3 = Colors.text;
      TextXAlignment = Enum.TextXAlignment.Center;
    });
  })

end;

return DialogueTableHeader;