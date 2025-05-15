--!strict
local DialogueClientScript = script.Parent.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);

export type ResponseComponentListProperties = {
  responseButtonComponent: any;
  responseContentScripts: {ModuleScript};
  onComplete: (ModuleScript) -> ();
}

local function ResponseComponentList(props: ResponseComponentListProperties)
  
  local responseComponents = {};
  for _, responseModule in props.responseContentScripts do

    table.insert(responseComponents, React.createElement(props.responseButtonComponent, {
      text = (require(responseModule) :: () -> {string})()[1]; -- The response's text is always at the first index.
      onClick = function()

        props.onComplete(responseModule);

      end;
    }))

  end;

  return responseComponents;

end;

return ResponseComponentList;