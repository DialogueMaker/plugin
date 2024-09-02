--!strict
-- BareBonesDialogue is the first theme that was created for Dialogue Maker.
-- As the name describes, it is a barebones theme that priorities function over form.
-- Developers can use this theme as a template for creating their own.
-- Programmer: Christian Toney (Christian_Toney)
local TextSegment = require(script.TextSegment);
local ResponseButton = require(script.ResponseButton);
local MessageComponentList = require(script.MessageComponentList);
local ResponseComponentList = require(script.ResponseComponentList);
local DialogueClientScript = script.Parent.Parent.Parent;
local ReactHooks = DialogueClientScript.ReactHooks;
local useKeybindContinue = require(ReactHooks.useKeybindContinue);
local useLookAtPlayer = require(ReactHooks.useLookAtPlayer);
local usePages = require(ReactHooks.usePages);
local useOutOfDistanceDetection = require(ReactHooks.useOutOfDistanceDetection);
local useContinueDialogue = require(ReactHooks.useContinueDialogue);
local React = require(DialogueClientScript.Packages.react);
local Types = require(DialogueClientScript.Types);
type ThemeProperties = Types.ThemeProperties;

local skipPageEvent = Instance.new("BindableEvent");

local function BareBonesTheme(props: ThemeProperties)

  -- Props
  local npc = props.npc;
  local clientSettings = props.clientSettings;
  local npcSettings = props.npcSettings;
  local npcName = npcSettings.general.npcName;
  local responseContentScripts = props.responseContentScripts;

  -- Refs
  local clickSoundRef = React.useRef(nil :: Sound?);
  local textContainerRef = React.useRef(nil :: GuiObject?);

  -- States
  local currentPageIndex, setCurrentPageIndex = React.useState(1);
  local isNPCTalking, setIsNPCTalking = React.useState(false);

  -- Hooks
  local pages = usePages(props.dialogueContentArray, textContainerRef);
  local continueDialogue = useContinueDialogue({
    pages = pages;
    clickSoundRef = clickSoundRef;
    allowPlayerToSkipDelay = npcSettings.general.allowPlayerToSkipDelay;
    currentPageIndex = currentPageIndex;
    setCurrentPageIndex = setCurrentPageIndex;
    onComplete = props.onComplete;
    skipPageEvent = skipPageEvent;
    isNPCTalking = isNPCTalking;
    responseContentScripts = responseContentScripts;
  });
  useKeybindContinue(clientSettings, continueDialogue);
  useLookAtPlayer(npc, npcSettings);
  useOutOfDistanceDetection(npc, npcSettings, props.onTimeout);

  return React.createElement("Frame", {
    Position = UDim2.new(0.03, 0, 0.599, 0);
    Size = UDim2.new(0.938, 0, 0.356, 0);
    BackgroundColor3 = Color3.new(1, 1, 1);
    [React.Event.InputBegan] = function(self: Frame, input: InputObject)

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
      Size = UDim2.new(0.945, 0, 0.713, 0);
      AutomaticSize = Enum.AutomaticSize.XY;
      ref = textContainerRef;
      LayoutOrder = 2;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        Wraps = true;
      });
      TestSegment = React.createElement(TextSegment, {
        isTest = true;
      });
      MessageComponentList = React.createElement(MessageComponentList, {
        pages = pages, 
        currentPageIndex = currentPageIndex, 
        skipPageEvent = skipPageEvent;
        npcName = npcName;
        textSegmentComponent = TextSegment;
        npcSettings = npcSettings;
        responseContentScripts = responseContentScripts;
        onTimeout = props.onTimeout;
        setIsNPCTalking = setIsNPCTalking;
      });
    });
    ResponseContainer = if responseContentScripts then React.createElement("ScrollingFrame", {

    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      ResponseComponentList = React.createElement(ResponseComponentList, {
        responseButtonComponent = ResponseButton; 
        responseContentScripts = props.responseContentScripts;
        onComplete = props.onComplete;
      });
    }) else nil;
    ContinueButton = React.createElement("ImageButton", {
      Visible = not isNPCTalking;
    });
    ClickSound = if clientSettings.defaultClickSound then React.createElement("Sound", {
      SoundId = `rbxassetid://{clientSettings.defaultClickSound}`;
      ref = clickSoundRef;
    }) else nil;
  })

end;

return BareBonesTheme;