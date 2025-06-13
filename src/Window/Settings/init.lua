--!strict

local CollectionService = game:GetService("CollectionService");

local packages = script.Parent.Parent.roblox_packages;
local React = require(packages.react);
local loaderSchema = require(script.loaderSchema);
local conversationSchema = require(script.conversationSchema);
local dialogueSchema = require(script.dialogueSchema);
local gameSchema = require(script.gameSchema);

local Setting = require(script.Setting);

export type SettingsProperties = {
  type: "Loader" | "Conversation" | "Dialogue" | "Game";
  conversationScript: ModuleScript?;
  selectedScript: ModuleScript?;
}

function Settings(properties: SettingsProperties)

  local schemas = {
    Loader = loaderSchema;
    Conversation = conversationSchema;
    Dialogue = dialogueSchema;
    Game = gameSchema;
  }

  local schema = schemas[properties.type];
  if not schema then

    error(`Invalid type provided to Settings component: ${properties.type}. Expected one of: "Client", "Conversation", "Dialogue", or "Game".`);

  end;

  local getSettingsFolder = React.useCallback(function(): Instance?

    if properties.type == "Conversation" and properties.conversationScript then 
      
      return properties.conversationScript:FindFirstChild("Settings");
      
    elseif properties.type == "Game" then 
      
      return CollectionService:GetTagged("DialogueMakerGameSettings")[1];
    
    elseif properties.type == "Loader" then

      return CollectionService:GetTagged("DialogueMakerLoaderSettings")[1];

    elseif properties.type == "Dialogue" and properties.selectedScript then

      return properties.selectedScript:FindFirstChild("Settings");

    end;

    return nil;

  end, { properties.type :: unknown, properties.conversationScript, properties.selectedScript });

  local getCurrentSettings = React.useCallback(function(): { [string]: any }

    local settingsFolder = getSettingsFolder();
    if not settingsFolder then

      return {};

    end;

    local currentSettings: { [string]: any } = {};

    for _, categoryFolder in settingsFolder:GetChildren() do

      if categoryFolder:IsA("Configuration") then

        currentSettings[categoryFolder.Name] = currentSettings[categoryFolder.Name] or {};

        for _, settingInstance in categoryFolder:GetChildren() do

          if settingInstance:IsA("BoolValue") or settingInstance:IsA("IntValue") or settingInstance:IsA("ObjectValue") or settingInstance:IsA("NumberValue") then

            currentSettings[categoryFolder.Name][settingInstance.Name] = settingInstance.Value;

          end;

        end;

      end;

    end;

    return currentSettings;

  end, { getSettingsFolder });

  local currentSettings, setCurrentSettings = React.useState(getCurrentSettings());
  React.useEffect(function()
  
    if properties.type == "Game" then

      return;

    end;

    local sourceScript;
    local targetScript;
    if properties.type == "Conversation" then

      assert(properties.conversationScript, "Conversation script must be provided for Conversation type.");

      sourceScript = script.Parent.Parent.Templates.ConversationTemplate;
      targetScript = properties.conversationScript;

    elseif properties.type == "Dialogue" then

      assert(properties.selectedScript, "Selected script must be provided for Dialogue type.");

      sourceScript = script.Parent.Parent.Templates.DialogueTemplate;
      targetScript = properties.selectedScript;

    elseif properties.type == "Loader" then

      sourceScript = script.Parent.Parent.Templates.LoaderTemplate;
      targetScript = CollectionService:GetTagged("DialogueMakerLoader")[1];

      assert(targetScript, "DialogueMakerLoader not found. Please ensure the Loader template is properly set up in the plugin settings.");

    else

      error(`Invalid type provided to Settings component: ${properties.type}. Expected one of: "Loader", "Conversation", or "Dialogue".`);

    end;

    -- Reset the script contents.
    targetScript.Source = sourceScript.Source;

    -- Generate a properties string for the script.
    local propertiesString = "settings = {";

    for category, settings in currentSettings do

      propertiesString = `{propertiesString}\n    {category} = \{`;

      for settingName, rawValue in settings do

        propertiesString = `\n      {settingName} = script.Settings.{category}.{settingName}.Value;`;

      end;

      propertiesString = `\n    {propertiesString}};`;

    end;

    propertiesString = `  };\n`;

    -- Replace the properties string in the script.
    targetScript.Source = targetScript.Source:gsub("-- START REPLACEMENT\n", propertiesString);

    -- Replace packages.
    local dialogueMakerPluginSettings = CollectionService:GetTagged("DialogueMakerPluginSettings")[1];
    assert(dialogueMakerPluginSettings, "DialogueMakerPluginSettings not found.");

    local packagesFolder = dialogueMakerPluginSettings:FindFirstChild("packages");
    assert(packagesFolder, "packages folder not found in DialogueMakerPluginSettings.");

    local locationSettingInstance = packagesFolder:FindFirstChild("location");
    assert(locationSettingInstance and locationSettingInstance:IsA("ObjectValue"), "location setting instance not found in packages folder.");

    targetScript.Source = targetScript.Source:gsub("local packages = *\n", `local packages = {locationSettingInstance.Value:GetFullName()}; -- Automatically replaced by the plugin.\n`);

  end, {properties.type :: unknown, properties.conversationScript, currentSettings});

  local settingComponents = {};
  for category, settings in schema do

    for settingName, settingMetadata in settings do

      local currentValue = if currentSettings[category] then currentSettings[category][settingName] else nil;
      local settingComponent = React.createElement(Setting, {
        key = `{category}.{settingName}`;
        name = settingMetadata.name;
        description = settingMetadata.description;
        layoutOrder = #settingComponents + 1;
        value = currentValue;
        placeholder = settingMetadata.defaultValue;
        type = settingMetadata.type;
        className = settingMetadata.className;
        onChanged = function(newValue)

          -- Create the settings folder if it doesn't exist.
          local settingsFolder = getSettingsFolder();
          if not settingsFolder then
              
            local newSettingsFolder = Instance.new("Configuration");
            newSettingsFolder.Name = "Settings";
            newSettingsFolder.Parent = if properties.type == "Conversation" then properties.conversationScript else properties.selectedScript;
            settingsFolder = newSettingsFolder;

          end;

          assert(settingsFolder, "Settings folder not found even after creating it.");

          -- Create the category folder if it doesn't exist.
          local categoryFolder = settingsFolder:FindFirstChild(category);
          if not categoryFolder then

            local newCategoryFolder = Instance.new("Configuration");
            newCategoryFolder.Name = category;
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

              newSettingInstance = Instance.new("IntValue");

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

          setCurrentSettings(getCurrentSettings());

        end;
      });

      table.insert(settingComponents, settingComponent);

    end;

  end;

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

return Settings;