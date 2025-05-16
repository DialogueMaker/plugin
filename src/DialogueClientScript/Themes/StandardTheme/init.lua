--!strict
-- BareBonesTheme is the first theme that was created for Dialogue Maker.
-- As the name describes, it is a barebones theme that priorities function over form.
-- Developers can use this theme as a template for creating their own.
--
-- Programmer: Christian Toney (Christian_Toney)

local MessageTextSegment = require(script.MessageTextSegment);
local MessageComponentList = require(script.MessageComponentList);
local ResponseComponentList = require(script.ResponseComponentList);
local DialogueClientScript = script.Parent.Parent;
local ReactHooks = DialogueClientScript.ReactHooks;
local React = require(DialogueClientScript.Packages.react);
local Types = require(DialogueClientScript.types);

local useKeybindContinue = require(ReactHooks.useKeybindContinue);
local useLookAtPlayer = require(ReactHooks.useLookAtPlayer);
local usePages = require(ReactHooks.usePages);
local useOutOfDistanceDetection = require(ReactHooks.useOutOfDistanceDetection);
local useContinueDialogue = require(ReactHooks.useContinueDialogue);
local useDynamicSize = require(ReactHooks.useDynamicSize);

type ThemeProperties = Types.ThemeProperties;

local skipPageEvent = Instance.new("BindableEvent");

local function StandardTheme(props: ThemeProperties)

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
  local pages = usePages(props.dialogueContentArray, textContainerRef, MessageTextSegment);
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
  local sizeX, sizeY, textSize = useDynamicSize({
    {
      sizeX = 310;
      sizeY = 117;
      textSize = 14;
    }
  });
  useKeybindContinue(clientSettings, continueDialogue);
  useLookAtPlayer(npc, npcSettings);
  useOutOfDistanceDetection(npc, npcSettings, props.onTimeout);

  return React.createElement("Frame", {
    AnchorPoint = Vector2.new(0.5, 1);
    Position = UDim2.new(0.5, 0, 1, -15);
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
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
      AutomaticSize = Enum.AutomaticSize.XY;
      Text = npcName;
      LayoutOrder = 1;
    }) else nil;
    HorizontalContent = React.createElement("Frame", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundTransparency = 1;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        Padding = UDim.new(0, 5);
        VerticalAlignment = Enum.VerticalAlignment.Bottom;
      });
      NPCTextContainer = React.createElement("Frame", {
        Size = UDim2.new(0, sizeX, 0, sizeY);
        ref = textContainerRef;
        BackgroundColor3 = Color3.new(1, 1, 1);
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder;
          FillDirection = Enum.FillDirection.Horizontal;
          Wraps = true;
        });
        UIPadding = React.createElement("UIPadding", {
          PaddingLeft = UDim.new(0, 5);
          PaddingTop = UDim.new(0, 5);
          PaddingRight = UDim.new(0, 5);
          PaddingBottom = UDim.new(0, 5);
        });
        MessageComponentList = React.createElement(MessageComponentList, {
          pages = pages, 
          currentPageIndex = currentPageIndex, 
          skipPageEvent = skipPageEvent;
          npcSettings = npcSettings;
          responseContentScripts = responseContentScripts;
          onTimeout = props.onTimeout;
          setIsNPCTalking = setIsNPCTalking;
          textSize = textSize;
        });
      });
      ResponseContainer = if #responseContentScripts > 0 then React.createElement("ScrollingFrame", {
        BackgroundTransparency = 1;
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder;
        });
        ResponseComponentList = React.createElement(ResponseComponentList, {
          responseContentScripts = props.responseContentScripts;
          onComplete = props.onComplete;
        });
      }) else nil;
      ContinueButton = React.createElement("ImageButton", {
        Size = UDim2.new(0, 20, 0, 20);
        LayoutOrder = 3;
        Image = "rbxassetid://90966430453504";
        BackgroundColor3 = if isNPCTalking and not npcSettings.general.allowPlayerToSkipDelay then Color3.new(0.705882, 0.705882, 0.705882) else Color3.new(1, 1, 1);
        ImageColor3 = if isNPCTalking and not npcSettings.general.allowPlayerToSkipDelay then Color3.new(0.486275, 0.486275, 0.486275) else Color3.new(1, 1, 1);
        [React.Event.Activated] = if isNPCTalking and not npcSettings.general.allowPlayerToSkipDelay then nil else function()

          continueDialogue()

        end;
      });
      ClickSound = if clientSettings.defaultClickSound then React.createElement("Sound", {
        SoundId = `rbxassetid://{clientSettings.defaultClickSound}`;
        ref = clickSoundRef;
      }) else nil;
    });
  })

end;

return StandardTheme;