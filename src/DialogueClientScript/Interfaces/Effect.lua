--!strict

export type Bounds = {
  width: number,
  height: number,
};

export type Effect = {
  
  type: "Effect";
  
  run: (self: Effect, skipPageEvent: BindableEvent?) -> ();

  getBounds: (self: Effect) -> Bounds;
  
  name: string;

}

return {};