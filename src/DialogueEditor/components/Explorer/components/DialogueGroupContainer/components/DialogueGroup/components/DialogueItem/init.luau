--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local VirtualService = require(root.VirtualService);
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useStudioIcons = require(root.DialogueEditor.hooks.useStudioIcons);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);

export type DialogueItemType = "Conversation" | "Response" | "Message" | "Redirect";

export type DialogueItemProperties = {
  type: DialogueItemType;
  dialogueScript: ModuleScript;
  dialogueScriptCount: number;
  layoutOrder: number;
}

local function DialogueItem(props: DialogueItemProperties)

  -- Replace services with VirtualService services for testing.
  -- VirtualService services are used to mock specific Roblox services in tests.
  local game = VirtualService.globals.game;
  local Selection = game:GetService("Selection");

  local dialogueType = props.type;
  local dialogueScript = props.dialogueScript;
  local dialogueScriptCount = props.dialogueScriptCount;
  local layoutOrder = props.layoutOrder;

  local icons = useStudioIcons();
  local colors = useStudioColors();
  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();

  local dialogueContent, setDialogueContent = React.useState(dialogueScript:GetAttribute("DialogueContent"));

  local incrementPriority = React.useCallback(function(increment: number)
    
    if not dialogueScript.Parent or (increment < 0 and layoutOrder <= 1) or (increment > 0 and layoutOrder >= dialogueScriptCount) then
          
      return;

    end;

    local children = dialogueScript.Parent:GetChildren();

    table.sort(children, function(dialogueScriptA, dialogueScriptB)
    
      local messageAPriority = tonumber(dialogueScriptA.Name) or math.huge;
      local messageBPriority = tonumber(dialogueScriptB.Name) or math.huge;
      
      return messageAPriority < messageBPriority;

    end);

    local index = table.find(children, dialogueScript);

    if not index or index + increment < 1 or index + increment > dialogueScriptCount then
      
      return;

    end;

    local historyIdentifier = beginHistoryRecording("Change dialogue script priority");

    table.remove(children, index);
    table.insert(children, index + increment, dialogueScript);

    for newIndex, child in children do

      if not child:IsA("ModuleScript") or not child:HasTag("DialogueMakerDialogueScript") then

        continue;

      end;
      
      child.Name = tostring(newIndex);

    end;

    finishHistoryRecording(historyIdentifier);

  end, {dialogueType :: unknown, dialogueScript, dialogueScriptCount, layoutOrder});

  local increasePriority = React.useCallback(function()
    
    incrementPriority(-1);
    
  end, {incrementPriority});

  local decreasePriority = React.useCallback(function()
    
    incrementPriority(1);
    
  end, {incrementPriority});

  local viewDialogue = React.useCallback(function()

    Selection:Set({dialogueScript});

  end, {Selection, dialogueScript});

  local isDeprioritized = (dialogueType == "Message" or dialogueType == "Redirect") and layoutOrder > 1;

  local increasePriorityButtonRef = React.useRef(nil :: ImageButton?);
  local decreasePriorityButtonRef = React.useRef(nil :: ImageButton?);
  local viewButtonRef = React.useRef(nil :: TextButton?);

  React.useEffect(function()
  
    local increasePriorityButton = increasePriorityButtonRef.current;
    local increasePriorityButtonConnection;
    if increasePriorityButton then

      increasePriorityButtonConnection = VirtualService.events.GuiButton.Activated:getSignal(increasePriorityButton):Connect(increasePriority);

    end;

    local decreasePriorityButton = decreasePriorityButtonRef.current;
    local decreasePriorityButtonConnection;
    if decreasePriorityButton then

      decreasePriorityButtonConnection = VirtualService.events.GuiButton.Activated:getSignal(decreasePriorityButton):Connect(decreasePriority);

    end;

    local viewButton = viewButtonRef.current;
    assert(viewButton, "View button reference is nil");

    local viewButtonConnection = VirtualService.events.GuiButton.Activated:getSignal(viewButton):Connect(viewDialogue);

    return function()
      
      if increasePriorityButtonConnection then

        increasePriorityButtonConnection:Disconnect();

      end;

      if decreasePriorityButtonConnection then

        decreasePriorityButtonConnection:Disconnect();

      end;
      
      viewButtonConnection:Disconnect();

    end;

  end, {increasePriority, decreasePriority, viewDialogue});

  React.useEffect(function()
  
    local dialogueContentChangedConnection = dialogueScript:GetAttributeChangedSignal("DialogueContent"):Connect(function()
      
      setDialogueContent(dialogueScript:GetAttribute("DialogueContent"));

    end);

    return function()
      
      dialogueContentChangedConnection:Disconnect();

    end;

  end, {dialogueScript});

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.Y;
    BackgroundTransparency = 1;
    Size = UDim2.fromScale(1, 0);
    LayoutOrder = layoutOrder;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 5);
      FillDirection = Enum.FillDirection.Horizontal;
      VerticalAlignment = Enum.VerticalAlignment.Center;
    });
    IncreasePriorityButton = if dialogueType ~= "Conversation" then
      React.createElement("ImageButton", {
        BackgroundTransparency = 1;
        Size = UDim2.fromOffset(20, 20);
        Image = icons.increasePriority;
        ImageTransparency = if layoutOrder <= 1 then 0.5 else 0;
        LayoutOrder = 1;
        ref = increasePriorityButtonRef;
      })
    else nil;
    DecreasePriorityButton = if dialogueType ~= "Conversation" then
      React.createElement("ImageButton", {
        BackgroundTransparency = 1;
        Size = UDim2.fromOffset(20, 20);
        Image = icons.decreasePriority;
        ImageTransparency = if layoutOrder >= dialogueScriptCount then 0.5 else 0;
        LayoutOrder = 2;
        ref = decreasePriorityButtonRef;
      })
    else nil;
    ViewButton = React.createElement("TextButton", {
      BackgroundColor3 = colors.toolbar;
      BorderSizePixel = 0;
      AutomaticSize = Enum.AutomaticSize.Y;
      Text = "";
      LayoutOrder = 3;
      ref = viewButtonRef;
    }, {
      UIFlexItem = React.createElement("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Fill;
      });
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween;
        Padding = UDim.new(0, 5);
      });
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 5);
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 15);
        PaddingRight = UDim.new(0, 15);
        PaddingTop = UDim.new(0, 15);
        PaddingBottom = UDim.new(0, 15);
      });
      InformationFrame = React.createElement("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY;
        LayoutOrder = 1;
        BackgroundTransparency = 1;
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder;
          FillDirection = Enum.FillDirection.Horizontal;
          Padding = UDim.new(0, 10);
          VerticalAlignment = Enum.VerticalAlignment.Center;
        });
        UIFlexItem = React.createElement("UIFlexItem", {
          FlexMode = Enum.UIFlexMode.Fill;
        });
        Icon = React.createElement("ImageLabel", {
          LayoutOrder = 1;
          Image = icons[`{dialogueType:sub(1, 1):lower()}{dialogueType:sub(2)}`];
          Size = UDim2.fromOffset(20, 20);
          BackgroundTransparency = 1;
          ImageColor3 = colors.text;
          ImageTransparency = if isDeprioritized then 0.5 else 0;
        });
        DescriptionLabel = React.createElement("TextLabel", {
          Text = if dialogueType == "Conversation" then dialogueScript.Name else (dialogueContent or "Nothing yet...");
          TextColor3 = colors.text;
          TextTransparency = if not isDeprioritized and (dialogueType == "Conversation" or dialogueContent) then 0 else 0.5;
          LayoutOrder = 2;
          AutomaticSize = Enum.AutomaticSize.XY;
          FontFace = Font.fromId(11702779517);
          BackgroundTransparency = 1;
          TextSize = 14;
          TextXAlignment = Enum.TextXAlignment.Left;
          TextTruncate = Enum.TextTruncate.AtEnd;
        });
      });
      Indicator = React.createElement("ImageLabel", {
        LayoutOrder = 2;
        Image = "rbxassetid://136533602473973";
        Size = UDim2.fromOffset(20, 20);
        BackgroundTransparency = 1;
      }, {
        UIFlexItem = React.createElement("UIFlexItem", {
          FlexMode = Enum.UIFlexMode.Shrink;
        });
      })
    })
  });

end;

return React.memo(DialogueItem);