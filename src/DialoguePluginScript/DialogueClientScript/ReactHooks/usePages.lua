--!strict
local React = require(script.Parent.Parent.Parent.Packages.react);
local DialogueAPI = require(script.Parent.Parent.API.Dialogue);
local Types = require(script.Parent.Parent.Types);
type Page = Types.Page;

local function usePages(dialogueContentArray, textContainerRef, TextSegment)

  local textSegmentRef = React.useRef(nil :: TextLabel?);
  local pages, setPages = React.useState({} :: {Page});

  React.useState(React.createElement(TextSegment, {
    ref = textSegmentRef;
  }));

  React.useEffect(function()
  
    local pages = DialogueAPI:getPages(dialogueContentArray, textContainerRef.current :: Frame, textSegmentRef.current :: TextLabel);
    setPages(pages);

  end, {dialogueContentArray});

  return pages;

end;

return usePages;