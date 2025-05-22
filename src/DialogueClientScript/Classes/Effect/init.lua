--!strict

local DialogueClientScript = script.Parent.Parent;
local IEffect = require(DialogueClientScript.Interfaces.Effect);

type Effect = IEffect.Effect;
type Bounds = IEffect.Bounds;

local Effect = {};

export type ConstructorProperties = {
  name: string;
  run: (self: Effect, skipPageEvent: BindableEvent?) -> ();
  getBounds: (self: Effect, initialWidth: number, maximumWidth: number) -> {Bounds};
}

function Effect.new(properties: ConstructorProperties): Effect

  local effect: Effect = {
    type = "Effect";
    name = properties.name;
    getBounds = properties.getBounds;
    run = properties.run;
  };

  return effect;

end;

return Effect;