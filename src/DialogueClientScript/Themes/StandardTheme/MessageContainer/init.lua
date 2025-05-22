--!strict
local DialogueClientScript = script.Parent.Parent.Parent;
local ReactHooks = DialogueClientScript.ReactHooks;

local React = require(DialogueClientScript.Packages.react);
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);
local IDialogueContentFitter = require(DialogueClientScript.Interfaces.DialogueContentFitter);

local MessageTextSegment = require(script.MessageTextSegment);
local usePages = require(ReactHooks.usePages);

type Page = IDialogueContentFitter.Page;
type Dialogue = IDialogue.Dialogue;

export type MessageContainerProperties = {
  currentPageIndex: number;
  skipPageEvent: BindableEvent?;
  continueDialogue: () -> ();
  onPagesUpdated: (pages: {Page}) -> ();
  setIsTypingFinished: (boolean) -> ();
  dialogue: Dialogue;
}

local function MessageContainer(props: MessageContainerProperties)

  local componentIndex, setComponentIndex = React.useState(1);
  local textContainerRef = React.useRef(nil :: GuiObject?);
  local pages, testTextSegment = usePages(props.dialogue, textContainerRef, MessageTextSegment, 14);
  local currentPageIndex = props.currentPageIndex;
  local skipPageEvent = props.skipPageEvent;

  React.useEffect(function()
  
    props.onPagesUpdated(pages);

  end, {pages :: unknown, props.onPagesUpdated});

  React.useEffect(function()
  
    setComponentIndex(1);

  end, {pages});

  React.useEffect(function(): ()

    props.setIsTypingFinished(false);

  end, {pages :: any, currentPageIndex});
    
  local messageComponentList = {};

  if not testTextSegment then
    
    local page = pages[currentPageIndex];
    if page then
      
      for index, dialogueContentItem in page do

        if index > componentIndex then

          break;

        end;

        if dialogueContentItem.type == "Effect" then

          if componentIndex == index then

            dialogueContentItem:run(skipPageEvent);
            setComponentIndex(componentIndex + 1);

          end;

        elseif dialogueContentItem.type == "Text" then
          
          local dialogueSettings = props.dialogue:getSettings();
          local textSegment = React.createElement(MessageTextSegment, {
            text = dialogueContentItem.text;
            dialogue = props.dialogue;
            skipPageEvent = if skipPageEvent then skipPageEvent.Event else nil;
            layoutOrder = index;
            textSize = 14;
            key = index;
            letterDelay = dialogueSettings.typewriter.characterDelaySeconds;
            onComplete = function()

              if index == #page then 
                
                props.setIsTypingFinished(true);

              else

                setComponentIndex(componentIndex + 1);
              
              end;

            end;
          });

          table.insert(messageComponentList, textSegment);

        end;

      end;
 
    end;

  end;

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 117);
    BackgroundColor3 = Color3.fromHex("#202020");
    BackgroundTransparency = 0.2;
    ref = textContainerRef;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
      Wraps = true;
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 15);
      PaddingTop = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
    });
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
    MessageComponentList = React.createElement(React.Fragment, {}, testTextSegment or messageComponentList);
  });

end;

return MessageContainer;
