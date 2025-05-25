--!strict
-- This effect pauses a message for a certain amount of time.
-- This is helpful for when you want to draw emphasis to some text.
-- 
-- Programmer: Christian Toney
-- © 2025 Dialogue Maker Group

local DialogueClientScript = script.Parent.Parent;
local Effect = require(DialogueClientScript.Classes.Effect);
local IDialogueContentFitter = require(DialogueClientScript.Interfaces.DialogueContentFitter);
local IEffect = require(DialogueClientScript.Interfaces.Effect);
local React = require(DialogueClientScript.Packages.react);
local ShakingContainer = require(script.ShakingContainer);

type Bounds = IEffect.Bounds;
type ContinuePageFunction = IEffect.ContinuePageFunction;
type DialogueContentFitter = IDialogueContentFitter.DialogueContentFitter;
type Effect = IEffect.Effect;
type ExecutionProperties = IEffect.ExecutionProperties;
type Page = IDialogueContentFitter.Page;
type ShakingEffectProperties = ShakingContainer.ShakingEffectProperties;

local ShakingEffect = {};

function ShakingEffect.new(properties: ShakingEffectProperties): Effect
  
  local function fitContent(self: Effect, dialogueContentFitter: DialogueContentFitter, contentContainer: GuiObject, pages: {Page}, currentPage: Page): ()
    
    return dialogueContentFitter:getTextPages({
      text = properties.text;
      contentContainer = contentContainer;
      pages = pages;
      currentPage = currentPage;
    });
    
  end;

  local function run(self: Effect, executionProperties: ExecutionProperties)

    return React.createElement(ShakingContainer, {
      frequency = properties.frequency;
      intensity = properties.intensity;
      executionProperties = executionProperties;
    });

  end;
  
  local effect = Effect.new({
    name = "ShakingEffect";
    getBounds = getBounds;
    run = run;
  });

  return effect;

end;

return ShakingEffect;