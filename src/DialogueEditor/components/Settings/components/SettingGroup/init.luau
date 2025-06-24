--!strict

local root = script.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Setting = require(script.components.Setting);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);
local settingsMetadata = require(script.Parent.Parent.settingsMetadata);

type SettingsMetadataGroup = settingsMetadata.SettingMetadataGroup;

export type SettingsContainerProperties = {
  metadataGroup: SettingsMetadataGroup;
  settingContainer: Instance?;
  currentSettings: { [string]: {[string]: any} };
  settingsTarget: ModuleScript;
  layoutOrder: number;
}

local function SettingGroup(properties: SettingsContainerProperties)

  local metadataGroup = properties.metadataGroup;
  local settingContainer = properties.settingContainer;
  local currentSettings = properties.currentSettings;
  local settingsTarget = properties.settingsTarget;
  local layoutOrder = properties.layoutOrder;
  local colors = useStudioColors();
  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();

  local settingComponents = {};

  for _, settingMetadata in metadataGroup.settings do

    local currentValue = if currentSettings[metadataGroup.name] then currentSettings[metadataGroup.name][settingMetadata.name] else nil;
    local settingComponent = React.createElement(Setting, {
      key = `{metadataGroup.name}.{settingMetadata.name}`;
      settingMetadata = settingMetadata;
      settingsTarget = settingsTarget;
      layoutOrder = #settingComponents + 1;
      value = currentValue;
      onReset = function()
        
        if not settingContainer then

          return;

        end;

        local categoryFolder = settingContainer:FindFirstChild(metadataGroup.name);
        if not categoryFolder then
          
          return;

        end;

        local settingInstance = categoryFolder:FindFirstChild(settingMetadata.name);
        if not settingInstance then

          return;

        end;

        local historyIdentifier = beginHistoryRecording(`Reset setting {metadataGroup.name}.{settingMetadata.name} to default`);

        settingInstance.Parent = nil;

        if #categoryFolder:GetChildren() == 0 then
          
          categoryFolder.Parent = nil;

        end;

        if #settingContainer:GetChildren() == 0 then
          
          settingContainer.Parent = nil;

        end;

        finishHistoryRecording(historyIdentifier);

      end;
      onChanged = function(newValue)

        local historyIdentifier = beginHistoryRecording(`Edit setting {metadataGroup.name}.{settingMetadata.name}`);

        local didChange, errorMessage = pcall(function()

          if settingMetadata.enum and newValue ~= "" then

            local enum = settingMetadata.enum:FromName(newValue);
            if not enum then
              
              error(`{newValue} is not valid for enum {settingMetadata.enum}`, 0);

            end;

          end;

          -- Create the settings folder if it doesn't exist.
          if not settingContainer then
              
            local newSettingsContainer = Instance.new("Folder");
            newSettingsContainer.Name = "Settings";
            newSettingsContainer.Parent = settingsTarget;
            settingContainer = newSettingsContainer;

          end;

          assert(settingContainer, "Settings folder not found even after creating it.");

          -- Create the category folder if it doesn't exist.
          local categoryFolder = settingContainer:FindFirstChild(metadataGroup.name);
          if not categoryFolder then

            local newCategoryFolder = Instance.new("Folder");
            newCategoryFolder.Name = metadataGroup.name;
            newCategoryFolder.Parent = settingContainer;
            categoryFolder = newCategoryFolder;

          end;

          assert(categoryFolder, "Category folder not found even after creating it.");

          -- Create the setting instance if it doesn't exist.
          local settingInstance = categoryFolder:FindFirstChild(settingMetadata.name);
          if not settingInstance then

            local newSettingInstance: Instance;

            if settingMetadata.type == "boolean" then

              newSettingInstance = Instance.new("BoolValue");

            elseif settingMetadata.type == "number" then

              newSettingInstance = Instance.new("NumberValue");

            elseif settingMetadata.type == "string" then

              newSettingInstance = Instance.new("StringValue");

              if settingMetadata.enum then

                newSettingInstance:SetAttribute("Enum", tostring(settingMetadata.enum));

              end;

            elseif settingMetadata.type == "Instance" then

              newSettingInstance = Instance.new("ObjectValue");

            else

              error(`Unsupported setting type: {settingMetadata.type}`);

            end;

            newSettingInstance.Name = settingMetadata.name;
            newSettingInstance.Parent = categoryFolder;
            settingInstance = newSettingInstance;

          end;

          assert(settingInstance, "Setting instance not found even after creating it.");

          -- Update the value of the setting instance.
          if newValue == nil then
            
            settingInstance.Parent = nil;

            if #categoryFolder:GetChildren() == 0 then
              
              categoryFolder.Parent = nil;

            end;

          elseif settingInstance:IsA("BoolValue") then

            assert(typeof(newValue) == "boolean", "Expected newValue to be a boolean.");
            settingInstance.Value = newValue;
            
          elseif settingInstance:IsA("StringValue") then

            assert(typeof(newValue) == "string", "Expected newValue to be a string.");
            settingInstance.Value = newValue;

          elseif settingInstance:IsA("NumberValue") then

            assert(typeof(newValue) == "number", "Expected newValue to be a number.");
            settingInstance.Value = newValue;

          elseif settingInstance:IsA("ObjectValue") then

            assert(typeof(newValue) == "Instance" or newValue == nil, "Expected newValue to be an Instance or nil.");
            settingInstance.Value = newValue;

          end;

          finishHistoryRecording(historyIdentifier);

        end);

        if not didChange then

          finishHistoryRecording(historyIdentifier, Enum.FinishRecordingOperation.Cancel);
          error(`Failed to change setting {metadataGroup.name}.{settingMetadata.name}: {errorMessage}`, 0);

        end;

      end;
    });

    table.insert(settingComponents, settingComponent);

  end;

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.Y;
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
    Size = UDim2.fromScale(1, 0);
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 10);
    });
    Header = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = `{metadataGroup.name:sub(1, 1):upper()}{metadataGroup.name:sub(2)} settings`;
      TextSize = 14;
      FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Bold);
      LayoutOrder = 1;
      BackgroundTransparency = 1;
      TextXAlignment = Enum.TextXAlignment.Left;
      TextWrapped = true;
      TextColor3 = colors.text;
    });
    Settings = React.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.Y;
      BackgroundTransparency = 1;
      LayoutOrder = 2;
      Size = UDim2.fromScale(1, 0);
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 10);
      });
      Content = React.createElement(React.Fragment, {}, settingComponents);
    });
  });

end;

return React.memo(SettingGroup);