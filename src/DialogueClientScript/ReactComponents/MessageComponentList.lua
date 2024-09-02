--!strict
local React = require(script.Parent.Parent.Packages.react);
local Types = require(script.Parent.Parent.Types);
type Page = Types.Page;
type NPCSettings = Types.NPCSettings;

export type useMessageComponentsProps = {
  pages: {Page}?;
  currentPageIndex: number;
  skipPageEvent: BindableEvent?;
  npcName: string;
  textSegmentComponent: any;
  responseContentScripts: {ModuleScript};
  npcSettings: NPCSettings;
  onTimeout: () -> ();
  setIsClickToContinueButtonVisible: (boolean) -> ();
  setIsNPCTalking: (boolean) -> ();
}

local function MessageComponentList(props: useMessageComponentsProps)

  -- Props
  local pages = props.pages;
  local currentPageIndex = props.currentPageIndex;
  local skipPageEvent = props.skipPageEvent;
  local npcName = props.npcName;
  local TextSegment = props.textSegmentComponent;

  -- States
  local isSkippingPage, setIsSkippingPage = React.useState(false);

  React.useEffect(function(): ()
    
    if skipPageEvent then

      local skipPageConnection = skipPageEvent.Event:Once(function()
      
        setIsSkippingPage(true)

      end);

      return function()

        skipPageConnection:Disconnect();

      end;

    end;

    setIsSkippingPage(false);
    props.setIsNPCTalking(true);

  end, {pages :: any, currentPageIndex});
    
  local messageComponentList = {};
  if pages then

    local page = pages[currentPageIndex];
    if page then
      
      for index, dialogueContentItem in page do

        if dialogueContentItem.type == "effect" then

          print(`[Dialogue Maker] [{index}/{#page}] [Effect] {npcName or "Unknown NPC"}: {dialogueContentItem.name}`);
          dialogueContentItem.run(isSkippingPage);
          table.insert(messageComponentList, React.createElement(React.Fragment));

        elseif dialogueContentItem.type == "text" then
          
          -- Print to the debug console.
          print(`[Dialogue Maker] [{index}/{#page}] [Message] {npcName or "Unknown NPC"}: {dialogueContentItem.text}`);
          
          -- Determine new offset.
          table.insert(messageComponentList, React.createElement(TextSegment, {
            text = dialogueContentItem.text;
            skipPageEvent = skipPageEvent;
            layoutOrder = index;
            onComplete = function()

              if index == #page then 
                
                props.setIsNPCTalking(false);

              end;

            end;
          }));

        end;

      end;

    end;

  end;

  return messageComponentList;

end;

return MessageComponentList;