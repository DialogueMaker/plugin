--!strict

local DialogueClientScript = script.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);

export type Bounds = {
  width: number;
  height: number;
};

export type ExecutionProperties = {
  skipPageEvent: BindableEvent?;
  shouldSkip: boolean;
  continuePage: ContinuePageFunction;
}

export type ContinuePageFunction = () -> ();

export type RunEffectFunction = (self: Effect, executionProperties: ExecutionProperties) -> React.ReactElement<any, any>?;

export type GetBoundsFunction = (self: Effect, initialWidth: number, maximumWidth: number) -> {Bounds};

export type Effect = {
  
  type: "Effect";
  
  run: RunEffectFunction;

  getBounds: GetBoundsFunction;
  
  name: string;

}

return {};