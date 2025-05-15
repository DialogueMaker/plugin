export type Dialogue = {

  --[[
    This is the code that's ran when the dialogue is shown.
    If this is a message or a response, then the string array will be the message or response content.

    The dialogue box will be blank until this function returns.

    This function returns an array instead of a string because Dialogue Maker will support text effects in the future.

    This function does not run if the dialogue is a redirect.
  ]]
  getContent: (self: Dialogue) -> {string};

  --[[
    In order for this dialogue to show, the condition must pass by returning true. 
    Otherwise, lower priority dialogue will be used. 
  ]]
  verifyCondition: (self: Dialogue) -> boolean;

  --[[
    This is the code that's ran when the action is called.

    This function does not run if the dialogue is a redirect.
  ]]
  runAction: (self: Dialogue) -> ();
  
};

return {};