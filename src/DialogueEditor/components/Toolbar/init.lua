--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useRefreshDialogueMakerScripts = require(root.DialogueEditor.hooks.useRefreshDialogueMakerScripts);
local ToolbarButton = require(script.ToolbarButton);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useDialogueScriptType = require(root.DialogueEditor.hooks.useDialogueScriptType);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);
local useDynamicSize = require(root.DialogueEditor.hooks.useDynamicSize);
local useStudioIcons = require(root.DialogueEditor.hooks.useStudioIcons);

export type ToolbarProps = {
  selectedScript: ModuleScript?;
  plugin: Plugin;
  pluginGUI: DockWidgetPluginGui;
  settingsTarget: ModuleScript?;
  setSettingsTarget: (target: ModuleScript?) -> ();
  layoutOrder: number;
}

local function Toolbar(props: ToolbarProps)

  local icons = useStudioIcons();
  local pluginGUI = props.pluginGUI;
  local colors = useStudioColors();
  local refreshDialogueMakerScripts = useRefreshDialogueMakerScripts();
  local selectedScript = props.selectedScript;
  local settingsTarget = props.settingsTarget;
  local layoutOrder = props.layoutOrder;
  local setSettingsTarget = props.setSettingsTarget;
  local dialogueScriptType = useDialogueScriptType(selectedScript);
  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();
  local shouldShowLabels = useDynamicSize(pluginGUI, 570);

  local addDialogueScript = React.useCallback(function(type: "Message" | "Response" | "Redirect" | "Conversation")

    local historyIdentifier;
    if type == "Conversation" then

      historyIdentifier = beginHistoryRecording("Add conversation");

      local parent = Selection:Get()[1];
      if not parent:IsA("Folder") or parent.Name ~= "Conversations" then

        local conversationsFolder = parent:FindFirstChild("Conversations");
        if not conversationsFolder then

          local newConversationsFolder = Instance.new("Folder");
          newConversationsFolder.Name = "Conversations";
          newConversationsFolder.Parent = parent;
          conversationsFolder = newConversationsFolder;

        end;

        parent = conversationsFolder;

      end;

      local newContentScript = root.Templates.ConversationTemplate:Clone();
      newContentScript.Name = "Conversation";
      newContentScript:AddTag("DialogueMakerConversationScript");
      newContentScript.Parent = parent;
      
    elseif selectedScript then

      historyIdentifier = beginHistoryRecording(`Add {type:lower()} to NPC`);

      -- Find a name for the content script.
      local targetPriority = 1;
      for _, instance in selectedScript:GetChildren() do
        
        local comparedName = tonumber(instance.Name);
        if comparedName and comparedName >= targetPriority then
          
          targetPriority = comparedName + 1;
          
        end
        
      end;

      -- Create the content script.
      local newContentScript = root.Templates.DialogueTemplate:Clone();
      newContentScript:AddTag("DialogueMakerDialogueScript");
      newContentScript.Name = targetPriority;
      newContentScript:SetAttribute("DialogueType", type);
      
      if type ~= "Redirect" then

        newContentScript:SetAttribute("DialogueContent", "Hello world!");

      end;

      local targetFolder = selectedScript:FindFirstChild(`{type}s`);
      if not targetFolder then

        local newTargetFolder = Instance.new("Folder");
        newTargetFolder.Name = `{type}s`;
        newTargetFolder.Parent = selectedScript;
        targetFolder = newTargetFolder;

      end;

      newContentScript.Parent = targetFolder;

    end;

    finishHistoryRecording(historyIdentifier);
    refreshDialogueMakerScripts();

  end, {selectedScript :: unknown, refreshDialogueMakerScripts});

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 40);
    LayoutOrder = layoutOrder;
    BackgroundColor3 = colors.toolbar;
    BorderSizePixel = 0;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
      VerticalAlignment = Enum.VerticalAlignment.Center;
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 10);
      PaddingRight = UDim.new(0, 10);
      PaddingBottom = UDim.new(0, 5);
    });
    ViewParentButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14098871159";
      text = if shouldShowLabels then "View parent" else nil;
      layoutOrder = 1;
      isDisabled = settingsTarget ~= nil or not selectedScript;
      onClick = function()

        if selectedScript then

          Selection:Set({selectedScript.Parent});

        end;

      end;
    });
    SettingsButton = if dialogueScriptType then
      React.createElement(ToolbarButton, {
        iconImage = icons.settings;
        text = if shouldShowLabels then (if settingsTarget == nil then "Settings" else "Close settings") else nil;
        layoutOrder = 2;
        onClick = function()

          if settingsTarget then

            setSettingsTarget(nil);

          else

            setSettingsTarget(selectedScript);

          end;

        end;
      })
    else nil;
    AddConversationButton = if not selectedScript then
      React.createElement(ToolbarButton, {
        iconImage = icons.conversation;
        text = if shouldShowLabels then "Add conversation" else nil;
        layoutOrder = 3;
        isDisabled = settingsTarget ~= nil or #Selection:Get() ~= 1;
        onClick = function()

          addDialogueScript("Conversation");

        end;
      })
    else nil;
    AddMessageButton = if selectedScript and dialogueScriptType ~= "Redirect" then
      React.createElement(ToolbarButton, {
        iconImage = icons.message;
        text = if shouldShowLabels then "Add message" else nil;
        layoutOrder = 4;
        isDisabled = settingsTarget ~= nil or #Selection:Get() ~= 1;
        onClick = function()

          addDialogueScript("Message");

        end;
      })
    else nil;
    AddResponseButton = if selectedScript and dialogueScriptType ~= "Redirect" then
      React.createElement(ToolbarButton, {
        iconImage = icons.response;
        text = if shouldShowLabels then "Add response" else nil;
        layoutOrder = 5;
        isDisabled = settingsTarget ~= nil or #Selection:Get() ~= 1;
        onClick = function()

          addDialogueScript("Response");

        end;
      })
    else nil;
    AddRedirectButton = if selectedScript and dialogueScriptType ~= "Redirect" then
      React.createElement(ToolbarButton, {
        iconImage = icons.redirect;
        text = if shouldShowLabels then (if shouldShowLabels then "Add redirect" else nil) else nil;
        layoutOrder = 6;
        isDisabled = settingsTarget ~= nil or #Selection:Get() ~= 1;
        onClick = function()

          addDialogueScript("Redirect");

        end;
      })
    else nil;
  });

end;

return React.memo(Toolbar);