--!strict

local root = script.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Setting = require(script.components.Setting);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);

export type SettingsContainerProperties = {
  name: string;
  items: any;
  settingContainer: Instance?;
  currentSettings: { [string]: {[string]: any} };
  settingsTarget: ModuleScript;
  layoutOrder: number;
}

local function SettingGroup(properties: SettingsContainerProperties)

  local groupName = properties.name;
  local items = properties.items;
  local settingContainer = properties.settingContainer;
  local currentSettings = properties.currentSettings;
  local settingsTarget = properties.settingsTarget;
  local layoutOrder = properties.layoutOrder;
  local colors = useStudioColors();
  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();

  local settingComponents = {};

  for settingName, settingMetadata in items do

    local currentValue = if currentSettings[groupName] then currentSettings[groupName][settingName] else nil;
    local settingComponent = React.createElement(Setting, {
      key = `{groupName}.{settingName}`;
      name = settingMetadata.name;
      description = settingMetadata.description;
      layoutOrder = #settingComponents + 1;
      value = currentValue;
      placeholder = settingMetadata.defaultValue;
      type = settingMetadata.type;
      className = settingMetadata.className;
      onReset = function()
        
        if not settingContainer then

          return;

        end;

        local categoryFolder = settingContainer:FindFirstChild(groupName);
        if not categoryFolder then
          
          return;

        end;

        local settingInstance = categoryFolder:FindFirstChild(settingName);
        if not settingInstance then

          return;

        end;

        local historyIdentifier = beginHistoryRecording(`Reset setting {groupName}.{settingName} to default`);

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

        local historyIdentifier = beginHistoryRecording(`Edit setting {groupName}.{settingName}`);

        local didChange, errorMessage = pcall(function()

          -- Create the settings folder if it doesn't exist.
          if not settingContainer then
              
            local newSettingsContainer = Instance.new("Folder");
            newSettingsContainer.Name = "Settings";
            newSettingsContainer.Parent = settingsTarget;
            settingContainer = newSettingsContainer;

          end;

          assert(settingContainer, "Settings folder not found even after creating it.");

          -- Create the category folder if it doesn't exist.
          local categoryFolder = settingContainer:FindFirstChild(groupName);
          if not categoryFolder then

            local newCategoryFolder = Instance.new("Folder");
            newCategoryFolder.Name = groupName;
            newCategoryFolder.Parent = settingContainer;
            categoryFolder = newCategoryFolder;

          end;

          assert(categoryFolder, "Category folder not found even after creating it.");

          -- Create the setting instance if it doesn't exist.
          local settingInstance = categoryFolder:FindFirstChild(settingName);
          if not settingInstance then

            local newSettingInstance: Instance;

            if settingMetadata.type == "boolean" then

              newSettingInstance = Instance.new("BoolValue");

            elseif settingMetadata.type == "number" then

              newSettingInstance = Instance.new("NumberValue");

            elseif settingMetadata.type == "string" then

              newSettingInstance = Instance.new("StringValue");

            elseif settingMetadata.className then

              newSettingInstance = Instance.new("ObjectValue");

            else

              error(`Unsupported setting type: {settingMetadata.type}`);

            end;

            newSettingInstance.Name = settingName;
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
          error(`Failed to change setting {groupName}.{settingName}: {errorMessage}`);

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
      Text = `{groupName:sub(1, 1):upper()}{groupName:sub(2)} settings`;
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