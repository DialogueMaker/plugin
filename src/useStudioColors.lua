--!strict

local React = require(script.Parent.roblox_packages.react);
local Colors = require(script.Parent.Colors);
type ColorDictionary = Colors.ColorDictionary;

local function useStudioColors(): ColorDictionary

  local themeName, setThemeName = React.useState(settings().Studio.Theme.Name)

  React.useEffect(function()
    local function onThemeChanged()
      setThemeName(settings().Studio.Theme.Name)
    end

    local themeChangedConnection = settings().Studio.ThemeChanged:Connect(onThemeChanged)

    return function()
      themeChangedConnection:Disconnect()
    end
  end, {})

  return Colors[themeName] or Colors.Dark;

end

return useStudioColors;