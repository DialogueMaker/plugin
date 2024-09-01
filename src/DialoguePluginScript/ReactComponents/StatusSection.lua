--!strict
local React = require(script.Parent.Parent.Packages.react);
local useViewingPriority = require(script.Parent.Parent.ReactHooks.useViewingPriority);
local Colors = require(script.Parent.Parent.Colors);

export type StatusSectionProperties = {
  model: Model;
  dialogueParent: ModuleScript | Folder;
}

local function StatusSection(props: StatusSectionProperties)

  local viewingPriority = useViewingPriority(props.dialogueParent);

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 0);
    BackgroundTransparency = 1;
    LayoutOrder = 2;
    AutomaticSize = Enum.AutomaticSize.Y;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    ModelLocationTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 1;
      Text = props.model.Name;
      TextColor3 = Colors.text;
      BorderSizePixel = 0;
      TextSize = 16;
      BackgroundColor3 = Color3.fromRGB(88, 88, 88);
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Regular);
      Size = UDim2.new(1, 0, 0, 0);
      AutomaticSize = Enum.AutomaticSize.Y;
    }, {
      UIPadding = React.createElement("UIPadding", {
        PaddingTop = UDim.new(0, 5);
        PaddingBottom = UDim.new(0, 5);
      });
    });
    DialoguePriorityTextLabel = React.createElement("TextLabel", {
      LayoutOrder = 2;
      Text = `Viewing {if viewingPriority == "" then "the beginning of the conversation" else viewingPriority}`;
      TextColor3 = Colors.text;
      BorderSizePixel = 0;
      BackgroundTransparency = 1;
      TextSize = 14;
      FontFace = Font.fromId(11702779517, Enum.FontWeight.Regular);
      Size = UDim2.new(1, 0, 0, 0);
      AutomaticSize = Enum.AutomaticSize.Y;
    }, {
      UIPadding = React.createElement("UIPadding", {
        PaddingTop = UDim.new(0, 5);
        PaddingBottom = UDim.new(0, 5);
      });
    });
  })

end;

return StatusSection;