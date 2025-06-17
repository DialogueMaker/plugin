--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type StaticContentEditorProperties = {
  selectedScript: ModuleScript;
  layoutOrder: number;
}

local function StaticContentEditor(properties: StaticContentEditorProperties)

  local selectedScript = properties.selectedScript;
  local layoutOrder = properties.layoutOrder;
  local colors = useStudioColors();
  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();

  local getDialogueContent = React.useCallback(function(): string

    local dialogueContent = selectedScript:GetAttribute("DialogueContent");

    if typeof(dialogueContent) ~= "string" then

      return "";

    end

    return dialogueContent;

  end, {selectedScript});

  local dialogueContent, setDialogueContent = React.useState(getDialogueContent());

  React.useEffect(function()
  
    local function refreshDialogueContent()

      setDialogueContent(getDialogueContent());

    end;

    refreshDialogueContent();
    local attributeChangedConnection = selectedScript:GetAttributeChangedSignal("DialogueContent"):Connect(refreshDialogueContent);

    return function()

      attributeChangedConnection:Disconnect();
      
    end;

  end, {selectedScript});

  return React.createElement("TextBox", {
    Text = dialogueContent;
    PlaceholderText = "Enter dialogue content here. For variables and effects, use dynamic content.";
    TextColor3 = colors.text;
    ClearTextOnFocus = false;
    TextSize = 14;
    LayoutOrder = layoutOrder;
    Size = UDim2.new(1, 0, 0, 100);
    BackgroundColor3 = colors.input;
    FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
    TextXAlignment = Enum.TextXAlignment.Left;
    TextYAlignment = Enum.TextYAlignment.Top;
    [React.Event.FocusLost] = function(self: TextBox)

      local historyIdentifier = beginHistoryRecording("Set static dialogue content");

      selectedScript:SetAttribute("DialogueContent", self.Text);

      finishHistoryRecording(historyIdentifier);

    end;
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
    });
    UISizeConstraint = React.createElement("UISizeConstraint", {
      MinSize = Vector2.new(0, 30);
    });
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
  });

end;

return React.memo(StaticContentEditor);