--!strict
local Types = require(script.Parent.Parent.Types);
type Page = Types.Page;

export type ContinueDialogueProperties = {
  isNPCTalking: boolean;
  clickSoundRef: {current: Sound?};
  allowPlayerToSkipDelay: boolean;
  pages: {Page};
  currentPageIndex: number;
  setCurrentPageIndex: (number) -> ();
  onComplete: () -> ();
  skipPageEvent: BindableEvent;
  responseContentScripts: {ModuleScript};
}

local function useContinueDialogue(props: ContinueDialogueProperties)

  return function()

    if props.isNPCTalking then

      local clickSound = props.clickSoundRef.current;
      if clickSound then
  
        clickSound:Play();
  
      end;
  
      if props.allowPlayerToSkipDelay then
        
        props.skipPageEvent:Fire();
  
      end;
  
    elseif props.pages and #props.pages > props.currentPageIndex then
  
      props.setCurrentPageIndex(props.currentPageIndex + 1);
  
    elseif #props.responseContentScripts == 0 then	
  
      props.onComplete();
  
    end;

  end;

end;

return useContinueDialogue;