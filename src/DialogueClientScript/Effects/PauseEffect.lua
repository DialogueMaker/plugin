--!strict
-- This effect pauses a message for a certain amount of time.
-- This is helpful for when you want to draw emphasis to some text.
-- 
-- Programmer: Christian Toney
-- © 2025 Dialogue Maker Group

local DialogueClientScript = script.Parent.Parent;
local Effect = require(DialogueClientScript.Classes.Effect);
local IEffect = require(DialogueClientScript.Interfaces.Effect);

type Bounds = IEffect.Bounds;
type Effect = IEffect.Effect;

local PauseEffect = {};

function PauseEffect.new(timeSeconds: number): Effect
  
  local function getBounds(self: Effect, initialWidth: number, maximumWidth: number): {Bounds}
    
    return {};
    
  end;

  local function run(self: Effect, skipPageEvent: BindableEvent?)

    local continueEvent = Instance.new("BindableEvent");
    local skipPageThread: thread? = nil;
    local timeExpiredThread = task.delay(timeSeconds, function()
      
      if skipPageThread then
        
        task.cancel(skipPageThread);

      end;
      continueEvent:Fire();

    end);

    if skipPageEvent then

      skipPageThread = task.spawn(function()
      
        skipPageEvent.Event:Wait();
        task.cancel(timeExpiredThread);
        continueEvent:Fire();

      end);
      
    end;

    continueEvent.Event:Wait();

  end;
  
  local effect = Effect.new({
    name = "PauseEffect";
    getBounds = getBounds;
    run = run;
  });

  return effect;

end;

return PauseEffect;