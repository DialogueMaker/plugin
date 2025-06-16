--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type ContentPreviewProperties = {
  layoutOrder: number;
  children: React.ReactNode;
}

local function ContentPreview(properties: ContentPreviewProperties)

  local colors = useStudioColors();
  local children = properties.children;
  local layoutOrder = properties.layoutOrder;

  return React.createElement("Frame", {
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
    Size = UDim2.new(1, 0, 0, 100);
  }, {
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
    UIStroke = React.createElement("UIStroke", {
      Color = colors.border;
      Thickness = 1;
      ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    });
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      VerticalAlignment = Enum.VerticalAlignment.Center;
      HorizontalAlignment = Enum.HorizontalAlignment.Center;
      Padding = UDim.new(0, 10);
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
    });
    Children = React.createElement(React.Fragment, {}, children);
  });

end;

return React.memo(ContentPreview);