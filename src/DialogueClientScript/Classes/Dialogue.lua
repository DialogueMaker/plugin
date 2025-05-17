--!strict

local DialogueClientScript = script.Parent.Parent;
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);
local types = require(DialogueClientScript.Types);

type Dialogue = IDialogue.Dialogue;
type Page = IDialogue.Page;

local Dialogue = {
  isPlayerTalkingWithNPC = false;  
  currentTheme = nil;
};

export type ConstructorProperties = {
  getContent: (self: Dialogue) -> {string};
  runAction: (self: Dialogue) -> ();
  verifyCondition: (self: Dialogue) -> boolean;
}

--[[
  Creates a new dialogue object.
]]
function Dialogue.new(properties: ConstructorProperties): Dialogue

  local function getPages(self: Dialogue, textLabel: TextLabel): {Page}
  
    local pages: {Page} = {};
    local currentPage: Page = {};
    local textContainer = textLabel.Parent;
    assert(textContainer and textContainer:IsA("GuiObject"), "TextLabel must be in a text container.");

    local TextContainerClone = textContainer:Clone();
    local textLabelClone = textLabel:Clone();
    textLabelClone.MaxVisibleGraphemes = -1;
    
    TextContainerClone.Visible = false;
    TextContainerClone.Parent = textContainer.Parent;
    
    local segment = TextContainerClone:FindFirstChild("Segment");
    if segment then
      
      segment:Destroy();
      
    end

    local xSizeOffset = 0;
    
    local function newPage()
      
      table.insert(pages, currentPage);
      currentPage = {};
      textLabelClone = textLabelClone:Clone();
      
      for _, child in TextContainerClone:GetChildren() do
    
        if child.Name ~= "TextWrapper" then
    
          child:Destroy();
    
        end;
    
      end
      
      textLabelClone.Parent = TextContainerClone;
      xSizeOffset = 0;
      
    end
    
    for contentArrayIndex, contentArrayItem in self:getContent() do
      
      local contentArrayItemType = typeof(contentArrayItem);
      
      if contentArrayItemType == "string" then
        
        -- Calculate the X size offset.
        local uiListLayout = TextContainerClone:FindFirstChild("UIListLayout");
        assert(uiListLayout and uiListLayout:IsA("UIListLayout"), "[Dialogue Maker] UIListLayout not found");
        
        local lastSpaceIndex: number? = nil;
        
        repeat
          
          local function addTextLabelToPage(TextLabel: TextLabel)

            table.insert(currentPage, {
              type = "text";
              text = TextLabel.Text;
              size = TextLabel.AbsoluteSize;
            });

          end
          
          textLabelClone = textLabelClone:Clone();
          textLabelClone.Visible = true;
          
          if lastSpaceIndex then
            
            textLabelClone.Text = (contentArrayItem :: string):sub(lastSpaceIndex + 1);
            
          else 
            
            textLabelClone.Text = contentArrayItem :: string;
            
          end
          
          textLabelClone.Parent = TextContainerClone;
          
          if not textLabelClone.TextFits then
            
            -- Check if we should add a new page.
            if uiListLayout.AbsoluteContentSize.Y > TextContainerClone.AbsoluteSize.Y then

              -- Add the current page to the page list.
              newPage();

            end
            
          end
          
          if textLabelClone.TextFits then
            
            local function getRichTextIndices(text: string)

              local richTextTagIndices: {types.RichTextTagInformation} = {};
              local openTagIndices: {number} = {};
              local textCopy = text;
              local tagPattern = "<[^<>]->";
              local pointer = 1;
              for tag in textCopy:gmatch(tagPattern) do

                -- Get the tag name and attributes.
                local tagText = tag:match("<([^<>]-)>");
                if tagText then

                  local firstSpaceIndex = tagText:find(" ");
                  local tagTextLength = tagText:len();
                  local name = tagText:sub(1, (firstSpaceIndex and firstSpaceIndex - 1) or tagTextLength);
                  if name:sub(1, 1) == "/" then

                    for _, index in openTagIndices do

                      if richTextTagIndices[index].name == name:sub(2) then

                        -- Add a tag end offset.
                        local _, endOffset = textCopy:find(tagPattern);
                        if endOffset then

                          richTextTagIndices[index].endOffset = pointer + endOffset;

                        end;

                        -- Remove the tag from the open tag table.
                        table.remove(openTagIndices, index);
                        break;

                      end

                    end

                  else

                    -- Get the tag start offset.
                    local attributes = firstSpaceIndex and tagText:sub(firstSpaceIndex + 1) or "";
                    table.insert(richTextTagIndices, {
                      name = name;
                      attributes = attributes;
                      startOffset = textCopy:find(tagPattern) :: number + pointer - 1;
                    });
                    table.insert(openTagIndices, #richTextTagIndices);

                  end

                  -- Remove the tag from our copy.
                  local _, pointerUpdate = textCopy:find(tagPattern);
                  if pointerUpdate then

                    pointer += pointerUpdate - 1;
                    textCopy = textCopy:sub(pointerUpdate);

                  end;

                end;

              end

              return richTextTagIndices;

            end

            local function getLineBreakPositions(text: string, TextLabel: TextLabel, isRichText: boolean): {number}

              -- Iterate through each character.
              local breakpoints: {number} = {};
              local originalTextLabelText = TextLabel.Text;
              TextLabel.Text = "";
              local lastSpaceIndex: number = 1;
              local skipCounter = 0;
              local remainingRichTextTags = getRichTextIndices(text);
              for index, character in text:split("") do

                -- Check if this is an offset.
                if skipCounter ~= 0 then

                  skipCounter -= 1;
                  continue;

                end

                if isRichText then

                  for _, richTextTagIndex in remainingRichTextTags do

                    if richTextTagIndex.startOffset == index then

                      skipCounter = ("<" .. richTextTagIndex.name .. (if richTextTagIndex.attributes and richTextTagIndex.attributes ~= "" then " " .. richTextTagIndex.attributes else "") .. ">"):len() - 1;
                      break;

                    elseif richTextTagIndex.endOffset :: number - ("</" .. richTextTagIndex.name .. ">"):len() == index then

                      skipCounter = ("</" .. richTextTagIndex.name .. ">"):len() - 1;
                      break;

                    end

                  end

                end;

                if skipCounter > 0 then

                  continue;

                end

                -- Keep track of spaces.
                if character == " " then

                  lastSpaceIndex = index;

                end

                -- Keep track of the original text bounds.
                local originalTextBoundsY = TextLabel.TextBounds.Y;

                -- Add the character and applicable rich text tags.
                TextLabel.Text = TextLabel.ContentText .. character;
                if isRichText then

                  for _, richTextTagInfo in remainingRichTextTags do
                    
                    local tagStartOffset = richTextTagInfo.startOffset;
                    local tagEndOffset = richTextTagInfo.endOffset :: number;
                    if index >= tagStartOffset and tagEndOffset > (breakpoints[#breakpoints] or 0) then

                      local prefix = "<" .. richTextTagInfo.name .. (if richTextTagInfo.attributes and richTextTagInfo.attributes ~= "" then " " .. richTextTagInfo.attributes else "") .. ">";
                      local suffix = "</" .. richTextTagInfo.name .. ">";
                      local startOffset = tagStartOffset - (breakpoints[#breakpoints] or 0);
                      local endOffset = (tagEndOffset - (breakpoints[#breakpoints] or 0)) - prefix:len() - suffix:len();
                      TextLabel.Text = TextLabel.ContentText:sub(1, startOffset - 1) .. prefix .. TextLabel.ContentText:sub(startOffset, endOffset - 1) .. suffix .. TextLabel.ContentText:sub(endOffset);

                    end

                  end

                end;

                if TextLabel.TextBounds.Y > originalTextBoundsY then

                  local currentTextBoundsY = TextLabel.TextBounds.Y;
                  TextLabel.TextWrapped = false;

                  if TextLabel.TextBounds.Y < currentTextBoundsY then

                    table.insert(breakpoints, lastSpaceIndex);
                    TextLabel.Text = text:sub(lastSpaceIndex + 1, index);

                  end

                  TextLabel.TextWrapped = true;

                end

              end
              
              TextLabel.Text = originalTextLabelText;

              -- Return breakpoints.
              return breakpoints;

            end

            local originalText = textLabelClone.Text;
            local breakpoints = getLineBreakPositions(originalText, textLabelClone, textLabelClone.RichText);
            local lastBreakpointIndex = breakpoints[#breakpoints];
            
            if lastBreakpointIndex then
              
              -- Create another TextLabel to replace the last line of text.
              -- This will allow the TextWrapper to accurately calculate 
              -- how much space is available on the X-axis.
              local ParagraphTextLabel = textLabelClone:Clone();
              ParagraphTextLabel.Text = originalText:sub(1, lastBreakpointIndex);
              ParagraphTextLabel.Parent = textLabelClone.Parent;
              addTextLabelToPage(ParagraphTextLabel);
              
              -- Fix the textLabelClone's text back.
              textLabelClone.Parent = nil;
              textLabelClone.Parent = ParagraphTextLabel.Parent;
              textLabelClone.Text = originalText:sub(lastBreakpointIndex + 1);
              
            end;

            addTextLabelToPage(textLabelClone);
            
            xSizeOffset += textLabelClone.TextBounds.X;
            
            lastSpaceIndex = nil;
            
          else
            
            -- Remove a word from the text until we can fit the text.
            lastSpaceIndex = 0;
            repeat

              lastSpaceIndex = table.pack(textLabelClone.Text:find(".* "))[2] :: number;
              
              if not lastSpaceIndex and textLabelClone.TextBounds.Y < textLabelClone.TextSize * textLabelClone.LineHeight then
                
                -- The given area is too small. Add this to a new page.
                newPage();
                continue;              
                
              end
              
              assert(lastSpaceIndex, "[Dialogue Maker] Unable to fit text in text container even after removing the spaces. Is the text too big?");
              textLabelClone.Text = textLabelClone.Text:sub(1, lastSpaceIndex - 1);
              
            until textLabelClone.TextFits;
            
            -- Add the remaining text to a new page.
            addTextLabelToPage(textLabelClone);
            
            xSizeOffset = 0;
            
          end

        until not lastSpaceIndex;
        
      elseif contentArrayItemType == "table" then
        
        -- TODO: Add effects
        
      end;
      
    end
    
    TextContainerClone:Destroy();
    
    -- Return all pages for this message.
    if currentPage[1] then
      
      newPage();
      
    end
    
    return pages;

  end;

  return {
    getContent = properties.getContent;
    runAction = properties.runAction;
    verifyCondition = properties.verifyCondition;
    getPages = getPages;
  }

end;

return Dialogue;
