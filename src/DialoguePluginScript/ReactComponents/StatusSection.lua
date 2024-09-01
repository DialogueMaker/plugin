--!strict
local React = require(script.Parent.Parent.Packages.react);
local useViewingPriority = require(script.Parent.Parent.ReactHooks.useViewingPriority);
local Colors = require(script.Parent.Parent.Colors);

export type StatusSectionProperties = {
  dialogueParent: ModuleScript | Folder;
}

local function StatusSection(props: StatusSectionProperties)

  local viewingPriority = useViewingPriority(props.dialogueParent);

  return React.createElement("TextLabel", {
    LayoutOrder = 3;
    Text = `Viewing {if viewingPriority == "" then "the beginning of the conversation" else viewingPriority}`;
    TextColor3 = Colors.text;
    BorderSizePixel = 0;
    BackgroundTransparency = 1;
    TextSize = 14;
    FontFace = Font.fromId(11702779517, Enum.FontWeight.Regular);
    Size = UDim2.new(1, 0, 0, 0);
    AutomaticSize = Enum.AutomaticSize.Y;
    TextXAlignment = Enum.TextXAlignment.Left;
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 5);
      PaddingBottom = UDim.new(0, 5);
      PaddingLeft = UDim.new(0, 10);
      PaddingRight = UDim.new(0, 10);
    });
  });

end;

return StatusSection;