--!strict

local StarterPlayer = game:GetService("StarterPlayer");
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts;

local DialogueClientScript = StarterPlayerScripts.DialogueClientScript;
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

    local text = "";
    for _, component in response:getContent() do

      assert(typeof(component) == "string", "[Dialogue Maker] Effect components are currently not supported in response buttons. Please use strings instead.");
      
      text = text .. component;

    end;

    if text ~= "" then

      table.insert(responseComponents, React.createElement(ResponseButton, {
        text = text;
        layoutOrder = index;
        key = index;
        onClick = function()

          props.onComplete(response);

        end;
      }));

    end;

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