--!strict
local DialogueClientScript = script.Parent.Parent.Parent;
local ReactHooks = DialogueClientScript.ReactHooks;

local React = require(DialogueClientScript.Packages.react);
local types = require(DialogueClientScript.Types);

local MessageTextSegment = require(script.MessageTextSegment);
local usePages = require(ReactHooks.usePages);
local useDynamicSize = require(ReactHooks.useDynamicSize);

type Page = types.Page;
type NPCSettings = types.NPCSettings;

export type MessageContainerProperties = {
  currentPageIndex: number;
  skipPageEvent: BindableEvent?;
  npcSettings: NPCSettings;
  setIsNPCTalking: (boolean) -> ();
  continueDialogue: () -> ();
  onPagesUpdated: (pages: {Page}) -> ();
  dialogue: types.Dialogue;
}

local function MessageContainer(props: MessageContainerProperties)

  local componentIndex, setComponentIndex = React.useState(1);
  local pages, testTextSegment = usePages(props.dialogue:getContent(), MessageTextSegment);
  local currentPageIndex = props.currentPageIndex;
  local skipPageEvent = props.skipPageEvent;

  local sizeX, sizeY, textSize = useDynamicSize({
    {
      sizeX = 310;
      sizeY = 117;
      textSize = 14;
    }
  });

  React.useEffect(function()
  
    props.onPagesUpdated(pages);

  end, {pages :: unknown, props.onPagesUpdated});

  React.useEffect(function()
  
    setComponentIndex(1);

  end, {pages});

  React.useEffect(function(): ()

    props.setIsNPCTalking(true);

  end, {pages :: any, currentPageIndex});
    
  local messageComponentList = {};

  if not testTextSegment then
    
    local page = pages[currentPageIndex];
    if page then
      
      for index, dialogueContentItem in page do

        if index > componentIndex then

          break;

        end;

        if dialogueContentItem.type == "effect" then

          if componentIndex == index then

            dialogueContentItem.run(skipPageEvent);

          end;

          table.insert(messageComponentList, React.createElement(React.Fragment, {
            key = index;
          }));

        elseif dialogueContentItem.type == "text" then
          
          -- Determine new offset.
          table.insert(messageComponentList, React.createElement(MessageTextSegment, {
            text = dialogueContentItem.text;
            skipPageEvent = if skipPageEvent then skipPageEvent.Event else nil;
            layoutOrder = index;
            textSize = textSize;
            key = index;
            letterDelay = props.npcSettings.general.letterDelay;
            onComplete = function()

              if index == #page then 
                
                props.setIsNPCTalking(false);

              else

                setComponentIndex(componentIndex + 1);
              
              end;

            end;
          }));

        end;

      end;
 
    end;

  end;

  return React.createElement("Frame", {
    Size = UDim2.new(0, sizeX, 0, sizeY);
    BackgroundColor3 = Color3.fromHex("#202020");
    BackgroundTransparency = 0.2;
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
