--!strict

local DialogueClientScript = script.Parent.Parent;
local DialogueTextContent = require(DialogueClientScript.Classes.DialogueTextContent);
local IDialogueContentFitter = require(DialogueClientScript.Interfaces.DialogueContentFitter);

type DialogueContentFitter = IDialogueContentFitter.DialogueContentFitter;
type Page = IDialogueContentFitter.Page;
type RichTextTag = IDialogueContentFitter.RichTextTag;

local DialogueContentFitter = {};

function DialogueContentFitter.new(contentContainer: GuiObject, textLabel: TextLabel): DialogueContentFitter

  textLabel = textLabel:Clone();
  textLabel.AutomaticSize = Enum.AutomaticSize.XY;
  textLabel.Size = UDim2.fromScale(0, 0);
  textLabel.MaxVisibleGraphemes = -1;

  contentContainer = contentContainer:Clone();
  contentContainer.Visible = false;

  local function getPages(self: DialogueContentFitter, rawPage: Page): {Page}

    -- We clone the content container to avoid race conditions.
    local contentContainer = self.contentContainer:Clone();
    local uiListLayout = contentContainer:FindFirstChildOfClass("UIListLayout");
    assert(uiListLayout, "[Dialogue Maker] Content container must have a UIListLayout to fit text.");

    contentContainer.Parent = self.contentContainer.Parent;

    local function cleanContentContainer()

      for _, child in contentContainer:GetChildren() do
      
        if child:IsA("GuiObject") then
    
          child:Destroy();
    
        end;
    
      end

    end;

    local pages: {Page} = {};
    local currentPageComponents: Page = {};
    local function useNewPage()
      
      assert(#currentPageComponents > 0, "[Dialogue Maker] Current page is empty, so a new page cannot be created. This error prevents a potential infinite loop.");

      table.insert(pages, currentPageComponents);
      currentPageComponents = {};
      cleanContentContainer();
      
    end
    
    cleanContentContainer();
    
    for _, rawComponent in rawPage do
      
      local componentPages: {Page} = {}
      
      if typeof(rawComponent) == "string" then 
        
        local dialogueTextContent = DialogueTextContent.new(self.textLabel, rawComponent);
        componentPages = dialogueTextContent:getPages(contentContainer, pages, currentPageComponents);
      
      else 
        
        componentPages = rawComponent:getPages(contentContainer, pages, currentPageComponents);

      end;

      for index, page in componentPages do
          
        if index ~= 1 then
        
          useNewPage();

        end;

        for _, fittedComponent in page do

          table.insert(currentPageComponents, fittedComponent);

        end;
        
      end
      
    end
    
    -- Add any remaining text to a new page.
    if #currentPageComponents > 0 then
      
      useNewPage();
      
    end

    contentContainer:Destroy();
    
    return pages;

  end;

  local dialogueContentFitter: DialogueContentFitter = {
    contentContainer = contentContainer;
    textLabel = textLabel;
    getPages = getPages;
  };

  return dialogueContentFitter;

end;

return DialogueContentFitter;