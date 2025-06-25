--!strict

local RunService = game:GetService("RunService");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Icons = require(root.Icons);

local function useStudioIcons()

  local getIcons = React.useCallback(function()

    if not RunService:IsStudio() then

      return Icons.Dark;

    end

    local themeName = settings().Studio.Theme.Name
    return Icons[themeName] or Icons.Dark

  end, {});

  local icons, setIcons = React.useState(getIcons())

  React.useEffect(function(): ()
    
    if not RunService:IsStudio() then

      return;

    end

    local function onThemeChanged()

      setIcons(getIcons());

    end

    local themeChangedConnection = settings().Studio.ThemeChanged:Connect(onThemeChanged)

    return function()

      themeChangedConnection:Disconnect()

    end
    
  end, {getIcons})

  return icons;

end

return useStudioIcons;