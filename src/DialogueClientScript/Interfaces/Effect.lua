--!strict

export type Bounds = {
  width: number,
  height: number,
};

export type SkipProperties = {
  skipPageEvent: BindableEvent?;
  shouldSkip: boolean;
}

export type RunEffectFunction = (self: Effect, skipProperties: SkipProperties) -> ();

export type GetBoundsFunction = (self: Effect, initialWidth: number, maximumWidth: number) -> {Bounds};

export type Effect = {
  
  type: "Effect";
  
  run: RunEffectFunction;

  getBounds: GetBoundsFunction;
  
  name: string;

}

return {};