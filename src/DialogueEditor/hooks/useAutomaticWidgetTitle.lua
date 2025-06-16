--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);

local function useAutomaticWidgetTitle(pluginGUI: DockWidgetPluginGui, conversationScript: ModuleScript?)

  React.useEffect(function(): ()
  
    if conversationScript then

      local function updateTitle()

        pluginGUI.Title = `Dialogue Maker • {conversationScript.Name}`;

      end;

      local updateTitleConnection = conversationScript:GetPropertyChangedSignal("Name"):Connect(updateTitle);
      updateTitle();

      return function()

        updateTitleConnection:Disconnect();

      end;

    else

      pluginGUI.Title = "Dialogue Maker";

    end;

  end, {conversationScript});

end

return useAutomaticWidgetTitle;