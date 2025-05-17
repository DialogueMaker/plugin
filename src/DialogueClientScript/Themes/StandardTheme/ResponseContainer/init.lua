--!strict
local DialogueClientScript = script.Parent.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);

local ResponseButton = require(script.ResponseButton);

type Dialogue = IDialogue.Dialogue;

export type ResponseComponentListProperties = {
  responseContentScripts: {ModuleScript};
  onComplete: (ModuleScript) -> ();
}

local function ResponseComponentList(props: ResponseComponentListProperties)
  
  local responseComponents = {};
  for index, responseModule in props.responseContentScripts do

    local dialogue = require(responseModule) :: Dialogue;

    table.insert(responseComponents, React.createElement(ResponseButton, {
      text = dialogue:getContent()[1]; -- The response's text is always at the first index.
      layoutOrder = index;
      key = index;
      onClick = function()

        props.onComplete(responseModule);

      end;
    }))

  end;

  return React.createElement(React.Fragment, {}, responseComponents);

end;

return ResponseComponentList;