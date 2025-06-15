--!strict

local ChangeHistoryService = game:GetService("ChangeHistoryService");
local Selection = game:GetService("Selection");

local root = script.Parent.Parent;
local React = require(root.roblox_packages.react);
local useRefreshDialogueMakerScripts = require(root.DialogueEditor.hooks.useRefreshDialogueMakerScripts);
local ToolbarButton = require(script.ToolbarButton);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useStudioIcons = require(root.DialogueEditor.hooks.useStudioIcons);

export type ToolbarProps = {
  selectedScript: ModuleScript?;
  plugin: Plugin;
  settingsTarget: ModuleScript?;
  setSettingsTarget: (target: ModuleScript?) -> ();
  layoutOrder: number;
}

local function Toolbar(props: ToolbarProps)

  local colors = useStudioColors();
  local icons = useStudioIcons();
  local refreshDialogueMakerScripts = useRefreshDialogueMakerScripts();
  local selectedScript = props.selectedScript;
  local settingsTarget = props.settingsTarget;
  local layoutOrder = props.layoutOrder;
  local setSettingsTarget = props.setSettingsTarget;

  local addDialogueScript = React.useCallback(function(type: "Message" | "Response" | "Redirect" | "Conversation")
  
    if ChangeHistoryService:IsRecordingInProgress() then

      ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);

    end;

    local historyIdentifier;
    if type == "Conversation" then

      historyIdentifier = ChangeHistoryService:TryBeginRecording("Add conversation");

      local newContentScript = root.Templates.ConversationTemplate:Clone();
      newContentScript:AddTag("DialogueMakerConversationScript");
      newContentScript.Parent = Selection:Get()[1];
      
    elseif selectedScript then

      historyIdentifier = ChangeHistoryService:TryBeginRecording(`Add {type:lower()} to NPC`);

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

      newContentScript.Parent = selectedScript;

    end;

    ChangeHistoryService:FinishRecording(historyIdentifier, Enum.FinishRecordingOperation.Commit);
    refreshDialogueMakerScripts();

  end, {selectedScript :: unknown, refreshDialogueMakerScripts});

  local isRedirect = if selectedScript then selectedScript:GetAttribute("DialogueType") == "Redirect" else false;

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 40);
    LayoutOrder = layoutOrder;
    BackgroundColor3 = colors.toolbar;
    BorderSizePixel = 0;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
    });
    ViewParentButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14098871159";
      text = "View parent";
      layoutOrder = 1;
      isDisabled = settingsTarget ~= nil or not selectedScript;
      onClick = function()

        if selectedScript then

          Selection:Set({selectedScript.Parent});

        end;

      end;
    });
    SettingsButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14099277263";
      text = if settingsTarget == nil then "Settings" else "Close settings";
      layoutOrder = 2;
      onClick = function()

        if settingsTarget then

          setSettingsTarget(nil);

        elseif selectedScript then

          setSettingsTarget(selectedScript);

        end;

      end;
    });
    AddConversationButton = if not selectedScript then
      React.createElement(ToolbarButton, {
        iconImage = "rbxassetid://14099284898";
        text = "Add conversation";
        layoutOrder = 3;
        isDisabled = settingsTarget ~= nil or #Selection:Get() ~= 1;
        onClick = function()

          addDialogueScript("Conversation");

        end;
      })
    else nil;
    AddMessageButton = if selectedScript and not isRedirect then
      React.createElement(ToolbarButton, {
        iconImage = "rbxassetid://14099284898";
        text = "Add message";
        layoutOrder = 4;
        isDisabled = settingsTarget ~= nil or #Selection:Get() ~= 1;
        onClick = function()

          addDialogueScript("Message");

        end;
      })
    else nil;
    AddResponseButton = if selectedScript and not isRedirect then
      React.createElement(ToolbarButton, {
        iconImage = "rbxassetid://14099284898";
        text = "Add response";
        layoutOrder = 5;
        isDisabled = settingsTarget ~= nil or #Selection:Get() ~= 1;
        onClick = function()

          addDialogueScript("Response");

        end;
      })
    else nil;
    AddRedirectButton = if selectedScript and not isRedirect then
      React.createElement(ToolbarButton, {
        iconImage = "rbxassetid://14099284898";
        text = "Add redirect";
        layoutOrder = 6;
        isDisabled = settingsTarget ~= nil or #Selection:Get() ~= 1;
        onClick = function()

          addDialogueScript("Redirect");

        end;
      })
    else nil;
    LinkDialogueButton = if isRedirect then
      React.createElement(ToolbarButton, {
        iconImage = icons.link;
        text = "Link dialogue";
        layoutOrder = 7;
        isDisabled = settingsTarget ~= nil or not selectedScript;
        onClick = function()

          

        end;
      })
    else nil;
  });

end;

return React.memo(Toolbar);