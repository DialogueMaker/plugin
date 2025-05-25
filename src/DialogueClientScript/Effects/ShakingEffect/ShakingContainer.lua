--!strict

local DialogueClientScript = script.Parent.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local IEffect = require(DialogueClientScript.Interfaces.Effect);

type ExecutionProperties = IEffect.ExecutionProperties;

export type ShakingEffectProperties = {
  intensity: number;
  frequency: number;
  text: string;
}

local function ShakingContainer(properties: ShakingEffectProperties & {children: React.ReactNode})

  local textContainerRef = properties.react.useRef(nil);
  properties.react.useEffect(function(): ()

    local textContainer = textContainerRef.current;
    if textContainer then
      
      local shakingTask = task.spawn(function()
        
        while task.wait(properties.frequency) do

          local xOffset = math.random(-properties.intensity, properties.intensity);
          local yOffset = math.random(-properties.intensity, properties.intensity);
          textContainer.Position = UDim2.new(0, xOffset, 0, yOffset);
          
        end
      
      end);

      return function()
        
        task.cancel(shakingTask);
        
      end;
    
    end

  end, {properties.intensity :: unknown, properties.frequency});

  return properties.react.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    Size = UDim2.new();
  }, {
    TextContainer = properties.react.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      Size = UDim2.new();
      ref = textContainerRef; -- Used on a child because the position won't change if the parent is affected by UIListLayout.
    }, {
      Message = properties.react.createElement(properties.react.Fragment, {}, {properties.children});
    });
  });

end;

return ShakingContainer;