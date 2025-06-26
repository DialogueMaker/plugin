--!strict

local RunService = game:GetService("RunService");

local React = require(script.Parent.Parent.Parent.roblox_packages.react);
local Colors = require(script.Parent.Parent.Parent.Colors);
type ColorDictionary = Colors.ColorDictionary;

local function useStudioColors(): ColorDictionary

  local getColors = React.useCallback(function()

    if not RunService:IsStudio() then

      return Colors.Dark;

    end

    local themeName = settings().Studio.Theme.Name
    return Colors[themeName] or Colors.Dark

  end, {});

  local colors, setColors = React.useState(getColors())

  React.useEffect(function(): ()
    
    if not RunService:IsStudio() then

      return;

    end

    local function onThemeChanged()

      setColors(getColors());

    end

    local themeChangedConnection = settings().Studio.ThemeChanged:Connect(onThemeChanged)

    return function()

      themeChangedConnection:Disconnect()

    end
    
  end, {getColors})

  return colors;

end

return useStudioColors;