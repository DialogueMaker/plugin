--!strict
local DialogueClientScript = script.Parent.Parent;
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);
type Page = IDialogue.Page;

export type ContinueDialogueProperties = {
  isNPCTalking: boolean;
  clickSoundRef: {current: Sound?};
  allowPlayerToSkipDelay: boolean;
  pages: {Page};
  currentPageIndex: number;
  setCurrentPageIndex: (number) -> ();
  onComplete: () -> ();
  skipPageEvent: BindableEvent;
  hasResponses: boolean;
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
  
    elseif not props.hasResponses then	
  
      props.onComplete();
  
    end;

  end;

end;

return useContinueDialogue;