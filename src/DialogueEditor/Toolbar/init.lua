--!strict

local ChangeHistoryService = game:GetService("ChangeHistoryService");
local Selection = game:GetService("Selection");

local root = script.Parent.Parent;
local React = require(root.roblox_packages.react);
local useRefreshDialogueMakerScripts = require(root.DialogueEditor.hooks.useRefreshDialogueMakerScripts);
local ToolbarButton = require(script.ToolbarButton);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type ToolbarProps = {
  selectedScript: ModuleScript?;
  plugin: Plugin;
  settingsTarget: ModuleScript?;
  setSettingsTarget: (target: ModuleScript?) -> ();
}

local function Toolbar(props: ToolbarProps)

  local colors = useStudioColors();
  local refreshDialogueMakerScripts = useRefreshDialogueMakerScripts();
  local selectedScript = props.selectedScript;
  local settingsTarget = props.settingsTarget;
  local setSettingsTarget = props.setSettingsTarget;

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 40);
    LayoutOrder = 1;
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
    AddMessageButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14099284898";
      text = if selectedScript then "Add message" else "Add conversation";
      layoutOrder = 2;
      isDisabled = settingsTarget ~= nil or #Selection:Get() ~= 1;
      onClick = function()

        if ChangeHistoryService:IsRecordingInProgress() then

          ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);

        end;

        local historyIdentifier;
        if selectedScript then

          historyIdentifier = ChangeHistoryService:TryBeginRecording("Add message to NPC");

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
          newContentScript.Name = targetPriority;
          newContentScript:SetAttribute("DialogueType", "Message");
          newContentScript.Parent = selectedScript;

        else

          historyIdentifier = ChangeHistoryService:TryBeginRecording("Add conversation");

          local newContentScript = root.Templates.ConversationTemplate:Clone();
          newContentScript.Parent = Selection:Get()[1];

        end;

        ChangeHistoryService:FinishRecording(historyIdentifier, Enum.FinishRecordingOperation.Commit);
        refreshDialogueMakerScripts();

      end;
    });
    SettingsButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14099277263";
      text = if settingsTarget == nil then "Settings" else "Close settings";
      layoutOrder = 3;
      onClick = function()

        if settingsTarget then

          setSettingsTarget(nil);

        elseif selectedScript then

          setSettingsTarget(selectedScript);

        end;

      end;
    });
  });

end;

return React.memo(Toolbar);