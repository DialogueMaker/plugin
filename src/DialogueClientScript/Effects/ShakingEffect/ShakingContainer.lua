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

local function ShakingContainer(properties: ShakingEffectProperties & {executionProperties: ExecutionProperties})

  local textContainerRef = React.useRef(nil);
  React.useEffect(function(): ()
  
    if properties.executionProperties.shouldSkip then
      properties.executionProperties.continuePage();
      return;
    end;

    local textContainer = textContainerRef.current;
    if textContainer then
      
      local shakingTask = task.spawn(function()
        
        while task.wait(properties.frequency) do

          local xOffset = math.random(-properties.intensity, properties.intensity);
          local yOffset = math.random(-properties.intensity, properties.intensity);
          textContainer.Position = UDim2.new(0, xOffset, 0, yOffset);
          
        end
      
      end);

      local skipPageSignal = if properties.executionProperties.skipPageEvent then

        properties.executionProperties.skipPageEvent.Event:Once(function()
          
          properties.executionProperties.continuePage();
          
        end)

      else nil;

      return function()
        
        if skipPageSignal then
          
          skipPageSignal:Disconnect();
          
        end;
        
        task.cancel(shakingTask);
        
      end;
    
    end

  end, {properties.intensity :: unknown, properties.frequency, properties.executionProperties});

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    Size = UDim2.new();
  }, {
    TextContainer = React.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
      Size = UDim2.new();
      ref = textContainerRef; -- Used on a child because the position won't change if the parent is affected by UIListLayout.
    }, {

    });
  });

end;

return ShakingContainer;