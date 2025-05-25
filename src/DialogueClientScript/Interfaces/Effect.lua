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

export type Page = {string | Effect};

export type ContinuePageFunction = () -> ();

export type RunEffectFunction = (self: Effect, executionProperties: ExecutionProperties) -> React.ReactElement<any, any>?;

export type FitFunction = (self: Effect, contentContainer: GuiObject, textLabel: TextLabel, pages: {Page}) -> (GuiObject, {Page});

export type Effect = {
  
  type: "Effect";
  
  run: RunEffectFunction;

  fit: FitFunction;
  
  name: string;

}

return {};