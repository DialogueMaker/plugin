--!strict

local DialogueClientScript = script.Parent.Parent;
local IEffect = require(DialogueClientScript.Interfaces.Effect);

type Effect = IEffect.Effect;
type Bounds = IEffect.Bounds;
type RunEffectFunction = IEffect.RunEffectFunction;
type FitFunction = IEffect.FitFunction;

local Effect = {};

export type ConstructorProperties = {
  name: string;
  run: RunEffectFunction;
  fit: FitFunction;
}

function Effect.new(properties: ConstructorProperties): Effect

  local effect: Effect = {
    type = "Effect";
    name = properties.name;
    fit = properties.fit;
    run = properties.run;
  };

  return effect;

end;

return Effect;