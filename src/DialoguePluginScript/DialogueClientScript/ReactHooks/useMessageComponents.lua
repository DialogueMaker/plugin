--!strict
local React = require(script.Parent.Parent.Parent.Packages.react);
local Types = require(script.Parent.Parent.Types);
type Page = Types.Page;
type NPCSettings = Types.NPCSettings;

export type useMessageComponentsProps = {
  pages: {Page}?;
  currentPageIndex: number;
  skipPageEventRef: {current: BindableEvent?};
  npcName: string;
  textSegmentComponent: any;
  responseContentScripts: {ModuleScript};
  npcSettings: NPCSettings;
  onTimeout: () -> ();
  setIsClickToContinueButtonVisible: (boolean) -> ();
}

local function useMessageComponents(props: useMessageComponentsProps)

  -- Props
  local pages = props.pages;
  local currentPageIndex = props.currentPageIndex;
  local skipPageEventRef = props.skipPageEventRef;
  local npcName = props.npcName;
  local TextSegment = props.textSegmentComponent;
  local responseContentScripts = props.responseContentScripts;
  local npcSettings = props.npcSettings;

  -- States
  local isNPCTalking, setIsNPCTalking = React.useState(false);
  local isSkippingPage, setIsSkippingPage = React.useState(false);
  local messageComponents, setMessageComponents = React.useState({});

  React.useEffect(function(): ()
    
    local skipPageEvent = skipPageEventRef.current;
    if skipPageEvent then

      local skipPageConnection = skipPageEvent.Event:Once(function()
      
        setIsSkippingPage(true)

      end);

      return function()

        skipPageConnection:Disconnect();

      end;

    end;

    setIsSkippingPage(false);

  end, {pages :: any, currentPageIndex});

  React.useEffect(function(): ()
    
    if pages then

      local page = pages[currentPageIndex];

      -- Iterate through the page, run events, and show message text.
      local dialogueContentItemIndex = #messageComponents;
      if #page > dialogueContentItemIndex then

        local dialogueContentItem = page[dialogueContentItemIndex];
        if dialogueContentItem.type == "effect" then

          print(`[Dialogue Maker] [{dialogueContentItemIndex}/{#page}] [Effect] {npcName or "Unknown NPC"}: {dialogueContentItem.name}`);
          dialogueContentItem.run(isSkippingPage);
          setMessageComponents({table.unpack(messageComponents), React.createElement(React.Fragment)});

        elseif dialogueContentItem.type == "text" then
          
          -- Print to the debug console.
          print(`[Dialogue Maker] [{dialogueContentItemIndex}/{#page}] [Message] {npcName or "Unknown NPC"}: {dialogueContentItem.text}`);
          
          -- Determine new offset.
          setMessageComponents({table.unpack(messageComponents), React.createElement(TextSegment, {
            text = dialogueContentItem.text;
            skipPageEvent = skipPageEventRef.current;
            layoutOrder = dialogueContentItemIndex;
          })});

        end;

      else

        -- Check if there are more pages.
        if pages[currentPageIndex + 1] and isNPCTalking then

          -- Wait for the player to click
          props.setIsClickToContinueButtonVisible(true);

        end;
        setIsNPCTalking(false);
        setIsSkippingPage(false);

        -- Run the timeout code in the background
        if npcSettings.timeout.enabled then

          -- Wait for the player if the developer wants to
          if #responseContentScripts == 0 or not npcSettings.timeout.waitForResponse then

            local timeoutTask = task.delay(npcSettings.timeout.seconds, function()
            
              props.onTimeout();

            end);

            return function()

              task.cancel(timeoutTask);

            end;

          end;

        end;

      end;

    end;

  end, {pages :: any, currentPageIndex});

  return messageComponents, isNPCTalking;

end;

return useMessageComponents;