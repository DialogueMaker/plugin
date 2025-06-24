--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);

export type TabSelectorProperties = {
  children: React.ReactNode;
};

local function TabSelector(properties: TabSelectorProperties)

  local children = properties.children;

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 10);
      FillDirection = Enum.FillDirection.Horizontal;
    });
    TabSelectorButtons = React.createElement(React.Fragment, {}, children);
  });

end;

return React.memo(TabSelector);