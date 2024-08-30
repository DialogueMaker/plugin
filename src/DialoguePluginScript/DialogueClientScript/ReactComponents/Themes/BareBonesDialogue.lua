--!strict
-- BareBonesDialogue is the first theme that was created for Dialogue Maker.
-- As the name describes, it is a barebones theme that priorities function over form.
-- Developers can use this theme as a template for creating their own.
-- Programmer: Christian Toney (Christian_Toney)
local ReactComponents = script.Parent.Parent;
local TextSegment = require(ReactComponents.TextSegment);
local ResponseButton = require(ReactComponents.ResponseButton);
local DialogueClientScript = ReactComponents.Parent;
local ReactHooks = DialogueClientScript.ReactHooks;
local useKeybindContinue = require(ReactHooks.useKeybindContinue);
local useLookAtPlayer = require(ReactHooks.useLookAtPlayer);
local usePages = require(ReactHooks.usePages);
local useMessageComponents = require(ReactHooks.useMessageComponents);
local useResponseComponents = require(ReactHooks.useResponseComponents);
local React = require(DialogueClientScript.Parent.Packages.react);
local Types = require(DialogueClientScript.Types);
type ThemeProperties = Types.ThemeProperties;

local function BareBonesDialogue(props: ThemeProperties)

  -- Props
  local npc = props.npc;
  local clientSettings = props.clientSettings;
  local npcSettings = props.npcDialogueSettings;
  local npcName = npcSettings.general.npcName;
  local responseContentScripts = props.responseContentScripts;

  -- Refs
  local skipPageEventRef = React.useRef(nil :: BindableEvent?);
  local textContainerRef = React.useRef(nil :: Frame?);
  local clickSoundRef = React.useRef(nil :: Sound?);

  -- States
  local currentPageIndex, setCurrentPageIndex = React.useState(1);
  local isClickToContinueButtonVisible, setIsClickToContinueButtonVisible = React.useState(false);
  React.useState(React.createElement("BindableEvent", {
    ref = skipPageEventRef;
  }));

  -- Hooks
  local pages = usePages(props.dialogueContentArray, textContainerRef, TextSegment);
  local messageComponents, isNPCTalking = useMessageComponents({
    pages = pages, 
    currentPageIndex = currentPageIndex, 
    skipPageEventRef = skipPageEventRef;
    npcName = npcName;
    textSegmentComponent = TextSegment;
    npcSettings = npcSettings;
    responseContentScripts = responseContentScripts;
    onTimeout = props.onTimeout;
    setIsClickToContinueButtonVisible = setIsClickToContinueButtonVisible;
  });
  local responseComponents = useResponseComponents(ResponseButton, props.responseContentScripts, props.onComplete);

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

    elseif pages and #pages > currentPageIndex then

      setCurrentPageIndex(currentPageIndex + 1);

    elseif #responseContentScripts == 0 then	

      props.onComplete();

    end;

  end;

  useKeybindContinue(clientSettings, continueDialogue);
  useLookAtPlayer(npc, npcSettings);

  return React.createElement("Frame", {
    [React.Event.InputBegan] = function(input)

      if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
          
        continueDialogue();

      end;

    end;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    NPCNameTextLabel = if npcSettings.general.showName then React.createElement("TextLabel", {
      AutomaticSize = if npcSettings.general.fitName then Enum.AutomaticSize.X else Enum.AutomaticSize.None;
      Size = if npcSettings.general.fitName then UDim2.new(0, 0, 0, 0) else UDim2.new();
      Text = npcName;
      LayoutOrder = 1;
    }) else nil;
    NPCTextContainer = React.createElement("Frame", {
      ref = textContainerRef;
      Size = UDim2.new(0, 0, 0, 0);
      AutomaticSize = Enum.AutomaticSize.XY;
      LayoutOrder = 2;
    }, {
      React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        Wraps = true;
        Name = "UIListLayout";
      });
      messageComponents;
    });
    ResponseContainer = if responseContentScripts then React.createElement("ScrollingFrame", {

    }, {
      React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        Name = "UIListLayout";
      });
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