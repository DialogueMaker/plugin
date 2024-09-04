--!strict
local React = require(script.Parent.Parent.Parent.Parent.Packages.react);
local Types = require(script.Parent.Parent.Parent.Parent.Types);
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
  setIsNPCTalking: (boolean) -> ();
}

local function MessageComponentList(props: useMessageComponentsProps)

  -- Props
  local pages = props.pages;
  local currentPageIndex = props.currentPageIndex;
  local skipPageEvent = props.skipPageEvent;
  local npcName = props.npcName;
  local TextSegment = props.textSegmentComponent;

  React.useEffect(function(): ()

    props.setIsNPCTalking(true);

  end, {pages :: any, currentPageIndex});
    
  local messageComponentList = {};
  if pages then

    local page = pages[currentPageIndex];
    if page then
      
      for index, dialogueContentItem in page do

        if dialogueContentItem.type == "effect" then

          dialogueContentItem.run(skipPageEvent);
          table.insert(messageComponentList, React.createElement(React.Fragment));

        elseif dialogueContentItem.type == "text" then
          
          -- Determine new offset.
          table.insert(messageComponentList, React.createElement(TextSegment, {
            text = dialogueContentItem.text;
            skipPageEvent = if skipPageEvent then skipPageEvent.Event else nil;
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