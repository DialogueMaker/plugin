--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Dropdown = require(root.DialogueEditor.components.Dropdown);
local DropdownOption = require(root.DialogueEditor.components.DropdownOption);
local useStudioIcons = require(root.DialogueEditor.hooks.useStudioIcons);
local useDialogueScriptType = require(root.DialogueEditor.hooks.useDialogueScriptType);

type DialogueScriptType = useDialogueScriptType.DialogueScriptType;

export type DialogueTypeDropdownProperties = {
  selectedScript: ModuleScript;
  selectedDialogueType: DialogueScriptType?;
}

local function DialogueTypeDropdown(properties: DialogueTypeDropdownProperties)

  local selectedScript = properties.selectedScript;
  local selectedDialogueType = properties.selectedDialogueType;
  local icons = useStudioIcons();

  local dropdownOptions = {};
  local isDialogueTypeDropdownOpen, setIsDialogueTypeDropdownOpen = React.useState(false);
  if selectedDialogueType ~= "Conversation" then

    local dialogueTypes = {"Message", "Response", "Redirect"};
    for index, dialogueType in dialogueTypes do

      local option = React.createElement(DropdownOption, {
        key = dialogueType;
        text = dialogueType;
        layoutOrder = index;
        iconImage = icons[`{dialogueType:sub(1, 1):upper()}{dialogueType:sub(2)}`];
        onClick = function()

          selectedScript:SetAttribute("DialogueType", dialogueType);
          setIsDialogueTypeDropdownOpen(false);

        end;
      });

      table.insert(dropdownOptions, option);

    end;

  end;

  return React.createElement(Dropdown, {
    iconImage = if selectedDialogueType then icons[`{selectedDialogueType:sub(1, 1):lower()}{selectedDialogueType:sub(2)}`] else icons.conversation;
    text = selectedDialogueType or "Conversation";
    isDisabled = not selectedDialogueType or selectedDialogueType == "Conversation";
    size = UDim2.fromOffset(150, 30);
    layoutOrder = 1;
    isOpen = isDialogueTypeDropdownOpen;
    setIsOpen = setIsDialogueTypeDropdownOpen;
  }, dropdownOptions);

end;

return React.memo(DialogueTypeDropdown);