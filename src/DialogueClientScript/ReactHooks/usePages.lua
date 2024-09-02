--!strict
local React = require(script.Parent.Parent.Packages.react);
local DialogueAPI = require(script.Parent.Parent.API.Dialogue);
local Types = require(script.Parent.Parent.Types);
type Page = Types.Page;

local function usePages(dialogueContentArray, textSegmentRef: any)

  local pages, setPages = React.useState({} :: {Page});
  
  React.useEffect(function()
  
    local textSegment = textSegmentRef.current;
    if textSegment and textSegment.Parent then

      local pages = DialogueAPI:getPages(dialogueContentArray, textSegment);
      setPages(pages);

    end;

  end, {dialogueContentArray});

  return pages;

end;

return usePages;