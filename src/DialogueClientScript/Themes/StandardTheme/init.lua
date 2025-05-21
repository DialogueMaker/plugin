--!strict
-- BareBonesTheme is the first theme that was created for Dialogue Maker.
-- As the name describes, it is a barebones theme that priorities function over form.
-- Developers can use this theme as a template for creating their own.
--
-- Programmer: Christian Toney (Christian_Toney)

local DialogueClientScript = script.Parent.Parent;
local ReactHooks = DialogueClientScript.ReactHooks;
local React = require(DialogueClientScript.Packages.react);
local Types = require(DialogueClientScript.Types);

local MessageContainer = require(script.MessageContainer);
local ResponseContainer = require(script.ResponseContainer);
local useKeybindContinue = require(ReactHooks.useKeybindContinue);
local useOutOfDistanceDetection = require(ReactHooks.useOutOfDistanceDetection);
local useContinueDialogue = require(ReactHooks.useContinueDialogue);
local useResponses = require(ReactHooks.useResponses);

type ThemeProperties = Types.ThemeProperties;

local skipPageEvent = Instance.new("BindableEvent");

local function StandardTheme(props: ThemeProperties)

  local npc = props.npc;
  local dialogueClient = props.dialogueClient;
  local dialogueServer = props.dialogueServer;
  local dialogueServerSettings = dialogueServer:getSettings();
  local dialogueSettings = props.dialogue:getSettings();
  local npcName = dialogueServerSettings.general.name;

  local clickSoundRef = React.useRef(nil :: Sound?);

  -- States
  local currentPageIndex, setCurrentPageIndex = React.useState(1);
  local isNPCTalking, setIsNPCTalking = React.useState(false);

  -- Hooks
  local pages, setPages = React.useState({});
  local responses = useResponses(props.dialogue);
  local continueDialogue = useContinueDialogue({
    pages = pages;
    clickSoundRef = clickSoundRef;
    allowPlayerToSkipDelay = dialogueSettings.typewriter.canPlayerSkipDelay;
    currentPageIndex = currentPageIndex;
    setCurrentPageIndex = setCurrentPageIndex;
    onComplete = props.onComplete;
    skipPageEvent = skipPageEvent;
    isNPCTalking = isNPCTalking;
    hasResponses = #responses > 0;
  });
  useKeybindContinue(dialogueClient, continueDialogue);
  useOutOfDistanceDetection(npc, dialogueServer, props.onTimeout);

  React.useEffect(function()
  
    -- TODO: Implement timeout

  end, {isNPCTalking});

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
    NPCNameTextLabel = if npcName then React.createElement("TextLabel", {
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
      MessageContainer = React.createElement(MessageContainer, {
        pages = pages, 
        currentPageIndex = currentPageIndex; 
        skipPageEvent = skipPageEvent;
        setIsNPCTalking = setIsNPCTalking;
        continueDialogue = continueDialogue;
        onPagesUpdated = setPages;
        dialogue = props.dialogue;
      });
      ResponseContainer = if #responses > 0 then React.createElement("ScrollingFrame", {
        BackgroundTransparency = 1;
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder;
        });
        ResponseContainer = React.createElement(ResponseContainer, {
          responses = responses;
          onComplete = props.onComplete;
        });
      }) else nil;
      -- ContinueButton = React.createElement("ImageButton", {
      --   Size = UDim2.new(0, 20, 0, 20);
      --   LayoutOrder = 3;
      --   Image = "rbxassetid://90966430453504";
      --   BackgroundColor3 = if isNPCTalking and not npcSettings.general.allowPlayerToSkipDelay then Color3.new(0.705882, 0.705882, 0.705882) else Color3.new(1, 1, 1);
      --   ImageColor3 = if isNPCTalking and not npcSettings.general.allowPlayerToSkipDelay then Color3.new(0.486275, 0.486275, 0.486275) else Color3.new(1, 1, 1);
      --   [React.Event.Activated] = if isNPCTalking and not npcSettings.general.allowPlayerToSkipDelay then nil else function()

      --     continueDialogue()

      --   end;
      -- });
      -- ClickSound = if clientSettings.defaultClickSound then React.createElement("Sound", {
      --   SoundId = `rbxassetid://{clientSettings.defaultClickSound}`;
      --   ref = clickSoundRef;
      -- }) else nil;
    });
  })

end;

return StandardTheme;