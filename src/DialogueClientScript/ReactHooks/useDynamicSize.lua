--!strict
local React = require(script.Parent.Parent.Packages.react);

export type DynamicSizeProperties = {
  minimumHeight: number?;
  minimumWidth: number?;
}

local function useDynamicSize(array: {DynamicSizeProperties})

  local function getSizeBasedOnViewport(): number?

    local viewportSize = workspace.CurrentCamera.ViewportSize;
    local selectedIndex;
    for index, properties in array do

      local isAtOrAboveMinimumHeight = not properties.minimumHeight or viewportSize.Y >= properties.minimumHeight;
      local isAtOrAboveMinimumWidth = not properties.minimumWidth or viewportSize.X >= properties.minimumWidth;
      if isAtOrAboveMinimumHeight and isAtOrAboveMinimumWidth then

        selectedIndex = index;

      end;

    end;

    return selectedIndex;

  end;

  
  local selectedIndex, setSelectedIndex = React.useState(getSizeBasedOnViewport());

  React.useEffect(function()

    local function updateSelectedIndex()

      local newSelectedIndex = getSizeBasedOnViewport();
      if newSelectedIndex ~= selectedIndex then

        setSelectedIndex(newSelectedIndex);

      end;

    end;

    local viewportChangedEvent = workspace.CurrentCamera:GetAttributeChangedSignal("ViewportChanged"):Connect(updateSelectedIndex);    

    task.spawn(updateSelectedIndex);

    return function()

      viewportChangedEvent:Disconnect();

    end;

  end, {});

  return selectedIndex;

end

return useDynamicSize;