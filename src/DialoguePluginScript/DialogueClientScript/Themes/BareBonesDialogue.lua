local useKeybindContinue = require(script.Parent.Parent.ReactEffects.useKeybindContinue);
local useLookAtPlayer = require(script.Parent.Parent.ReactEffects.useLookAtPlayer);
local React = require(script.Parent.Parent.Parent.Packages.react);
local Types = require(script.Parent.Parent.Types);
type ThemeProperties = Types.ThemeProperties;

type ResponseProperties = {
  onClick: () -> ();
  text: string;
}

local function TextSegment()

end;

local function ResponseButton(props: ResponseProperties)

  return React.createElement("TextButton", {
    [React.Event.Activated] = props.onClick;
    Text = props.text;
  });

end;

local function BareBonesDialogue(props: ThemeProperties)

  local npc = props.npc;
  local dialogueContentArray = props.dialogueContentArray;
  local clientSettings = props.clientSettings;
  local npcSettings = props.npcDialogueSettings;
  local npcName = npcSettings.general.npcName;
  local responseContentScripts = props.responseContentScripts;

  local pages, setPages = React.useState(nil);
  local isNPCTalking, setIsNPCTalking = React.useState(false);
  local currentPageIndex, setCurrentPageIndex = React.useState(1);
  local isClickToContinueButtonVisible, setIsClickToContinueButtonVisible = React.useState(false);
  local messageComponents, setMessageComponents = React.useState({});
  
  local skipPageEventRef = React.useRef(nil :: BindableEvent?);
  local textContainerRef = React.useRef(nil :: Frame?);
  local clickSoundRef = React.useRef(nil :: Sound?);
  local textSegmentRef = React.useRef(nil :: TextLabel?);

  React.useState(React.createElement("BindableEvent", {
    ref = skipPageEventRef;
  }));

  React.useState(React.createElement(TextSegment, {
    ref = textSegmentRef;
  }));

  local function continueDialogue()

    setIsClickToContinueButtonVisible(false);

    if isNPCTalking then

      local clickSound = clickSoundRef.current;
      if clickSound then

        clickSound:Play();

      end;

      local skipPageEvent = skipPageEventRef.current;
      if npcSettings.general.allowPlayerToSkipDelay and skipPageEvent then
        
        skipPageEvent:Fire();

      end;

    elseif #pages > currentPageIndex then

      setCurrentPageIndex(currentPageIndex + 1);

    elseif #responseContentScripts == 0 then	

      props.onComplete();

    end;

  end;

  useKeybindContinue(clientSettings, continueDialogue);
  useLookAtPlayer(npc, npcSettings);

  React.useEffect(function()
  
    local pages = props.getPages(textContainerRef.current, textSegmentRef.current);
    setPages(pages);

  end, {dialogueContentArray});

  React.useEffect(function()
    
    if pages then

      local page = pages[currentPageIndex];
        
      -- Listen for page skip via user inputs.
      local isSkippingPage = false;
      local skipPageEvent = skipPageEventRef.current;
      local skipPageConnection;
      if skipPageEvent then

        skipPageConnection = skipPageEvent.Event:Once(function()
        
          isSkippingPage = true;

        end);

      end;

      -- Iterate through the page, run events, and show message text.
      for dialogueContentItemIndex, dialogueContentItem in page do
        
        if dialogueContentItem.type == "effect" then

          -- The item is an effect. Let's run it.
          print(`[Dialogue Maker] [{dialogueContentItemIndex}/{#page}] [Effect] {npcName or "Unknown NPC"}: {dialogueContentItem.name}`);
          dialogueContentItem.run(isSkippingPage);

        elseif dialogueContentItem.type == "text" then
          
          -- Print to the debug console.
          print(`[Dialogue Maker] [{dialogueContentItemIndex}/{#page}] [Message] {npcName or "Unknown NPC"}: {dialogueContentItem.text}`);
          
          -- Determine new offset.
          local segment = segmentRef.current :: TextLabel;
          segment.Text = dialogueContentItem.text;
          segment.Size = dialogueContentItem.size;
          
          for count = 1, #segment.ContentText do

            if isSkippingPage then

              segment.MaxVisibleGraphemes = -1;
              break;

            end;

            segment.MaxVisibleGraphemes = count;

            task.wait(npcSettings.general.letterDelay);

            if segment.MaxVisibleGraphemes == -1 then 

              break;

            end

          end;

        end;
        
      end
      
      -- Check if there are more pages.
      if pages[currentPageIndex + 1] and isNPCTalking then

        -- Wait for the player to click
        setIsClickToContinueButtonVisible(true);

      end;
      setIsNPCTalking(false);
      isSkippingPage = false;
      skipPageConnection:Disconnect();

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

        return;

      end;

    end;

    return;

  end, {pages, currentPageIndex});

  local responseComponents, setResponseComponents = React.useState({});
  React.useEffect(function()
  
    -- Add response buttons
    local newResponseComponents = {};
    for _, responseModule in responseContentScripts do

      table.insert(newResponseComponents, React.createElement(ResponseButton, {
        text = require(responseModule)()[1]; -- The response's text is always at the first index.
        onClick = function()

          props.onComplete(responseModule);

        end;
      }))

    end;
    setResponseComponents(responseComponents);

  end, {responseContentScripts});

  return React.createElement("Frame", {
    [React.Event.InputBegan] = function(input)

      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
          
        continueDialogue();

      end;

    end;
  }, {
    NPCNameTextLabel = if npcSettings.general.showName then React.createElement("TextLabel", {
      AutomaticSize = if npcSettings.general.fitName then Enum.AutomaticSize.X else Enum.AutomaticSize.None;
      Size = if npcSettings.general.fitName then UDim2.new(0, 0, 0, 0) else UDim2.new();
      Text = npcName;
    }) else nil;
    NPCTextContainer = React.createElement("Frame", {
      ref = textContainerRef;
      Size = UDim2.new(0, 0, 0, 0);
      AutomaticSize = Enum.AutomaticSize.XY;
    }, {
      messageComponents;
    });
    ResponseContainer = if responseContentScripts then React.createElement("ScrollingFrame", {

    }, {
      responseComponents;
    }) else nil;
    ContinueButton = React.createElement("ImageButton", {
      Visible = isClickToContinueButtonVisible;
    });
    ClickSound = if clientSettings.defaultClickSound then React.createElement("Sound", {
      SoundId = `rbxassetid://{clientSettings.defaultClickSound}`;
      ref = clickSoundRef;
    }) else nil;
  })

end;
return BareBonesDialogue;