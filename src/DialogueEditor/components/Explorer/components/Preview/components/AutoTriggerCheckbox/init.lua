--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Checkbox = require(root.DialogueEditor.components.Checkbox);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);

export type AutoTriggerCheckboxProperties = {
  layoutOrder: number;
  selectedScript: ModuleScript;
}

local function AutoTriggerCheckbox(properties: AutoTriggerCheckboxProperties)

  local selectedScript = properties.selectedScript;
  local layoutOrder = properties.layoutOrder;
  local shouldAutoTriggerConversation, setShouldAutoTriggerConversation = React.useState(selectedScript:GetAttribute("ShouldAutoTriggerConversation"));
  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();

  React.useEffect(function()

    local autoTriggerConnection = selectedScript:GetAttributeChangedSignal("ShouldAutoTriggerConversation"):Connect(function()

      setShouldAutoTriggerConversation(selectedScript:GetAttribute("ShouldAutoTriggerConversation"));

    end);

    return function()

      autoTriggerConnection:Disconnect();

    end;

  end, {selectedScript});

  return React.createElement(Checkbox, {
    text = "Auto-trigger";
    isChecked = shouldAutoTriggerConversation;
    layoutOrder = layoutOrder;
    onChanged = function(isChecked: boolean)

      local historyIdentifier = beginHistoryRecording("Set auto-trigger conversation");

      selectedScript:SetAttribute("ShouldAutoTriggerConversation", isChecked);

      finishHistoryRecording(historyIdentifier);

    end;
  });

end;

return React.memo(AutoTriggerCheckbox);