--!strict

local StarterPlayer = game:GetService("StarterPlayer");
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts;

local DialogueClientScript = StarterPlayerScripts.DialogueClientScript;
local React = require(DialogueClientScript.Packages.react);
local IEffect = require(DialogueClientScript.Interfaces.Effect);

type ExecutionProperties = IEffect.ExecutionProperties;

export type ShakingEffectProperties = {
  intensity: number?;
  frequency: number?;
  rotation: number?;
  text: string;
}

local function ShakingContainer(properties: ShakingEffectProperties & {layoutOrder: number; children: React.ReactNode})

  local textContainerRef = React.useRef(nil :: GuiObject?);
  local contentSize: Vector2?, setContentSize = React.useState(nil :: Vector2?);
  React.useEffect(function(): ()
  
    local textContainer = textContainerRef.current;
    if textContainer then

      local size = textContainer.AbsoluteSize;
      setContentSize(size);

      return function()

        setContentSize(nil);

      end;
      
    end;

  end, {properties.children});

  React.useEffect(function(): ()

    local textContainer = textContainerRef.current;
    if textContainer then

      local shakingTask = task.spawn(function()
        
        local intensity = properties.intensity or 2;
        local frequency = properties.frequency or 0.05;
        local rotation = properties.rotation or 0;
        while task.wait(frequency) do

          local xOffset = math.random(-intensity, intensity);
          local yOffset = math.random(-intensity, intensity);
          textContainer.Position = UDim2.new(0, xOffset, 0, yOffset);
          textContainer.Rotation = math.random(-rotation, rotation);
          
        end
      
      end);

      return function()
        
        task.cancel(shakingTask);
        
      end;
    
    end

  end, {properties.intensity :: unknown, properties.frequency});

  return React.createElement("Frame", {
    AutomaticSize = if contentSize then Enum.AutomaticSize.None else Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
    Size = if contentSize then UDim2.fromOffset(contentSize.X, contentSize.Y) else UDim2.new();
    LayoutOrder = properties.layoutOrder;
  }, {
    TextContainer = React.createElement("Frame", {
      BackgroundTransparency = 1;
      AutomaticSize = if contentSize then Enum.AutomaticSize.None else Enum.AutomaticSize.XY;
      Size = UDim2.fromScale(1, 1);
      ref = textContainerRef; -- Used on a child because the position won't change if the parent is affected by UIListLayout.
    }, {
      Message = React.createElement(React.Fragment, {}, {properties.children});
    });
  });

end;

return ShakingContainer;