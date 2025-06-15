--!strict

local CollectionService = game:GetService("CollectionService");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local TabSelector = require(root.DialogueEditor.components.TabSelector);
local TabSelectorButton = require(root.DialogueEditor.components.TabSelector.TabSelectorButton);

export type SettingTypeSelectorProperties = {
  settingsTarget: ModuleScript;
};

local function SettingsTabSelector(properties: SettingTypeSelectorProperties)

  local settingsTarget = properties.settingsTarget;

  local settingsTargetType = (
    if settingsTarget:HasTag("DialogueMakerLoader") then "Client"
    elseif settingsTarget:HasTag("DialogueMakerConversationScript") then "Conversation"
    elseif settingsTarget:HasTag("DialogueMakerDialogueScript") then "Dialogue"
    else error(`Invalid settings target provided: {settingsTarget.Name}. Expected a DialogueMaker script.`)
  );

  local loaderScripts = CollectionService:GetTagged("DialogueMakerLoader");
  local loaderScript = nil;
  for _, possibleLoaderScript in loaderScripts do
    
    if not possibleLoaderScript:IsDescendantOf(root) then
      
      loaderScript = possibleLoaderScript;
      break;
    
    end

  end

  local buttons = {};
  local settingTypes = {"Client", "Conversation", "Dialogue"};

  for index, settingType in settingTypes do

    local settingTypeComponent = React.createElement(TabSelectorButton, {
      isSelected = settingType == settingsTargetType;
      text = settingType;
      layoutOrder = index;
      isDisabled = settingType == "Client" and not loaderScript;
      onSelected = function()

      end;
    });

    table.insert(buttons, settingTypeComponent);

  end;

  return React.createElement(TabSelector, {}, buttons);

end;

return React.memo(SettingsTabSelector);