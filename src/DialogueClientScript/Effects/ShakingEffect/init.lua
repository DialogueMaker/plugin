--!strict
-- This effect pauses a message for a certain amount of time.
-- This is helpful for when you want to draw emphasis to some text.
-- 
-- Programmer: Christian Toney
-- © 2025 Dialogue Maker Group

local DialogueClientScript = script.Parent.Parent;
local DialogueContentFitter = require(DialogueClientScript.Classes.DialogueContentFitter);
local Effect = require(DialogueClientScript.Classes.Effect);
local IEffect = require(DialogueClientScript.Interfaces.Effect);
local ShakingContainer = require(script.ShakingContainer);

type Bounds = IEffect.Bounds;
type ContinuePageFunction = IEffect.ContinuePageFunction;
type Effect = IEffect.Effect;
type ExecutionProperties = IEffect.ExecutionProperties;
type Page = IEffect.Page;
type ShakingEffectProperties = ShakingContainer.ShakingEffectProperties;

local ShakingEffect = {};

function ShakingEffect.new(properties: ShakingEffectProperties): Effect
  
  local function fit(self: Effect, contentContainer: GuiObject, textLabel: TextLabel, pages: {Page}): (GuiObject, {Page}) 
    
    -- Since this effect is just animating simple text, we can fit the effect by 
    -- simulating the amount of space that the text would take up in the container by itself.

    -- In the future, this effect may support other content such as images or buttons.
    -- But for now, this is enough.
    local simulatedContentContainer, simulatedPages = DialogueContentFitter:fitText(properties.text, contentContainer, textLabel, pages);

    -- Replace the inserted strings with effects.
    for currentPageIndex = #pages, #simulatedPages do

      local initialComponentIndex = if currentPageIndex == #pages then #pages[#pages] + 1 else 1;
      local currentPage = simulatedPages[currentPageIndex];
      
      for currentComponentIndex = initialComponentIndex, #currentPage do

        local text = currentPage[currentComponentIndex];
        assert(typeof(text) == "string", "Expected text to be a string");

        currentPage[currentComponentIndex] = ShakingEffect.new({
          text = text;
          frequency = properties.frequency;
          intensity = properties.intensity;
        });

      end;

    end;

    return simulatedContentContainer, simulatedPages;
    
  end;

  local function run(self: Effect, executionProperties: ExecutionProperties)

    return function()
      
      return executionProperties.react.createElement(ShakingContainer, {
        frequency = properties.frequency;
        intensity = properties.intensity;
        text = properties.text;
        react = executionProperties.react;
      }, {
        Message = executionProperties.react.createElement(executionProperties.textComponent, {
          skipPageEvent = executionProperties.skipPageEvent;
          onComplete = executionProperties.continuePage;
          text = properties.text;
          layoutOrder = executionProperties.textComponentProperties.layoutOrder;
          letterDelay = executionProperties.textComponentProperties.letterDelay;
          textSize = executionProperties.textComponentProperties.textSize;
          react = executionProperties.react;
        })
      });

    end;

  end;
  
  local effect = Effect.new({
    name = "ShakingEffect";
    fit = fit;
    run = run;
  });

  return effect;

end;

return ShakingEffect;