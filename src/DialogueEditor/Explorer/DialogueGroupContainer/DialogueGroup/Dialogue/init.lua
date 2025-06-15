--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type DialogueItemType = "Conversation" | "Response" | "Message" | "Redirect";

export type DialogueItemProperties = {
  type: DialogueItemType;
  dialogueScript: ModuleScript;
  layoutOrder: number;
  plugin: Plugin;
  setSettingsTarget: (target: ModuleScript?) -> ();
}

local function DialogueItem(props: DialogueItemProperties)

  local dialogueType = props.type;
  local dialogueScript = props.dialogueScript;

  local colors = useStudioColors();

  local dialogueContent = dialogueScript:GetAttribute("DialogueContent");

  return React.createElement("TextButton", {
    BackgroundColor3 = colors.toolbar;
    BorderSizePixel = 0;
    LayoutOrder = props.layoutOrder;
    AutomaticSize = Enum.AutomaticSize.Y;
    Size = UDim2.fromScale(1, 0);
    Text = "";
    [React.Event.Activated] = function()
      
      Selection:Set({dialogueScript});

    end;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
      Padding = UDim.new(0, 5);
    });
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
      PaddingTop = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
    });
    LabelTextBox = React.createElement("TextLabel", {
      Text = if dialogueType == "Conversation" then dialogueScript.Name else (dialogueContent or "Nothing yet...");
      TextColor3 = colors.text;
      TextTransparency = if dialogueType == "Conversation" or dialogueContent then 0 else 0.5;
      LayoutOrder = 2;
      AutomaticSize = Enum.AutomaticSize.XY;
      FontFace = Font.fromId(11702779517);
      BackgroundTransparency = 1;
      TextSize = 14;
      TextXAlignment = Enum.TextXAlignment.Left;
    });
  })

end;

return React.memo(DialogueItem);