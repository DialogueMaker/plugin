--!strict
local React = require(script.Parent.Parent.Parent.Packages.react);

local function useResponseComponents(responseButtonComponent, responseContentScripts, onCompleteFunction)

  local responseComponents, setResponseComponents = React.useState({});

  React.useEffect(function()
  
    -- Add response buttons
    local newResponseComponents = {};
    for _, responseModule in responseContentScripts do

      table.insert(newResponseComponents, React.createElement(responseButtonComponent, {
        text = (require(responseModule) :: () -> {string})()[1]; -- The response's text is always at the first index.
        onClick = function()

          onCompleteFunction(responseModule);

        end;
      }))

    end;
    setResponseComponents(responseComponents);

  end, {responseContentScripts});

  return responseComponents;

end;

return useResponseComponents;