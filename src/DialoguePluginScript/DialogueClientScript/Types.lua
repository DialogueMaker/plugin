export type ContentArray = {string | Effect};

export type Effect = {
  
  type: "effect";
  
  run: (isPlayerSkipping: boolean) -> any;

  getMaxDimensions: () -> {x: number, y: number};

  getBreakpoints: () -> {number};

  onSkip: () -> any;
  
  name: string;

}

export type UseEffectFunction = (effectName: string, effectProperties: {[string]: any}) -> Effect;

export type RichTextTagInformation = {
  attributes: string?;
  endOffset: number?;
  name: string;
  startOffset: number;
}

export type Page = {{type: "text"; text: string; size: UDim2} | Effect};

return {};
