--!strict

local CollectionService = game:GetService("CollectionService");

local React = require(script.Parent.Parent.Parent.roblox_packages.react);

export type UseUpdatedSettingsProperties = {
  targetType: "Loader" | "Conversation" | "Dialogue" | "Game";
  conversationScript: ModuleScript?;
  selectedScript: ModuleScript?;
};

local function useSettings(targetType: "Loader" | "Conversation" | "Dialogue" | "Game" | nil, conversationScript: ModuleScript?, selectedScript: ModuleScript?)

  local findSettingsFolder = React.useCallback(function(): Instance?

    if targetType == "Conversation" and conversationScript then 
      
      return conversationScript:FindFirstChild("Settings");
      
    elseif targetType == "Game" then 
      
      return CollectionService:GetTagged("DialogueMakerGameSettings")[1];
    
    elseif targetType == "Loader" then

      return CollectionService:GetTagged("DialogueMakerLoaderSettings")[1];

    elseif targetType == "Dialogue" and selectedScript then

      return selectedScript:FindFirstChild("Settings");

    end;

    return nil;

  end, { targetType :: unknown, conversationScript, selectedScript });

  local getCurrentSettings = React.useCallback(function(): { [string]: {[string]: any} }

    local settingsFolder = findSettingsFolder();
    if not settingsFolder then

      return {};

    end;

    local currentSettings = {};

    for _, categoryFolder in settingsFolder:GetChildren() do

      if categoryFolder:IsA("Configuration") then

        currentSettings[categoryFolder.Name] = currentSettings[categoryFolder.Name] or {};

        for _, settingInstance in categoryFolder:GetChildren() do

          if settingInstance:IsA("BoolValue") or settingInstance:IsA("ObjectValue") or settingInstance:IsA("NumberValue") then

            currentSettings[categoryFolder.Name][settingInstance.Name] = settingInstance.Value;

          end;

        end;

      end;

    end;

    return currentSettings;

  end, { findSettingsFolder });

  local currentSettings, setCurrentSettings = React.useState(getCurrentSettings());

  React.useEffect(function()
  
  end, { findSettingsFolder :: unknown, getCurrentSettings });

  return currentSettings, findSettingsFolder;

end;

return useSettings;