--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Icons = require(root.Icons);

local function useStudioIcons()

  local themeName, setThemeName = React.useState(settings().Studio.Theme.Name)

  React.useEffect(function()
    
    local function onThemeChanged()

      setThemeName(settings().Studio.Theme.Name);

    end

    local themeChangedConnection = settings().Studio.ThemeChanged:Connect(onThemeChanged)

    return function()

      themeChangedConnection:Disconnect()

    end
    
  end, {})

  return Icons[themeName] or Icons.Dark;

end

return useStudioIcons;