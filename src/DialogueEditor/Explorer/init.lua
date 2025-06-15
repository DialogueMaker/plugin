--!strict

local root = script.Parent.Parent;
local React = require(root.roblox_packages.react);
local DialogueGroupContainer = require(script.DialogueGroupContainer);

export type DialogueTableProperties = {
  selectedScript: ModuleScript?;
  plugin: Plugin;
  setSettingsTarget: (target: ModuleScript?) -> ();
  layoutOrder: number;
}

local function Explorer(props: DialogueTableProperties)

  local setSettingsTarget = props.setSettingsTarget;
  local layoutOrder = props.layoutOrder;

  return React.createElement("Frame", {
    Size = UDim2.fromScale(1, 1);
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
      PaddingTop = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
    });
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 15);
    });
    UIFlexItem = React.createElement("UIFlexItem", {
      FlexMode = Enum.UIFlexMode.Shrink;
    });
    Visualizer = React.createElement("Frame", {
      BackgroundTransparency = 1;
      LayoutOrder = 1;
      AutomaticSize = Enum.AutomaticSize.Y;
      Size = UDim2.fromScale(1, 0);
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Vertical;
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
        Padding = UDim.new(0, 15);
      });
    });
    DialogueGroupContainer = React.createElement(DialogueGroupContainer, {
      selectedScript = props.selectedScript;
      plugin = props.plugin;
      setSettingsTarget = setSettingsTarget;
    });
  })

end;

return React.memo(Explorer);