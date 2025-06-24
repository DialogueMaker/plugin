--!strict

local CollectionService = game:GetService("CollectionService");

local root = script.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local TabSelector = require(root.DialogueEditor.components.TabSelector);
local TabSelectorButton = require(root.DialogueEditor.components.TabSelector.TabSelectorButton);

export type SettingTypeSelectorProperties = {
  settingsTarget: ModuleScript;
  initialSettingsTarget: ModuleScript;
  onSelectionChanged: (settingsTarget: ModuleScript) -> ();
};

local function SettingsTabSelector(properties: SettingTypeSelectorProperties)

  local initialSettingsTarget = properties.initialSettingsTarget;
  local settingsTarget = properties.settingsTarget;
  local onSelectionChanged = properties.onSelectionChanged;

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
      isDisabled = (settingType == "Client" and not loaderScript) or (settingType == "Dialogue" and not initialSettingsTarget:HasTag("DialogueMakerDialogueScript"));
      onSelected = function()

        if settingType == "Client" then

          onSelectionChanged(loaderScript);

        elseif settingType == "Conversation" then

          local possibleConversationScript = initialSettingsTarget;
          
          while not possibleConversationScript:HasTag("DialogueMakerConversationScript") and possibleConversationScript.Parent and possibleConversationScript.Parent:IsA("Folder") and possibleConversationScript.Parent.Parent and possibleConversationScript.Parent.Parent:IsA("ModuleScript") do
            
            possibleConversationScript = possibleConversationScript.Parent.Parent;

          end;

          if not possibleConversationScript:HasTag("DialogueMakerConversationScript") then

            error(`No valid conversation script found for {initialSettingsTarget.Name}.`);

          end

          onSelectionChanged(possibleConversationScript);

        elseif settingType == "Dialogue" then

          onSelectionChanged(initialSettingsTarget);

        end;

      end;
    });

    table.insert(buttons, settingTypeComponent);

  end;

  return React.createElement(TabSelector, {}, buttons);

end;

return React.memo(SettingsTabSelector);