--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

local function DialogueTableHeader()

  local colors = useStudioColors();

  return React.createElement("Frame", {
    LayoutOrder = 2;
    BackgroundTransparency = 1;
    Size = UDim2.new(1, 0, 0, 22);
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
      BackgroundTransparency = 1;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
      Size = UDim2.new(0, 60, 1, 0);
      TextSize = 14;
      TextColor3 = colors.text;
      TextXAlignment = Enum.TextXAlignment.Center;
    });
    LabelTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 1;
      Text = "Label";
      BorderSizePixel = 0;
      BackgroundTransparency = 1;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
      Size = UDim2.new(0, 100, 1, 0);
      TextSize = 14;
      TextColor3 = colors.text;
      TextXAlignment = Enum.TextXAlignment.Left;
    });
    TypeTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 2;
      BorderSizePixel = 0;
      Text = "Type";
      BackgroundTransparency = 1;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Medium);
      Size = UDim2.new(0, 0, 1, 0);
      AutomaticSize = Enum.AutomaticSize.X;
      TextSize = 14;
      TextColor3 = colors.text;
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
  })

end;

return React.memo(DialogueTableHeader);