--!strict
local React = require(script.Parent.Parent.Packages.react);

export type DynamicSizeProperties = {
  minimumHeight: number?;
  minimumWidth: number?;
  sizeX: number;
  sizeY: number;
  textSize: number;
}

local function useDynamicSize(array: {DynamicSizeProperties})

  local function getSizeBasedOnViewport(): (number, number, number)

    local viewportSize = workspace.CurrentCamera.ViewportSize;
    local selectedProperties;
    for _, properties in array do

      local isDefault = not properties.minimumHeight and not properties.minimumWidth;
      local isAtOrAboveMinimumHeight = not properties.minimumHeight or viewportSize.Y >= properties.minimumHeight;
      local isAtOrAboveMinimumWidth = not properties.minimumWidth or viewportSize.X >= properties.minimumWidth;
      if isDefault or (isAtOrAboveMinimumHeight and isAtOrAboveMinimumWidth) then

        selectedProperties = properties;

      end;

    end;

    assert(selectedProperties, "No sizes available for current viewport.");

    return selectedProperties.sizeX, selectedProperties.sizeY, selectedProperties.textSize;

  end;

  local defaultX, defaultY, defaultTextSize = getSizeBasedOnViewport();
  local sizeX, setSizeX = React.useState(defaultX);
  local sizeY, setSizeY = React.useState(defaultY);
  local textSize, setTextSize = React.useState(defaultTextSize);

  React.useEffect(function()

    local function updateSize()

      local newX, newY, newTextSize = getSizeBasedOnViewport();

      setSizeX(newX);
      setSizeY(newY);
      setTextSize(newTextSize);

    end;

    local viewportChangedEvent = workspace.CurrentCamera:GetAttributeChangedSignal("ViewportChanged"):Connect(updateSize);    

    return function()

      viewportChangedEvent:Disconnect();

    end;

  end, {});

  return sizeX, sizeY, textSize;

end

return useDynamicSize;