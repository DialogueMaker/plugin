--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local SettingGroup = require(script.components.SettingGroup);
local settingsMetadata = require(script.settingsMetadata);
local SettingsTabSelector = require(script.components.SettingsTabSelector);
local useRefreshDialogueMakerScripts = require(root.DialogueEditor.hooks.useRefreshDialogueMakerScripts);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type SettingsProperties = {
  initialSettingsTarget: ModuleScript;
  layoutOrder: number;
}

function Settings(properties: SettingsProperties)

  local settingsTarget, setSettingsTarget = React.useState(properties.initialSettingsTarget);
  local layoutOrder = properties.layoutOrder;

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

  local settingGroups = {};

  for groupName, categoryContent in metadataCollection do

    local settingGroup = React.createElement(SettingGroup, {
      name = groupName;
      items = categoryContent;
      settingContainer = settingsContainer;
      currentSettings = currentSettings;
      settingsTarget = settingsTarget;
      key = groupName;
      layoutOrder = #settingGroups + 1;
    });

    table.insert(settingGroups, settingGroup);

  end;

  local colors = useStudioColors();

  return React.createElement("ScrollingFrame", {
    Size = UDim2.fromScale(1, 1);
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
    AutomaticCanvasSize = Enum.AutomaticSize.Y;
    CanvasSize = UDim2.fromScale(1, 0);
    ScrollingDirection = Enum.ScrollingDirection.Y;
    BorderSizePixel = 0;
    ScrollBarImageColor3 = colors.border;
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
      PaddingTop = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
    });
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 10);
    });
    UIFlexItem = React.createElement("UIFlexItem", {
      FlexMode = Enum.UIFlexMode.Shrink;
    });
    SettingsTabSelector = React.createElement(SettingsTabSelector, {
      settingsTarget = settingsTarget;
      initialSettingsTarget = properties.initialSettingsTarget;
      onSelectionChanged = function(newTarget: ModuleScript)

        setSettingsTarget(newTarget);

      end;
    });
    Settings = React.createElement(React.Fragment, {}, settingGroups);
  });

end;

return React.memo(Settings);