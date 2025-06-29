--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Checkbox = require(root.DialogueEditor.components.Checkbox);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);
local useDialogueContentScript = require(script.Parent.Parent.hooks.useDialogueContentScript);

export type DynamicContentCheckboxProperties = {
  selectedScript: ModuleScript;
  layoutOrder: number;
}

local function DynamicContentCheckbox(properties: DynamicContentCheckboxProperties)

  local selectedScript = properties.selectedScript;
  local dialogueContentScript, isDialogueContentScriptEnabled = useDialogueContentScript(selectedScript);
  local layoutOrder = properties.layoutOrder;
  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();

  return React.createElement(Checkbox, {
    text = "Dynamic content";
    isChecked = isDialogueContentScriptEnabled;
    layoutOrder = layoutOrder;
    onChanged = function(isChecked: boolean)

      local historyIdentifier = beginHistoryRecording(`{if isChecked then "Disable" else "Enable"} dialogue dynamic content`);

      if not dialogueContentScript then

        local newDialogueContentScript = root.Templates.DialogueContentScriptTemplate:Clone();
        newDialogueContentScript.Name = "ContentScript";
        newDialogueContentScript.Parent = selectedScript;
        dialogueContentScript = newDialogueContentScript;

      end;

      assert(dialogueContentScript and dialogueContentScript:IsA("ModuleScript"), `Dialogue content script not found for {selectedScript:GetFullName()}.`);

      dialogueContentScript:SetAttribute("IsDisabled", not isChecked);

      finishHistoryRecording(historyIdentifier);

    end;
  });

end;

return React.memo(DynamicContentCheckbox);