--!strict

local DialogueClientScript = script.Parent.Parent;
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);
local types = require(DialogueClientScript.Types);

type Dialogue = IDialogue.Dialogue;
type DialogueSettings = IDialogue.DialogueSettings;
type OptionalDialogueSettings = IDialogue.OptionalDialogueSettings;
type Page = IDialogue.Page;

export type ConstructorProperties = {
  getContent: (self: Dialogue) -> {string};
  runAction: (self: Dialogue, actionID: number) -> ();
  verifyCondition: (self: Dialogue) -> boolean;
  settings: OptionalDialogueSettings?;
}

local Dialogue = {
  defaultSettings = {
    typewriter = {
      characterDelaySeconds = 0.025; 
      canPlayerSkipDelay = true; 
    };
    timeout = {	
      seconds = nil; 
      shouldWaitForResponse = true; 
    };
  } :: DialogueSettings;
};

--[[
  Creates a new dialogue object.
]]
function Dialogue.new(properties: ConstructorProperties, moduleScript: ModuleScript): Dialogue
  
  local settings: DialogueSettings = {
    typewriter = {
      characterDelaySeconds = if properties.settings and properties.settings.typewriter and properties.settings.typewriter.characterDelaySeconds ~= nil then properties.settings.typewriter.characterDelaySeconds else Dialogue.defaultSettings.typewriter.characterDelaySeconds; 
      canPlayerSkipDelay = if properties.settings and properties.settings.typewriter and properties.settings.typewriter.canPlayerSkipDelay ~= nil then properties.settings.typewriter.canPlayerSkipDelay else Dialogue.defaultSettings.typewriter.canPlayerSkipDelay; 
    };
    timeout = {	
      seconds = if properties.settings and properties.settings.timeout and properties.settings.timeout.seconds ~= nil then properties.settings.timeout.seconds else Dialogue.defaultSettings.timeout.seconds; 
      shouldWaitForResponse = if properties.settings and properties.settings.timeout and properties.settings.timeout.shouldWaitForResponse ~= nil then properties.settings.timeout.shouldWaitForResponse else Dialogue.defaultSettings.timeout.shouldWaitForResponse; 
    };
  };

  local settingsChangedEvent = Instance.new("BindableEvent");

  local function getChildren(self: Dialogue): {Dialogue}

    local children: {Dialogue} = {};
    for _, possibleDialogue in moduleScript:GetChildren() do

      if possibleDialogue:IsA("ModuleScript") and tonumber(possibleDialogue.Name) then

        local response = require(possibleDialogue) :: Dialogue;
        table.insert(children, response);

      end

    end

    -- Sort responses because :GetChildren() doesn't guarantee it
    table.sort(children, function(dialogue1, dialogue2)

      return dialogue1.moduleScript.Name < dialogue2.moduleScript.Name;

    end);

    return children;

  end;

  local function getPages(self: Dialogue, textLabel: TextLabel): {Page}
  
    local pages: {Page} = {};
    local currentPage: Page = {};
    local textContainer = textLabel.Parent;
    assert(textContainer and textContainer:IsA("GuiObject"), "TextLabel must be in a text container.");

    local textContainerClone = textContainer:Clone();
    local textLabelClone = textLabel:Clone();
    textLabelClone.AutomaticSize = Enum.AutomaticSize.XY;
    textLabelClone.Size = UDim2.fromScale(0, 0);
    textLabelClone.MaxVisibleGraphemes = -1;
    
    textContainerClone.Visible = false;
    textContainerClone.Parent = textContainer.Parent;
    
    local function newPage()
      
      assert(#currentPage > 0, "[Dialogue Maker] Current page is empty, so a new page cannot be created.");

      table.insert(pages, currentPage);
      currentPage = {};
      textLabelClone = textLabelClone:Clone();
      
      for _, child in textContainerClone:GetChildren() do
    
        if not child:IsA("UIListLayout") then
    
          child:Destroy();
    
        end;
    
      end
      
      textLabelClone.Parent = textContainerClone;
      
    end
    
    for contentArrayIndex, contentArrayItem in self:getContent() do
      
      local contentArrayItemType = typeof(contentArrayItem);
      
      if contentArrayItemType == "string" then
        
        -- Calculate the X size offset.
        local uiListLayout = textContainerClone:FindFirstChildOfClass("UIListLayout");
        assert(uiListLayout, "[Dialogue Maker] UIListLayout not found.");
        
        local lastSpaceIndex: number? = nil;
        
        repeat
          
          local function addTextLabelToPage(TextLabel: TextLabel)

            table.insert(currentPage, {
              type = "Text";
              text = TextLabel.Text;
            });

          end
          
          textLabelClone = textLabelClone:Clone();
          textLabelClone.Visible = true;
          textLabelClone.Text = if lastSpaceIndex then contentArrayItem:sub(lastSpaceIndex + 1) else contentArrayItem;
          textLabelClone.Parent = textContainerClone;
          
          -- Check if we should add a new page.
          if not textLabelClone.TextFits and uiListLayout.AbsoluteContentSize.Y > textContainerClone.AbsoluteSize.Y then

            -- Add the current page to the page list.
            newPage();
            
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

            local function getLineBreakPositions(text: string): {number}

              -- Iterate through each character.
              local breakpoints: {number} = {};
              textLabel.Text = "";
              local lastSpaceIndex: number = 1;
              local skipCounter = 0;
              local remainingRichTextTags = getRichTextIndices(text);
              for index, character in text:split("") do

                -- Check if this is an offset.
                if skipCounter > 0 then

                  skipCounter -= 1;
                  continue;

                end

                if textLabelClone.RichText then

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
                local originalTextBoundsY = textLabelClone.TextBounds.Y;

                -- Add the character and applicable rich text tags.
                textLabelClone.Text = textLabelClone.ContentText .. character;
                if textLabelClone.RichText then

                  for _, richTextTagInfo in remainingRichTextTags do
                    
                    local tagStartOffset = richTextTagInfo.startOffset;
                    local tagEndOffset = richTextTagInfo.endOffset :: number;
                    if index >= tagStartOffset and tagEndOffset > (breakpoints[#breakpoints] or 0) then

                      local prefix = `<{richTextTagInfo.name}{if richTextTagInfo.attributes and richTextTagInfo.attributes ~= "" then ` {richTextTagInfo.attributes}` else ""}>`;
                      local suffix = `</{richTextTagInfo.name}>`;
                      local startOffset = tagStartOffset - (breakpoints[#breakpoints] or 0);
                      local endOffset = (tagEndOffset - (breakpoints[#breakpoints] or 0)) - prefix:len() - suffix:len();
                      textLabelClone.Text = textLabelClone.ContentText:sub(1, startOffset - 1) .. prefix .. textLabelClone.ContentText:sub(startOffset, endOffset - 1) .. suffix .. textLabelClone.ContentText:sub(endOffset);

                    end

                  end

                end;

                if textLabelClone.TextBounds.Y > originalTextBoundsY then

                  local currentTextBoundsY = textLabelClone.TextBounds.Y;
                  textLabelClone.TextWrapped = false;

                  if textLabelClone.TextBounds.Y < currentTextBoundsY then

                    table.insert(breakpoints, lastSpaceIndex);
                    textLabelClone.Text = text:sub(lastSpaceIndex + 1, index);

                  end

                  textLabelClone.TextWrapped = true;

                end

              end
              
              textLabelClone.Text = text;

              -- Return breakpoints.
              return breakpoints;

            end

            local originalText = textLabelClone.Text;
            local breakpoints = getLineBreakPositions(originalText);
            local lastBreakpointIndex = breakpoints[#breakpoints];
            
            if lastBreakpointIndex then
              
              -- Create another TextLabel to replace the last line of text.
              -- This will allow the TextWrapper to accurately calculate 
              -- how much space is available on the X-axis.
              local paragraphTextLabel = textLabelClone:Clone();
              paragraphTextLabel.Text = originalText:sub(1, lastBreakpointIndex);
              paragraphTextLabel.Parent = textLabelClone.Parent;
              addTextLabelToPage(paragraphTextLabel);
              
              -- Fix the textLabelClone's text back.
              textLabelClone.Text = originalText:sub(lastBreakpointIndex + 1);
              
            end;

            addTextLabelToPage(textLabelClone);
            
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
              
              assert(lastSpaceIndex, "[Dialogue Maker] Unable to fit text in text container even after removing the spaces. The text might be too big or the text container might be too small.");
              textLabelClone.Text = textLabelClone.Text:sub(1, lastSpaceIndex - 1);
              
            until textLabelClone.TextFits;
            
            -- Add the remaining text to a new page.
            addTextLabelToPage(textLabelClone);
            
          end

        until not lastSpaceIndex;
        
      elseif contentArrayItemType == "table" then
        
        -- TODO: Add effects
        
      end;
      
    end
    
    textContainerClone:Destroy();
    
    -- Return all pages for this message.
    if currentPage[1] then
      
      newPage();
      
    end
    
    return pages;

  end;

  local function getSettings(self: Dialogue): DialogueSettings

    return table.clone(settings);

  end;

  local function setSettings(self: Dialogue, newSettings: DialogueSettings): ()

    settings = newSettings;
    settingsChangedEvent:Fire();

  end;

  local type = moduleScript:GetAttribute("DialogueType");
  assert(type == "Message" or type == "Response" or type == "Redirect", "[Dialogue Maker] ModuleScript must have a DialogueType attribute set to either Message, Response, or Redirect.");

  local dialogue: Dialogue = {
    type = type;
    moduleScript = moduleScript;
    getContent = properties.getContent;
    getPages = getPages;
    getChildren = getChildren;
    getSettings = getSettings;
    runAction = properties.runAction;
    setSettings = setSettings;
    verifyCondition = properties.verifyCondition;
    SettingsChanged = settingsChangedEvent.Event;
  };

  if dialogue.type == "Redirect" then

    local redirectObjectValue = moduleScript:FindFirstChild("Redirect");
    assert(redirectObjectValue and redirectObjectValue:IsA("ObjectValue"), "[Dialogue Maker] Redirect object value not found.");

    local redirectModuleScript = redirectObjectValue.Value;
    assert(redirectModuleScript and redirectModuleScript:IsA("ModuleScript"), "[Dialogue Maker] Redirect object value is not a ModuleScript.");

    dialogue.redirectModuleScript = redirectModuleScript;

  end;

  return dialogue;

end;

return Dialogue;
