--!strict


local root = script.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Button = require(root.DialogueEditor.components.Button);
local Checkbox = require(root.DialogueEditor.components.Checkbox);
local ContentPreview = require(script.components.ContentPreview);
local Paragraph = require(root.DialogueEditor.components.Paragraph);
local RedirectSelector = require(script.components.RedirectSelector);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useDialogueContentScript = require(script.hooks.useDialogueContentScript);
local DialogueTypeDropdown = require(script.components.DialogueTypeDropdown);
local DialogueOptions = require(script.components.DialogueOptions);
local useDialogueScriptType = require(root.DialogueEditor.hooks.useDialogueScriptType);
local AutoTriggerCheckbox = require(script.components.AutoTriggerCheckbox);

type DialogueScriptType = useDialogueScriptType.DialogueScriptType;

export type PreviewProperties = {
  dialogueScriptType: DialogueScriptType?;
  selectedScript: ModuleScript;
  layoutOrder: number;
  plugin: Plugin;
}

local function Preview(properties: PreviewProperties)

  local selectedScript = properties.selectedScript;
  local layoutOrder = properties.layoutOrder;
  local plugin = properties.plugin;
  local colors = useStudioColors();
  local dialogueContentScript, isDialogueContentScriptEnabled = useDialogueContentScript(selectedScript);
  local dialogueScriptType: DialogueScriptType? = properties.dialogueScriptType :: DialogueScriptType?;

  return React.createElement("Frame", {
    BackgroundColor3 = colors.toolbar;
    LayoutOrder = layoutOrder;
    AutomaticSize = Enum.AutomaticSize.Y;
    Size = UDim2.fromScale(1, 0);
    ZIndex = 2;
  }, {
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
    });
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Vertical;
      Padding = UDim.new(0, 15);
    });
    DialogueMetadata = React.createElement("Frame", {
      BackgroundTransparency = 1;
      LayoutOrder = 1;
      Size = UDim2.fromScale(1, 0);
      AutomaticSize = Enum.AutomaticSize.Y;
      ZIndex = 2;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        Padding = UDim.new(0, 15);
        Wraps = true;
      });
      DialogueTypeDropdown = React.createElement(DialogueTypeDropdown, {
        layoutOrder = 1;
        selectedScript = selectedScript;
        selectedDialogueType = dialogueScriptType;
      });
      ShouldAutoTriggerConversationCheckbox = if dialogueScriptType == "Conversation" then
        React.createElement(AutoTriggerCheckbox, {
          layoutOrder = 2;
          selectedScript = selectedScript;
        })
      else nil;
      ShouldUseDynamicContent = if dialogueScriptType == "Message" or dialogueScriptType == "Response" then
        React.createElement(Checkbox, {
          text = "Dynamic content";
          isChecked = isDialogueContentScriptEnabled;
          layoutOrder = 3;
          onChanged = function(isChecked: boolean)

            if not dialogueContentScript then

              local newDialogueContentScript = root.Templates.DialogueContentScriptTemplate:Clone();
              newDialogueContentScript.Name = "ContentScript";
              newDialogueContentScript.Parent = selectedScript;
              dialogueContentScript = newDialogueContentScript;

            end;

            assert(dialogueContentScript and dialogueContentScript:IsA("ModuleScript"), `Dialogue content script not found for {selectedScript:GetFullName()}.`);

            dialogueContentScript:SetAttribute("IsDisabled", not isChecked);

          end;
        })
      else nil;
    });
    DialogueContentBox = if not isDialogueContentScriptEnabled and dialogueScriptType == "Message" or dialogueScriptType == "Response" then
      React.createElement("TextBox", {
        Text = selectedScript:GetAttribute("DialogueContent") or "";
        PlaceholderText = "Enter dialogue content here. For variables and effects, use dynamic content.";
        TextColor3 = colors.text;
        ClearTextOnFocus = false;
        TextSize = 14;
        LayoutOrder = 2;
        Size = UDim2.new(1, 0, 0, 100);
        BackgroundColor3 = colors.input;
        FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
        [React.Change.Text] = function(self: TextBox)

          selectedScript:SetAttribute("DialogueContent", self.Text);

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
      })
    else nil;
    DynamicContentGuide = if (dialogueScriptType == "Message" or dialogueScriptType == "Response") and dialogueContentScript and isDialogueContentScriptEnabled then
      React.createElement(ContentPreview, {
        layoutOrder = 3;
      }, {
        NotificationLabel = React.createElement(Paragraph, {
          text = "For your safety, dynamic content cannot be previewed in the Dialogue Maker.";
        });
        NotificationButton = React.createElement(Button, {
          text = "Open script editor";
          layoutOrder = 2;
          onClick = function()

            plugin:OpenScript(dialogueContentScript);

          end;
        });
      })
    else nil;
    RedirectSelector = if dialogueScriptType == "Redirect" then
      React.createElement(RedirectSelector, {
        selectedScript = selectedScript;
        layoutOrder = 3;
      })
    else nil;
    Options = React.createElement(DialogueOptions, {
      layoutOrder = 4;
      selectedScript = selectedScript;
      plugin = plugin;
      selectedDialogueType = dialogueScriptType;
    });
  });

end;

return React.memo(Preview);