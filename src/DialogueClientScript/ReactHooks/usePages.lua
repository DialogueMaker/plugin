--!strict
local DialogueClientScript = script.Parent.Parent;
local DialogueContentFitter = require(DialogueClientScript.Classes.DialogueContentFitter);
local React = require(DialogueClientScript.Packages.react);
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);
local IDialogueContentFitter = require(DialogueClientScript.Interfaces.DialogueContentFitter);
local Types = require(DialogueClientScript.Types);

type Dialogue = IDialogue.Dialogue;
type Page = IDialogueContentFitter.Page;
type TextSegmentProperties = Types.TextSegmentProperties;
type TextSegmentElement = React.ReactElement<any, TextLabel>;

local function usePages(dialogue: Dialogue, textContainerRef: React.Ref<GuiObject>, TextSegment: (TextSegmentProperties) -> TextSegmentElement, textSize: number): ({Page}, TextSegmentElement?)

  local pages, setPages = React.useState({} :: {Page});
  local shouldShowTestSegment, setShouldShowTestSegment = React.useState(true);
  local testTextSegment: TextLabel?, setTestTextSegment = React.useState(nil :: TextLabel?);
  local testTextSegmentRef: React.Ref<TextLabel> = React.useRef(nil :: TextLabel?);
  local testTextSegmentComponent: TextSegmentElement = React.createElement(TextSegment, {
    text = "";
    skipPageEvent = nil;
    letterDelay = 0;
    layoutOrder = 1;
    textSize = textSize;
    ref2 = testTextSegmentRef; 
    onComplete = function() end;
  });

  React.useEffect(function()
  
    assert(typeof(testTextSegmentRef) ~= "function", "textContainerRef must be a ref to a GuiObject");
    if testTextSegmentRef.current then

      setTestTextSegment(testTextSegmentRef.current:Clone());
      setShouldShowTestSegment(false);

    else

      setTestTextSegment(nil);
      setShouldShowTestSegment(true);

    end;

  end, {TextSegment :: unknown, textSize});

  React.useEffect(function()
  
    assert(typeof(textContainerRef) ~= "function", "textContainerRef must be a ref to a GuiObject");
    local textContainer = textContainerRef.current;
    if testTextSegment and textContainer then

      local dialogueContentFitter = DialogueContentFitter.new(textContainer, testTextSegment);
      local dialogueContent = dialogue:getContent();
      local pages = dialogueContentFitter:getPages(dialogueContent);
      setPages(pages);

    end;

  end, {dialogue :: unknown, testTextSegment});

  return pages, if shouldShowTestSegment then testTextSegmentComponent else nil;

end;

return usePages;