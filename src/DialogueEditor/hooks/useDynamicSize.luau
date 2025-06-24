--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);

local function useDynamicSize(gui: GuiBase2d, minimumWidth: number?, minimumHeight: number?): boolean

  local checkCondition = React.useCallback(function()

    local isAtOrAboveMinimumHeight = minimumHeight == nil or gui.AbsoluteSize.Y >= minimumHeight;
    local isAtOrAboveMinimumWidth = minimumWidth == nil or gui.AbsoluteSize.X >= minimumWidth;

    return isAtOrAboveMinimumHeight and isAtOrAboveMinimumWidth;

  end);

  local isConditionMet, setIsConditionMet = React.useState(checkCondition());

  React.useEffect(function()

    local function updateStatus()

      setIsConditionMet(checkCondition());

    end;

    local viewportChangedEvent = gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateStatus);    

    task.spawn(updateStatus);

    return function()

      viewportChangedEvent:Disconnect();

    end;

  end, {gui :: unknown, checkCondition});

  return isConditionMet;

end

return useDynamicSize;