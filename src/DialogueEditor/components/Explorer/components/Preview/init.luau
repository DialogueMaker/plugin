--!strict


local root = script.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Button = require(root.DialogueEditor.components.Button);
local ContentPreview = require(script.components.ContentPreview);
local Paragraph = require(root.DialogueEditor.components.Paragraph);
local RedirectSelector = require(script.components.RedirectSelector);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useDialogueContentScript = require(script.hooks.useDialogueContentScript);
local DialogueTypeDropdown = require(script.components.DialogueTypeDropdown);
local DialogueOptions = require(script.components.DialogueOptions);
local useDialogueScriptType = require(root.DialogueEditor.hooks.useDialogueScriptType);
local AutoTriggerCheckbox = require(script.components.AutoTriggerCheckbox);
local DynamicContentCheckbox = require(script.components.DynamicContentCheckbox);
local StaticContentEditor = require(script.components.StaticContentEditor);

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
        React.createElement(DynamicContentCheckbox, {
          layoutOrder = 3;
          selectedScript = selectedScript;
          isChecked = isDialogueContentScriptEnabled;
          dialogueContentScript = dialogueContentScript;
        })
      else nil;
    });
    StaticContentEditor = if not isDialogueContentScriptEnabled and dialogueScriptType == "Message" or dialogueScriptType == "Response" then
      React.createElement(StaticContentEditor, {
        layoutOrder = 2;
        selectedScript = selectedScript;
      })
    else nil;
    DynamicContentEditor = if (dialogueScriptType == "Message" or dialogueScriptType == "Response") and dialogueContentScript and isDialogueContentScriptEnabled then
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
    Options = if dialogueScriptType then
      React.createElement(DialogueOptions, {
        layoutOrder = 4;
        selectedScript = selectedScript;
        plugin = plugin;
        selectedDialogueType = dialogueScriptType;
      })
    else nil;
  });

end;

return React.memo(Preview);