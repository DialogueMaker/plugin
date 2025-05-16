--!strict
local DialogueClientScript = script.Parent.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);

local ResponseButton = require(script.ResponseButton);

export type ResponseComponentListProperties = {
  responseContentScripts: {ModuleScript};
  onComplete: (ModuleScript) -> ();
}

local function ResponseComponentList(props: ResponseComponentListProperties)
  
  local responseComponents = {};
  for index, responseModule in props.responseContentScripts do

    table.insert(responseComponents, React.createElement(ResponseButton, {
      text = require(responseModule):getContent()[1]; -- The response's text is always at the first index.
      layoutOrder = index;
      key = index;
      onClick = function()

        props.onComplete(responseModule);

      end;
    }))

  end;

  return responseComponents;

end;

return ResponseComponentList;