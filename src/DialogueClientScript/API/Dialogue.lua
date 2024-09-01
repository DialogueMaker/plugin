--!strict
local ReactRoblox = require(script.Parent.Parent.Packages["react-roblox"]);
local React = require(script.Parent.Parent.Packages.react);
local Players = game:GetService("Players");
local Player = Players.LocalPlayer;

local themeChangedEvent = Instance.new("BindableEvent");

local DialogueModule = {
  isPlayerTalkingWithNPC = false;  
  currentTheme = nil;
  onThemeChanged = themeChangedEvent.Event;
};

local DialogueClientScript = script.Parent.Parent;
local Types = require(DialogueClientScript.Types);
type Page = Types.Page;

local clientSettings = require(DialogueClientScript.Settings);

-- @since v5.0.0
function DialogueModule:getThemeModuleScript(themeName: string, useDefaultIfNotFound: boolean?): ModuleScript

  -- Check if we have the theme
  local ThemeFolder = DialogueClientScript.ReactComponents.Themes;
  local themeModuleScript = ThemeFolder:FindFirstChild(themeName);
  if themeName and not themeModuleScript and useDefaultIfNotFound then

    if themeName ~= "" then

      warn("[Dialogue Maker]: Can't find theme \"" .. themeName .. "\" in the Themes folder of the DialogueClientScript. Using default theme...");

    end

    themeModuleScript = ThemeFolder:FindFirstChild(clientSettings.defaultTheme);

  end

  -- Return the theme module script.
  assert(themeModuleScript, "There isn't an available theme.");
  return themeModuleScript:Clone();

end;

-- Searches for a ModuleScript based on a given directory. Errors if it doesn't exist. 
-- @since v5.0.0
-- @returns A module script of a given directory.
function DialogueModule:getContentScriptFromPriority(dialogueContainer: Folder, targetPath: {string}): ModuleScript

  local currentPath = "";
  local CurrentDirectoryScript: ModuleScript | Folder = dialogueContainer;
  for index, directory in targetPath do

    currentPath = currentPath .. (if currentPath ~= "" then "." else "") .. directory;
    local PossibleDirectory = CurrentDirectoryScript:FindFirstChild(directory);
    if not PossibleDirectory or not PossibleDirectory:IsA("ModuleScript") then

      error("[Dialogue Maker]" .. currentPath .. " is not a ModuleScript");

    end
    CurrentDirectoryScript = PossibleDirectory;

  end;
  
  if CurrentDirectoryScript:IsA("Folder") then
    
    error("[Dialogue Maker] Target path (" .. table.concat(targetPath, ".") .. ") not found.");
    
  end
  
  return CurrentDirectoryScript;

end;

-- Returns a list of Page objects based on the given content array by fitting it in a given text label in a given text container.
-- @since v5.0.0
function DialogueModule:getPages(contentArray: Types.ContentArray, textContainer: GuiObject, textLabel: TextLabel): {Page}
  
  local pages: {Types.Page} = {};
  local currentPage: Types.Page = {};
  local TextContainerClone = textContainer:Clone();
  local TextLabelClone = textLabel:Clone();
  
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
    TextLabelClone = TextLabelClone:Clone();
    
    for _, child in TextContainerClone:GetChildren() do
  
      if child.Name ~= "TextWrapper" then
  
        child:Destroy();
  
      end;
  
    end
    
    TextLabelClone.Parent = TextContainerClone;
    TextLabelClone.Size = UDim2.new(1, 0, 1, 0);
    xSizeOffset = 0;
    
  end
  
  for contentArrayIndex, contentArrayItem in contentArray do
    
    local contentArrayItemType = typeof(contentArrayItem);
    
    if contentArrayItemType == "string" then
      
      -- Calculate the X size offset.
      local TextWrapper = TextContainerClone:FindFirstChild("TextWrapper");
      assert(TextWrapper and TextWrapper:IsA("UIListLayout"), "[Dialogue Maker] TextWrapper not found");
      
      local lastSpaceIndex: number? = nil;
      
      repeat
        
        local function addTextLabelToPage(TextLabel: TextLabel)

          table.insert(currentPage, {
            type = "text";
            text = TextLabel.Text;
            size = TextLabel.Size;
          });

        end
        
        TextLabelClone = TextLabelClone:Clone();
        
        if lastSpaceIndex then
          
          TextLabelClone.Text = (contentArrayItem :: string):sub(lastSpaceIndex + 1);
          
        else 
          
          TextLabelClone.Text = contentArrayItem :: string;
          
        end
        
        TextLabelClone.Size = UDim2.new(1, -xSizeOffset, if xSizeOffset > 0 then 0 else 1, if xSizeOffset > 0 then TextLabelClone.TextSize * TextLabelClone.LineHeight else -TextWrapper.AbsoluteContentSize.Y);
        TextLabelClone.Parent = TextContainerClone;
        
        if not TextLabelClone.TextFits then
          
          -- Check if we should add a new page.
          if TextWrapper.AbsoluteContentSize.Y > TextContainerClone.AbsoluteSize.Y then

            -- Add the current page to the page list.
            newPage();

          end
          
        end
        
        if TextLabelClone.TextFits then
          
          local function getRichTextIndices(text: string)

            local richTextTagIndices: {Types.RichTextTagInformation} = {};
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

          local originalText = TextLabelClone.Text;
          local breakpoints = getLineBreakPositions(originalText, TextLabelClone, TextLabelClone.RichText);
          local lastBreakpointIndex = breakpoints[#breakpoints];
          
          if lastBreakpointIndex then
            
            -- Create another TextLabel to replace the last line of text.
            -- This will allow the TextWrapper to accurately calculate 
            -- how much space is available on the X-axis.
            local ParagraphTextLabel = TextLabelClone:Clone();
            ParagraphTextLabel.Text = originalText:sub(1, lastBreakpointIndex);
            ParagraphTextLabel.Parent = TextLabelClone.Parent;
            ParagraphTextLabel.Size = UDim2.new(0, ParagraphTextLabel.TextBounds.X, 0, ParagraphTextLabel.TextBounds.Y + (ParagraphTextLabel.TextSize * ParagraphTextLabel.LineHeight - ParagraphTextLabel.TextSize));
            addTextLabelToPage(ParagraphTextLabel);
            
            -- Fix the TextLabelClone's text back.
            TextLabelClone.Parent = nil;
            TextLabelClone.Parent = ParagraphTextLabel.Parent;
            TextLabelClone.Text = originalText:sub(lastBreakpointIndex + 1);
            
          end;
          
          TextLabelClone.Size = UDim2.new(0, TextLabelClone.TextBounds.X, 0, TextLabelClone.TextBounds.Y + (TextLabelClone.TextSize * TextLabelClone.LineHeight - TextLabelClone.TextSize));
          addTextLabelToPage(TextLabelClone);
          
          xSizeOffset += TextLabelClone.TextBounds.X;
          
          lastSpaceIndex = nil;
          
        else
          
          -- Remove a word from the text until we can fit the text.
          lastSpaceIndex = 0;
          repeat

            lastSpaceIndex = table.pack(TextLabelClone.Text:find(".* "))[2] :: number;
            if not lastSpaceIndex and TextLabelClone.TextBounds.Y < TextLabelClone.TextSize * TextLabelClone.LineHeight then
              
              -- The given area is too small. Add this to a new page.
              newPage();
              continue;              
              
            end
            
            assert(lastSpaceIndex, "[Dialogue Maker] Unable to fit text in text container even after removing the spaces. Is the text too big?");
            TextLabelClone.Text = TextLabelClone.Text:sub(1, lastSpaceIndex - 1);
            
          until TextLabelClone.TextFits;
          
          TextLabelClone.Size = UDim2.new(0, TextLabelClone.TextBounds.X, 0, TextLabelClone.TextBounds.Y + (TextLabelClone.TextSize * TextLabelClone.LineHeight - TextLabelClone.TextSize));
          
          -- Add the remaining text to a new page.
          addTextLabelToPage(TextLabelClone);
          
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

-- Checks if the local player passes a condition.
-- @since v5.0.0
function DialogueModule:doesPlayerPassCondition(contentScript: ModuleScript): boolean

  local conditionScript = contentScript:FindFirstChild("Condition") :: ModuleScript?;
  local conditionResult = if conditionScript then require(conditionScript)() :: boolean else true;
  return conditionResult;

end;

function DialogueModule:setTheme(theme: ModuleScript): ()

  self.currentTheme = theme;
  themeChangedEvent:Fire(theme);

end;

-- @since v5.0.0
function DialogueModule:readDialogue(NPC: Model, npcSettings: Types.NPCSettings): ()

  -- Make sure we aren't already talking to an NPC
  assert(not DialogueModule.isPlayerTalkingWithNPC, "[Dialogue Maker] Cannot read dialogue because player is currently talking with another NPC.");
  DialogueModule.isPlayerTalkingWithNPC = true;

  -- Make sure we have a DialogueContainer.
  local NPCDialogueContainer: Folder? = NPC:FindFirstChild("DialogueContainer") :: Folder;
  assert(NPCDialogueContainer, "DialogueContainer not found in NPC.");

  -- Initialize the theme, then listen for changes
  local themeModuleScript = DialogueModule:getThemeModuleScript(npcSettings.general.themeName, true);
  local dialogueGUI = Instance.new("ScreenGui");
  dialogueGUI.Parent = Player.PlayerGui;
  local root = ReactRoblox.createRoot(dialogueGUI);
  self:setTheme(themeModuleScript);

  -- If necessary, end conversation if player or NPC goes out of distance
  local NPCPrimaryPart = NPC.PrimaryPart;
  local MaxConversationDistance = npcSettings.general.maxConversationDistance;
  local EndConversationIfOutOfDistance = npcSettings.general.endConversationIfOutOfDistance;
  if EndConversationIfOutOfDistance and MaxConversationDistance and NPCPrimaryPart then

    coroutine.wrap(function() 

      while task.wait() and DialogueModule.isPlayerTalkingWithNPC do

        if math.abs(NPCPrimaryPart.Position.Magnitude - Player.Character.PrimaryPart.Position.Magnitude) > MaxConversationDistance then

          DialogueModule.isPlayerTalkingWithNPC = false;
          break;

        end;

      end;

    end)();

  end;

  -- Show the dialogue to the player
  local currentDialoguePriority = "1";
  local currentContentScript: ModuleScript;
  while DialogueModule.isPlayerTalkingWithNPC and task.wait() do

    -- Get the current directory.
    currentContentScript = DialogueModule:getContentScriptFromPriority(NPCDialogueContainer, currentDialoguePriority:split("."));
    local dialogueType = currentContentScript:GetAttribute("DialogueType");

    if DialogueModule:doesPlayerPassCondition(currentContentScript) then
      
      local dialogueContentArray = (require(currentContentScript) :: () -> Types.ContentArray)();
      if dialogueType == "Redirect" then

        -- A redirect is available, so let's switch priorities.
        assert(typeof(dialogueContentArray[1]) == "string", "[Dialogue Maker] Item at index 1 is not a directory.");
        currentDialoguePriority = dialogueContentArray[1] :: string;
        continue;

      end;

      -- Get a list of responses from the dialogue.
      local responses: {ModuleScript} = {};
      for _, PossibleResponse in currentContentScript:GetChildren() do

        if PossibleResponse:IsA("ModuleScript") and tonumber(PossibleResponse.Name) and PossibleResponse:GetAttribute("DialogueType") == "Response" and DialogueModule:doesPlayerPassCondition(PossibleResponse) then

          table.insert(responses, PossibleResponse);

        end

      end

      -- Sort responses because :GetChildren() doesn't guarantee it
      table.sort(responses, function(responseScript1, responseScript2)

        return responseScript1.Name < responseScript2.Name;
  
      end);

      local onCompletionEvent = Instance.new("BindableEvent");
      local function renderRoot()

        root:render(React.createElement(require(themeModuleScript) :: any, {
          responseContentScripts = responses;
          dialogueContentArray = dialogueContentArray;
          getPages = function(textContainer: Frame, textLabel: TextLabel)
  
            return DialogueModule:getPages(dialogueContentArray, textContainer, textLabel);
  
          end;
          onComplete = function(selectedResponseContentScript: ModuleScript?)
      
            -- Run action.
            local actionScript = currentContentScript:FindFirstChild("Action") :: ModuleScript?;
            if actionScript then 
              
              (require(actionScript) :: () -> ())(); 
            
            end;
  
            -- Check if there is more dialogue.
            local hasPossibleDialogue = false;
            local nextScript = if selectedResponseContentScript then selectedResponseContentScript else currentContentScript;
            for _, possibleContentScript in nextScript:GetChildren() do
  
              local possibleDialogueType = possibleContentScript:GetAttribute("DialogueType");
              if possibleContentScript:IsA("ModuleScript") and tonumber(possibleContentScript.Name) and (possibleDialogueType == "Message" or possibleDialogueType == "Redirect") then
  
                hasPossibleDialogue = true;
                break;
  
              end
  
            end
  
            if DialogueModule.isPlayerTalkingWithNPC and hasPossibleDialogue then
  
              currentDialoguePriority = `{if selectedResponseContentScript then `{currentDialoguePriority}.{selectedResponseContentScript.Name}` else currentDialoguePriority}.1`;
  
            else
  
              dialogueGUI:Destroy();
              DialogueModule.isPlayerTakingWithNPC = false;
  
            end;
  
            onCompletionEvent:Fire();
      
          end;
          onTimeout = function()
  
            DialogueModule.isPlayerTalkingWithNPC = false;
            onCompletionEvent:Fire();
  
          end;
        }));

      end;

      local themeChangedEvent = DialogueModule.onThemeChanged:Connect(function()

        renderRoot();
    
      end);      

      renderRoot();
      onCompletionEvent.Event:Wait();
      themeChangedEvent:Disconnect();

    elseif DialogueModule.isPlayerTalkingWithNPC then

      -- There is a message; however, the player failed the condition.
      -- Let's check if there's something else available.
      local SplitPriority = currentDialoguePriority:split(".");
      SplitPriority[#SplitPriority] = tostring(tonumber(SplitPriority[#SplitPriority]) :: number + 1);
      currentDialoguePriority = table.concat(SplitPriority, ".");

    end;

  end;

  -- Free the player :)
  root:unmount();
  dialogueGUI:Destroy();
  DialogueModule.isPlayerTalkingWithNPC = false;

end;

Player.CharacterRemoving:Connect(function()

  DialogueModule.isPlayerTalkingWithNPC = false;

end);

return DialogueModule;
