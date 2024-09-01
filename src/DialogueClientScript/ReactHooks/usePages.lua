--!strict
local React = require(script.Parent.Parent.Packages.react);
local DialogueAPI = require(script.Parent.Parent.API.Dialogue);
local Types = require(script.Parent.Parent.Types);
type Page = Types.Page;

local function usePages(dialogueContentArray, textSegmentRef)

  local pages, setPages = React.useState({} :: {Page});
  
  React.useEffect(function()
  
    local pages = DialogueAPI:getPages(dialogueContentArray, textSegmentRef.current :: TextLabel);
    setPages(pages);

  end, {dialogueContentArray});

  return pages;

end;

return usePages;