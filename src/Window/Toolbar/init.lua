--!strict
local ChangeHistoryService = game:GetService("ChangeHistoryService");
local Selection = game:GetService("Selection");

local DialoguePluginScript = script.Parent.Parent;
local React = require(DialoguePluginScript.roblox_packages.react);
local ToolbarButton = require(script.ToolbarButton);
local useStudioColors = require(DialoguePluginScript.useStudioColors);

type ToolbarProps = {
  conversationScript: ModuleScript;
  selectedScript: ModuleScript;
  plugin: Plugin;
}

local function Toolbar(props: ToolbarProps)

  local colors = useStudioColors();
  local selectedScript = props.selectedScript;
  local conversationScript = props.conversationScript;

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
      isDisabled = selectedScript:HasTag("DialogueMaker_Conversation");
      onClick = function()

        Selection:Set({selectedScript.Parent});

      end;
    });
    AddMessageButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14099284898";
      text = "Add message";
      layoutOrder = 2;
      onClick = function()

        if ChangeHistoryService:IsRecordingInProgress() then

          ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);

        end;

        local identifier = ChangeHistoryService:TryBeginRecording("Add message to NPC");

        -- Find a name for the content script.
        local targetPriority = 1;
        for _, instance in selectedScript:GetChildren() do
          
          local comparedName = tonumber(instance.Name);
          if comparedName and comparedName >= targetPriority then
            
            targetPriority = comparedName + 1;
            
          end
          
        end;

        -- Create the content script.
        local newContentScript = DialoguePluginScript.Templates.DialogueTemplate:Clone();
        newContentScript.Name = targetPriority;
        newContentScript:SetAttribute("DialogueType", "Message");
        newContentScript:AddTag("DialogueMaker_Dialogue");
        newContentScript.Parent = selectedScript;

        ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit);

      end;
    });
    AdjustSettingsButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14099277263";
      text = "Adjust settings";
      layoutOrder = 3;
      onClick = function()

        props.plugin:OpenScript(conversationScript);

      end;
    });
  });

end;

return Toolbar;