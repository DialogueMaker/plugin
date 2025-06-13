--!strict

local root = script.Parent.Parent;
local React = require(root.roblox_packages.react);
local settingsMetadata = require(script.settingsMetadata);
local useRefreshDialogueMakerScripts = require(root.DialogueEditor.hooks.useRefreshDialogueMakerScripts);
local useSettings = require(root.DialogueEditor.hooks.useSettings);

local Setting = require(script.Setting);

export type Settings = {
  [string]: {
    [string]: {
      name: string;
      description: string;
      type: ("boolean" | "number" | "string")?;
      defaultValue: any;
      className: string?; -- Optional, used for ObjectValue settings
    };
  }
}

export type SettingsProperties = {
  type: "Loader" | "Conversation" | "Dialogue" | "Game";
  conversationScript: ModuleScript?;
  selectedScript: ModuleScript?;
}

function Settings(properties: SettingsProperties)

  local metadataCollection = settingsMetadata[properties.type:lower()];
  if not metadataCollection then

    error(`Invalid type provided to Settings component: ${properties.type}. Expected one of: "Client", "Conversation", "Dialogue", or "Game".`);

  end;

  local currentSettings, findSettingsFolder = useSettings();
  local refreshDialogueMakerScripts = useRefreshDialogueMakerScripts();
  React.useEffect(function()
  
    refreshDialogueMakerScripts();

  end, {currentSettings});
  
  local settingComponents = React.useMemo(function()

    local settingComponents: {React.ReactNode} = {};

    for categoryName, categoryContent in metadataCollection do

      for settingName, settingMetadata in categoryContent do

        local currentValue = if currentSettings[categoryName] then currentSettings[categoryName][settingName] else nil;
        local settingComponent = React.createElement(Setting, {
          key = `{categoryName}.{settingName}`;
          name = settingMetadata.name;
          description = settingMetadata.description;
          layoutOrder = #settingComponents + 1;
          value = currentValue;
          placeholder = settingMetadata.defaultValue;
          type = settingMetadata.type;
          className = settingMetadata.className;
          onChanged = function(newValue)

            -- Create the settings folder if it doesn't exist.
            local settingsFolder = findSettingsFolder();
            if not settingsFolder then
                
              local newSettingsFolder = Instance.new("Folder");
              newSettingsFolder.Name = "Settings";
              newSettingsFolder.Parent = if properties.type == "Conversation" then properties.conversationScript else properties.selectedScript;
              settingsFolder = newSettingsFolder;

            end;

            assert(settingsFolder, "Settings folder not found even after creating it.");

            -- Create the category folder if it doesn't exist.
            local categoryFolder = settingsFolder:FindFirstChild(categoryName);
            if not categoryFolder then

              local newCategoryFolder = Instance.new("Folder");
              newCategoryFolder.Name = categoryName;
              newCategoryFolder.Parent = settingsFolder;

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
              
              settingInstance:Destroy();

              if #categoryFolder:GetChildren() == 0 then
                
                categoryFolder:Destroy();

              end;

            elseif settingInstance:IsA("BoolValue") then

              assert(typeof(newValue) == "boolean", "Expected newValue to be a boolean.");
              settingInstance.Value = newValue;
              
            elseif settingInstance:IsA("IntValue") then

              assert(typeof(newValue) == "number", "Expected newValue to be a number.");
              assert(math.floor(newValue) == newValue, "Expected newValue to be an integer.");
              settingInstance.Value = newValue;

            elseif settingInstance:IsA("NumberValue") then

              assert(typeof(newValue) == "number", "Expected newValue to be a number.");
              settingInstance.Value = newValue;

            elseif settingInstance:IsA("ObjectValue") then

              assert(typeof(newValue) == "Instance" or newValue == nil, "Expected newValue to be an Instance or nil.");
              settingInstance.Value = newValue;

            end;

          end;
        });

        table.insert(settingComponents, settingComponent);

      end;

    end;

    return settingComponents;

  end, { metadataCollection, currentSettings, findSettingsFolder });

  return React.createElement("ScrollingFrame", {

  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 10);
    });
    Heading = React.createElement("TextLabel", {
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = "Settings";
      TextSize = 24;
      Font = Enum.Font.SourceSansBold;
      BackgroundTransparency = 1;
      LayoutOrder = 1;
    });
    Content = React.createElement("Frame", {
      BackgroundTransparency = 1;
      AutomaticSize = Enum.AutomaticSize.Y;
      Size = UDim2.fromScale(1, 0);
      LayoutOrder = 2;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 10);
      });
      Settings = React.createElement(React.Fragment, {}, settingComponents);
    });
  });

end;

return React.memo(Settings);