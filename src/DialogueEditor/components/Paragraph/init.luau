--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type ParagraphProperties = {
  text: string;
  textColor3: Color3?;
  automaticSize: Enum.AutomaticSize?;
  textWrapped: boolean?;
  layoutOrder: number?;
  textSize: number?;
  children: React.ReactNode?;
  fontWeight: Enum.FontWeight?;
}

local function Paragraph(properties: ParagraphProperties)

  local colors = useStudioColors();
  local text = properties.text;
  local automaticSize = if properties.automaticSize ~= nil then properties.automaticSize else Enum.AutomaticSize.XY;
  local textWrapped = if properties.textWrapped ~= nil then properties.textWrapped else true;
  local layoutOrder = if properties.layoutOrder ~= nil then properties.layoutOrder else 1;
  local textColor3 = if properties.textColor3 ~= nil then properties.textColor3 else colors.text;
  local textSize = if properties.textSize ~= nil then properties.textSize else 14;
  local children = properties.children;
  local fontWeight = if properties.fontWeight ~= nil then properties.fontWeight else Enum.FontWeight.Regular;

  return React.createElement("TextLabel", {
    AutomaticSize = automaticSize;
    Text = text;
    TextColor3 = textColor3;
    TextWrapped = textWrapped;
    FontFace = Font.fromName("BuilderSans", fontWeight);
    TextSize = textSize;
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
  }, children);

end;

return React.memo(Paragraph);