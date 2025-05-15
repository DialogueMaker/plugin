--!strict
local DialogueClientScript = script.Parent.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local TextSegment = require(script.Parent.TextSegment);
local types = require(DialogueClientScript.types);
type Page = types.Page;
type NPCSettings = types.NPCSettings;

export type useMessageComponentsProps = {
  pages: {Page}?;
  currentPageIndex: number;
  skipPageEvent: BindableEvent?;
  responseContentScripts: {ModuleScript};
  npcSettings: NPCSettings;
  textSize: number;
  onTimeout: () -> ();
  setIsNPCTalking: (boolean) -> ();
}

local function MessageComponentList(props: useMessageComponentsProps)

  local componentIndex, setComponentIndex = React.useState(1);
  local pages = props.pages;
  local currentPageIndex = props.currentPageIndex;
  local skipPageEvent = props.skipPageEvent;

  React.useEffect(function()
  
    setComponentIndex(1);

  end, {pages});

  React.useEffect(function(): ()

    props.setIsNPCTalking(true);

  end, {pages :: any, currentPageIndex});
    
  local messageComponentList = {};
  if pages then

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
          table.insert(messageComponentList, React.createElement(TextSegment, {
            text = dialogueContentItem.text;
            skipPageEvent = if skipPageEvent then skipPageEvent.Event else nil;
            layoutOrder = index;
            textSize = props.textSize;
            key = index;
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

  return messageComponentList;

end;

return MessageComponentList;