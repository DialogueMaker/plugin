--!strict
local DialogueClientScript = script.Parent.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);

local ResponseButton = require(script.ResponseButton);

type Dialogue = IDialogue.Dialogue;

export type ResponseComponentListProperties = {
  responses: {Dialogue};
  onComplete: (newParent: Dialogue) -> ();
}

local function ResponseComponentList(props: ResponseComponentListProperties)
  
  local responseComponents = {};
  for index, response in props.responses do

    table.insert(responseComponents, React.createElement(ResponseButton, {
      text = response:getContent()[1]; -- The response's text is always at the first index.
      layoutOrder = index;
      key = index;
      onClick = function()

        props.onComplete(response);

      end;
    }))

  end;

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    Size = UDim2.fromScale(0, 0);
    BackgroundTransparency = 1;
    LayoutOrder = 3;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      Padding = UDim.new(0, 5);
      SortOrder = Enum.SortOrder.LayoutOrder;
      Wraps = true;
      FillDirection = Enum.FillDirection.Horizontal;
    });
    Responses = React.createElement(React.Fragment, {}, responseComponents);
  });

end;

return ResponseComponentList;