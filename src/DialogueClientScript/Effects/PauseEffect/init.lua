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

type Bounds = IEffect.Bounds;
type Effect = IEffect.Effect;
type ContinuePageFunction = IEffect.ContinuePageFunction;
type ExecutionProperties = IEffect.ExecutionProperties;
type Page = IEffect.Page;

local PauseEffect = {};

function PauseEffect.new(timeSeconds: number): Effect
  
  local function fit(self: Effect, contentContainer: GuiObject, textLabel: TextLabel, pages: {Page}): (GuiObject, {Page})
    
    -- This effect is just a pause, so we don't need to do anything special to fit it.
    local newPages = DialogueContentFitter:clonePages(pages);
    table.insert(newPages[#pages], self);
    return contentContainer, newPages;
    
  end;

  local function run(self: Effect, executionProperties: ExecutionProperties)

    if executionProperties.shouldSkip then

      executionProperties.continuePage();
      return;
      
    end;
      
    local continueEvent = Instance.new("BindableEvent");
    local skipPageThread: thread? = nil;
    local timeExpiredThread = task.delay(timeSeconds, function()
      
      if skipPageThread then
        
        task.cancel(skipPageThread);

      end;
      continueEvent:Fire();

    end);

    if executionProperties.skipPageEvent then

      skipPageThread = task.spawn(function()
      
        executionProperties.skipPageEvent.Event:Wait();
        task.cancel(timeExpiredThread);
        continueEvent:Fire();

      end);
      
    end;

    continueEvent.Event:Wait();
    executionProperties.continuePage();

  end;
  
  local effect = Effect.new({
    name = "PauseEffect";
    fit = fit;
    run = run;
  });

  return effect;

end;

return PauseEffect;