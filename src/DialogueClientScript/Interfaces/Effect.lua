--!strict

local StarterPlayer = game:GetService("StarterPlayer");
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts;

local DialogueClientScript = StarterPlayerScripts.DialogueClientScript;
local React = require(DialogueClientScript.Packages.react);

export type Bounds = {
  width: number;
  height: number;
};

export type ExecutionProperties = {
  skipPageEvent: BindableEvent?;
  shouldSkip: boolean;
  continuePage: ContinuePageFunction;
  textComponent: (...any) -> React.ReactElement<any, any>;
  textComponentProperties: any;
  key: string;
}

export type Page = {string | Effect};

export type ContinuePageFunction = () -> ();

export type RunEffectFunctionReturnValue = React.ReactElement<any, any>?;

export type RunEffectFunction = (self: Effect, executionProperties: ExecutionProperties) -> RunEffectFunctionReturnValue;

export type FitFunction = (self: Effect, contentContainer: GuiObject, textLabel: TextLabel, pages: {Page}) -> (GuiObject, {Page});

export type Effect = {
  
  type: "Effect";
  
  run: RunEffectFunction;

  fit: FitFunction;
  
  name: string;

}

return {};