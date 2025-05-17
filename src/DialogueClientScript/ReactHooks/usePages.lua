--!strict
local React = require(script.Parent.Parent.Packages.react);
local DialogueAPI = require(script.Parent.Parent.API.Dialogue);
local Types = require(script.Parent.Parent.Types);
type Page = Types.Page;
type TextSegmentProperties = Types.TextSegmentProperties;
type TextSegmentElement = React.ReactElement<any, TextLabel>;

local function usePages(dialogue: Types.Dialogue, TextSegment: (TextSegmentProperties) -> TextSegmentElement): ({Page}, TextSegmentElement?)

  local pages, setPages = React.useState({} :: {Page});
  local shouldShowTestSegment, setShouldShowTestSegment = React.useState(true);

  local testTextSegmentRef: React.Ref<TextLabel> = React.useRef(nil :: TextLabel?);
  local testTextSegment: TextSegmentElement = React.createElement(TextSegment, {
    text = "";
    skipPageEvent = nil;
    letterDelay = 0;
    layoutOrder = 1;
    textSize = 14;
    ref2 = testTextSegmentRef; 
    onComplete = function() end;
  });

  React.useEffect(function()
  
    assert(typeof(testTextSegmentRef) ~= "function", "textContainerRef must be a ref to a GuiObject");
    local testTextSegment = testTextSegmentRef.current;
    if testTextSegment then

      local pages = DialogueAPI:getPages(dialogue:getContent(), testTextSegment);
      setPages(pages);
      setShouldShowTestSegment(false);

    end;

    return function()

      setShouldShowTestSegment(true);

    end;

  end, {dialogue :: unknown, TextSegment});

  return pages, if shouldShowTestSegment then testTextSegment else nil;

end;

return usePages;