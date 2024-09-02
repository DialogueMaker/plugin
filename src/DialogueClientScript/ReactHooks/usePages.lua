--!strict
local React = require(script.Parent.Parent.Packages.react);
local DialogueAPI = require(script.Parent.Parent.API.Dialogue);
local Types = require(script.Parent.Parent.Types);
type Page = Types.Page;

local function usePages(dialogueContentArray, textContainerRef: any)

  local pages, setPages = React.useState({} :: {Page});
  
  React.useEffect(function()
  
    local textContainer = textContainerRef.current;
    if textContainer and textContainer.Parent then

      local testTextContainer = textContainer:Clone();
      local testTextSegment = testTextContainer:FindFirstChild("TestSegment");
      testTextContainer.Parent = textContainer.Parent;

      local pages = DialogueAPI:getPages(dialogueContentArray, testTextSegment);
      setPages(pages);

      testTextContainer:Destroy();

    end;

  end, {dialogueContentArray, textContainerRef});

  return pages;

end;

return usePages;