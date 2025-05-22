--!strict

export type Effect = {
  
  type: "Effect";
  
  run: (skipPageEvent: BindableEvent?) -> any;

  getMaxDimensions: () -> {x: number, y: number};

  getBreakpoints: () -> {number};

  onSkip: () -> any;
  
  name: string;

}

return {};