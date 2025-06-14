--!strict

local root = script.Parent.Parent;
local React = require(root.roblox_packages.react);
local Setting = require(script.Setting);
local settingsMetadata = require(script.settingsMetadata);
local useRefreshDialogueMakerScripts = require(root.DialogueEditor.hooks.useRefreshDialogueMakerScripts);

export type SettingsProperties = {
  settingsTarget: ModuleScript;
}

function Settings(properties: SettingsProperties)

  local settingsTarget = properties.settingsTarget;

  local targetType = React.useMemo(function()
  
    if settingsTarget:HasTag("DialogueMakerLoader") then

      return "loader";

    elseif settingsTarget:HasTag("DialogueMakerConversationScript") then

      return "conversation";

    elseif settingsTarget:HasTag("DialogueMakerDialogueScript") then

      return "dialogue";

    else

      error(`Invalid settings target provided: {settingsTarget.Name}. Expected a DialogueMaker script.`);

    end;

  end, { settingsTarget });

  local metadataCollection = settingsMetadata[targetType];
  
  local settingsContainer = React.useMemo(function()

    return settingsTarget:FindFirstChild("Settings");

  end, { settingsTarget });

  local getCurrentSettings = React.useCallback(function(): { [string]: {[string]: any} }

    if not settingsContainer then

      return {};

    end;

    local currentSettings = {};

    for _, categoryFolder in settingsContainer:GetChildren() do

      if categoryFolder:IsA("Folder") then

        currentSettings[categoryFolder.Name] = currentSettings[categoryFolder.Name] or {};

        for _, settingInstance in categoryFolder:GetChildren() do

          if settingInstance:IsA("BoolValue") or settingInstance:IsA("ObjectValue") or settingInstance:IsA("NumberValue") then

            currentSettings[categoryFolder.Name][settingInstance.Name] = settingInstance.Value;

          end;

        end;

      end;

    end;

    return currentSettings;

  end, { settingsContainer });

  local currentSettings, setCurrentSettings = React.useState(getCurrentSettings());

  local refreshDialogueMakerScripts = useRefreshDialogueMakerScripts();
  React.useEffect(function(): ()
  
    refreshDialogueMakerScripts();

    if settingsContainer then

      local connections = {};
      for _, child in settingsContainer:GetChildren() do

        if child:IsA("Folder") then

          for _, settingInstance in child:GetChildren() do

            if settingInstance:IsA("ValueBase") then

              local connection = settingInstance:GetPropertyChangedSignal("Value"):Connect(function()

                setCurrentSettings(getCurrentSettings());
              
              end);
              
              table.insert(connections, connection);

            end;

          end;

        end;

      end;

      return function()

        for _, connection in connections do

          connection:Disconnect();

        end;

      end;

    end;

  end, {settingsContainer :: unknown, currentSettings});
  
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
            if not settingsContainer then
                
              local newSettingsContainer = Instance.new("Folder");
              newSettingsContainer.Name = "Settings";
              newSettingsContainer.Parent = settingsTarget;
              settingsContainer = newSettingsContainer;

            end;

            assert(settingsContainer, "Settings folder not found even after creating it.");

            -- Create the category folder if it doesn't exist.
            local categoryFolder = settingsContainer:FindFirstChild(categoryName);
            if not categoryFolder then

              local newCategoryFolder = Instance.new("Folder");
              newCategoryFolder.Name = categoryName;
              newCategoryFolder.Parent = settingsContainer;

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

  end, { metadataCollection, currentSettings, settingsTarget });

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