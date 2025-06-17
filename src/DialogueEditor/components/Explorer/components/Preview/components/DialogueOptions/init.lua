--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Button = require(root.DialogueEditor.components.Button);
local Dropdown = require(root.DialogueEditor.components.Dropdown);
local DropdownOption = require(root.DialogueEditor.components.DropdownOption);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useDialogueScriptType = require(root.DialogueEditor.hooks.useDialogueScriptType);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);

type DialogueScriptType = useDialogueScriptType.DialogueScriptType;

export type DialogueOptionsProperties = {
  selectedScript: ModuleScript;
  selectedDialogueType: DialogueScriptType;
  layoutOrder: number;
  plugin: Plugin;
}

local function DialogueOptions(properties: DialogueOptionsProperties)

  local selectedScript = properties.selectedScript;
  local selectedDialogueType = properties.selectedDialogueType;
  local layoutOrder = properties.layoutOrder;
  local plugin = properties.plugin;
  local colors = useStudioColors();
  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();

  local dialogueOptions: {React.ReactNode} = {};
  local isActionsDropdownOpen, setIsActionsDropdownOpen = React.useState(false);
  if selectedDialogueType ~= "Conversation" then

    local conditionButton = React.createElement(Button, {
      key = "ConditionButton";
      text = "Edit condition";
      layoutOrder = #dialogueOptions + 1;
      onClick = function()

        local conditionScript = selectedScript:FindFirstChild("ConditionScript");
        if not conditionScript then

          local historyIdentifier = beginHistoryRecording("Add condition script");

          local newConditionScript = root.Templates.DialogueConditionScriptTemplate:Clone();
          newConditionScript.Name = "ConditionScript";
          newConditionScript.Parent = selectedScript;
          conditionScript = newConditionScript;

          finishHistoryRecording(historyIdentifier);

        end;

        assert(conditionScript and conditionScript:IsA("ModuleScript"), `Condition script not found for {selectedScript:GetFullName()}.`);

        plugin:OpenScript(conditionScript);

      end;
    });

    table.insert(dialogueOptions, conditionButton);

    local actionsDropdownOptions = {};
    local actionTypes = {"Initialization", "Completion", "Cleanup"};
    for index, actionType in actionTypes do

      -- Redirects only have initialization actions.
      if selectedDialogueType == "Redirect" and actionType ~= "Initialization" then

        continue; 
      
      end;

      local option = React.createElement(DropdownOption, {
        key = actionType :: string;
        text = actionType :: string;
        layoutOrder = index;
        onClick = function()

          -- Make sure the script is there.
          local actionScript = selectedScript:FindFirstChild(`{actionType}ActionScript`);
          if not actionScript then

            local newActionScript = root.Templates:FindFirstChild(`Dialogue{actionType}ActionScriptTemplate`):Clone();
            newActionScript.Name = `{actionType}ActionScript`;
            newActionScript.Parent = selectedScript;
            actionScript = newActionScript;

          end;

          assert(actionScript and actionScript:IsA("ModuleScript"), `{actionType} action script not found for {selectedScript:GetFullName()}.`);

          plugin:OpenScript(actionScript);

        end;
      });

      table.insert(actionsDropdownOptions, option);

    end;

    local actionsDropdown = React.createElement(Dropdown, {
      layoutOrder = #dialogueOptions + 1;
      key = "ActionsDropdown";
      text = "Edit actions";
      size = UDim2.fromOffset(125, 30);
      isOpen = isActionsDropdownOpen;
      setIsOpen = setIsActionsDropdownOpen;
    }, actionsDropdownOptions);

    table.insert(dialogueOptions, actionsDropdown);

  end;

  local deleteButton = React.createElement(Button, {
    key = "DeleteButton";
    text = "Delete";
    backgroundColor = colors.backgroundWarning;
    layoutOrder = #dialogueOptions + 1;
    onClick = function()

      local historyIdentifier = beginHistoryRecording(`Delete {selectedDialogueType:lower()} script`);

      Selection:Set({selectedScript.Parent});
      selectedScript.Parent = nil;

      finishHistoryRecording(historyIdentifier);

    end;
  });

  table.insert(dialogueOptions, deleteButton);

  return React.createElement("Frame", {
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
    Size = UDim2.fromScale(1, 0);
    AutomaticSize = Enum.AutomaticSize.Y;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
      Padding = UDim.new(0, 10);
      Wraps = true;
    });
    DialogueOptions = React.createElement(React.Fragment, {}, dialogueOptions);
  });

end;

return React.memo(DialogueOptions);