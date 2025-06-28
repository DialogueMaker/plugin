--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local ToolbarButton = require(script.ToolbarButton);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);
local useDialogueScriptType = require(root.DialogueEditor.hooks.useDialogueScriptType);
local useDynamicSize = require(root.DialogueEditor.hooks.useDynamicSize);
local useRefreshDialogueMakerScripts = require(root.DialogueEditor.hooks.useRefreshDialogueMakerScripts);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
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
  local plugin = props.plugin;
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

      local targetFolder = selectedScript:FindFirstChild(`{type}s`);
      if not targetFolder then

        local newTargetFolder = Instance.new("Folder");
        newTargetFolder.Name = `{type}s`;
        newTargetFolder.Parent = selectedScript;
        targetFolder = newTargetFolder;

      end;

      assert(targetFolder); -- To silence the type checker.

      -- Find a name for the content script.
      local targetPriority = 1;
      for _, instance in targetFolder:GetChildren() do
        
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

      newContentScript.Parent = targetFolder;

    end;

    finishHistoryRecording(historyIdentifier);
    refreshDialogueMakerScripts();

  end, {selectedScript :: unknown, refreshDialogueMakerScripts});

  local buttons = {};

  local viewParentButton = React.createElement(ToolbarButton, {
    iconImage = "rbxassetid://14098871159";
    text = if shouldShowLabels then "View parent" else nil;
    plugin = plugin;
    layoutOrder = #buttons + 1;
    key = "ViewParentButton";
    isDisabled = settingsTarget ~= nil or not selectedScript;
    onClick = function()

      if selectedScript then

        Selection:Set({selectedScript.Parent});

      end;

    end;
  });

  table.insert(buttons, viewParentButton);

  if dialogueScriptType then

    local settingsButton = React.createElement(ToolbarButton, {
      iconImage = icons.settings;
      text = if shouldShowLabels then (if settingsTarget == nil then "Settings" else "Close settings") else nil;
      layoutOrder = #buttons + 1;
      plugin = plugin;
      key = "SettingsButton";
      onClick = function()

        setSettingsTarget(if settingsTarget then nil else selectedScript);

      end;
    });

    table.insert(buttons, settingsButton);

  end;

  if dialogueScriptType ~= "Redirect" then

    for _, dialogueType in {"Conversation", "Message", "Response", "Redirect"} do

      if (selectedScript and dialogueType == "Conversation") or (not selectedScript and dialogueType ~= "Conversation") then

        continue;

      end;

      local addDialogueButton = React.createElement(ToolbarButton, {
        iconImage = icons[dialogueType:lower()];
        text = if shouldShowLabels then `Add {dialogueType:lower()}` else nil;
        layoutOrder = #buttons + 1;
        plugin = plugin;
        key = `Add{dialogueType}Button`;
        isDisabled = settingsTarget ~= nil or #Selection:Get() ~= 1;
        onClick = function()

          addDialogueScript(dialogueType :: "Conversation" | "Message" | "Response" | "Redirect");

        end;
      });

      table.insert(buttons, addDialogueButton);

    end;

  end;

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
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 5);
    });
    Buttons = React.createElement(React.Fragment, {}, buttons);
  });

end;

return React.memo(Toolbar);