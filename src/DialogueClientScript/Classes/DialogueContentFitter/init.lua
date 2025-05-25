--!strict

local DialogueClientScript = script.Parent.Parent;
local IDialogueContentFitter = require(DialogueClientScript.Interfaces.DialogueContentFitter);
local IEffect = require(DialogueClientScript.Interfaces.Effect);

type DialogueContentFitter = IDialogueContentFitter.DialogueContentFitter;
type Page = IEffect.Page;
type RichTextTag = IDialogueContentFitter.RichTextTag;

local DialogueContentFitter = {};

function DialogueContentFitter.new(contentContainer: GuiObject, textLabel: TextLabel): DialogueContentFitter

  textLabel = textLabel:Clone();
  textLabel.AutomaticSize = Enum.AutomaticSize.XY;
  textLabel.Size = UDim2.fromScale(0, 0);
  textLabel.MaxVisibleGraphemes = -1;

  local contentContainerParent = contentContainer.Parent;
  contentContainer = contentContainer:Clone();
  contentContainer.Visible = false;

  local function getPages(self: DialogueContentFitter, rawPage: Page): {Page}

    -- We clone the content container to avoid race conditions.
    local contentContainer = self.contentContainer:Clone();
    contentContainer.Parent = contentContainerParent;

    local pages: {Page} = {{}};
    
    DialogueContentFitter:cleanContentContainer(contentContainer);
    
    for _, rawComponent in rawPage do
      
      if typeof(rawComponent) == "string" then 
        
        contentContainer, pages = DialogueContentFitter:fitText(rawComponent, contentContainer, textLabel, pages);
      
      else
        
        contentContainer, pages = rawComponent:fit(contentContainer, textLabel, pages);

      end;
      
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

function DialogueContentFitter:cleanContentContainer(contentContainer: GuiObject): ()

  for _, child in contentContainer:GetChildren() do
  
    if child:IsA("GuiObject") then

      child:Destroy();

    end;

  end

end;

function DialogueContentFitter:fitText(text: string, contentContainer: GuiObject, textLabel: TextLabel, pages: {Page}): (GuiObject, {Page})

  pages = table.clone(pages);
  local uiListLayout = contentContainer:FindFirstChildOfClass("UIListLayout");
  assert(uiListLayout, "[Dialogue Maker] Content container must have a UIListLayout to fit text.");

  local lastSpaceIndex: number? = nil;

  repeat
    
    textLabel = textLabel:Clone();
    textLabel.Visible = true;
    textLabel.Text = if lastSpaceIndex then text:sub(lastSpaceIndex + 1) else text;
    textLabel.Parent = contentContainer;
    
    -- Check if we should add a new page.
    local isContainerOverflowing = uiListLayout.AbsoluteContentSize.Y > contentContainer.AbsoluteSize.Y;
    if not textLabel.TextFits and isContainerOverflowing then

      table.insert(pages, {});
      self:cleanContentContainer(contentContainer);
      
    end
    
    if textLabel.TextFits then
      
      local function getRichTextIndices(text: string)

        local richTextTagIndices: {RichTextTag} = {};
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

      local function getLineBreakPositions(text: string): {number}

        local restoredComponents = {};
        for _, component in pages[#pages] do

          if typeof(component) == "string" then

            local TextLabel = textLabel:Clone();
            TextLabel.Text = component;
            TextLabel.Parent = contentContainer;
            table.insert(restoredComponents, TextLabel);

          end

        end;

        -- Iterate through each character.
        local breakpoints: {number} = {};
        local lastSpaceIndex: number = 1;
        local skipCounter = 0;
        local remainingRichTextTags = getRichTextIndices(text);
        textLabel.Text = "";

        for index, character in text:split("") do

          -- Check if this is an offset.
          if skipCounter > 0 then

            skipCounter -= 1;
            continue;

          end

          if textLabel.RichText then

            for _, richTextTagIndex in remainingRichTextTags do

              if richTextTagIndex.startOffset == index then

                skipCounter = (`<{richTextTagIndex.name}{if richTextTagIndex.attributes and richTextTagIndex.attributes ~= "" then ` {richTextTagIndex.attributes}` else ""}>`):len() - 1;
                break;

              elseif richTextTagIndex.endOffset :: number - (`</{richTextTagIndex.name}>`):len() == index then

                skipCounter = (`</{richTextTagIndex.name}>`):len() - 1;
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
          local originalAbsoluteContentSize = uiListLayout.AbsoluteContentSize;

          -- Add a character and reformat the text.
          textLabel.Text = textLabel.ContentText .. character;
          if textLabel.RichText then

            for _, richTextTagInfo in remainingRichTextTags do
              
              local tagStartOffset = richTextTagInfo.startOffset;
              local tagEndOffset = richTextTagInfo.endOffset :: number;
              if index >= tagStartOffset and tagEndOffset > (breakpoints[#breakpoints] or 0) then

                local prefix = `<{richTextTagInfo.name}{if richTextTagInfo.attributes and richTextTagInfo.attributes ~= "" then ` {richTextTagInfo.attributes}` else ""}>`;
                local suffix = `</{richTextTagInfo.name}>`;
                local startOffset = tagStartOffset - (breakpoints[#breakpoints] or 0);
                local endOffset = (tagEndOffset - (breakpoints[#breakpoints] or 0)) - prefix:len() - suffix:len();
                textLabel.Text = textLabel.ContentText:sub(1, startOffset - 1) .. prefix .. textLabel.ContentText:sub(startOffset, endOffset - 1) .. suffix .. textLabel.ContentText:sub(endOffset);

              end

            end

          end;

          if uiListLayout.AbsoluteContentSize.Y ~= originalAbsoluteContentSize.Y then

            uiListLayout.Wraps = false;
            uiListLayout.Wraps = true;

          end

          -- From here, we can guess for a line break because the Y axis of 
          -- the UIListLayout's content size will change if the character causes a line break.
          if uiListLayout.AbsoluteContentSize.Y > originalAbsoluteContentSize.Y then

            -- We should check again with unwrapped text to ensure that 
            -- rich text didn't cause the line break.
            local wrappedAbsoluteContentSize = uiListLayout.AbsoluteContentSize;

            textLabel.TextWrapped = false;

            if uiListLayout.AbsoluteContentSize.Y < wrappedAbsoluteContentSize.Y then
              
              table.insert(breakpoints, lastSpaceIndex);
              textLabel.Text = text:sub(lastSpaceIndex + 1, index);

            end

            textLabel.TextWrapped = true;

          end

        end
        
        textLabel.Text = text;

        for _, restoredComponent in restoredComponents do

          restoredComponent:Destroy();

        end

        return breakpoints;

      end

      local originalText = textLabel.Text;
      local lineBreaks = getLineBreakPositions(originalText);
      local lastLineBreakIndex = lineBreaks[#lineBreaks];
      
      if lastLineBreakIndex then
        
        -- Create another TextLabel to replace the last line of text.
        -- Otherwise, the TextLabel might take up too much space on the Y axis.
        local paragraphTextLabel = textLabel:Clone();
        paragraphTextLabel.Text = originalText:sub(1, lastLineBreakIndex);
        paragraphTextLabel.Parent = textLabel.Parent;
        table.insert(pages[#pages], paragraphTextLabel.Text);
        
        -- Put the remaining text in the original TextLabel.
        textLabel.Text = originalText:sub(lastLineBreakIndex + 1);
        
      end;

      table.insert(pages[#pages], textLabel.Text);
      
      lastSpaceIndex = nil;
      
    else
      
      -- Remove a word from the text until we can fit the text.
      lastSpaceIndex = 0;
      repeat

        lastSpaceIndex = table.pack(textLabel.Text:find(".* "))[2] :: number;
        
        if not lastSpaceIndex and textLabel.TextBounds.Y < textLabel.TextSize * textLabel.LineHeight then
          
          -- The given area is too small. Add this to a new page.
          table.insert(pages, {});
          self:cleanContentContainer(contentContainer);
          continue;
          
        end

        assert(lastSpaceIndex, "[Dialogue Maker] Unable to fit text in text container even after removing the spaces. The text might be too big or the text container might be too small.");
        textLabel.Text = textLabel.Text:sub(1, lastSpaceIndex - 1);
        
      until textLabel.TextFits;
      
      -- Add the remaining text to a new page.
      table.insert(pages[#pages], textLabel.Text);
      
    end

  until not lastSpaceIndex;

  return contentContainer, pages;

end;

return DialogueContentFitter;