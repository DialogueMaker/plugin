--!strict

local TweenService = game:GetService("TweenService");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local DialogueGroupContainer = require(script.components.DialogueGroupContainer);
local Preview = require(script.components.Preview);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useDialogueScriptType = require(root.DialogueEditor.hooks.useDialogueScriptType);
local useDialogueMakerScriptSelection = require(root.DialogueEditor.hooks.useDialogueMakerScriptSelection);

type DialogueScriptType = useDialogueScriptType.DialogueScriptType;

export type DialogueTableProperties = {
  plugin: Plugin;
  setSettingsTarget: (target: ModuleScript?) -> ();
  layoutOrder: number;
}

local function Explorer(props: DialogueTableProperties)

  local plugin = props.plugin;
  local selectedScript = useDialogueMakerScriptSelection();
  local setSettingsTarget = props.setSettingsTarget;
  local layoutOrder = props.layoutOrder;
  local colors = useStudioColors();
  local dialogueScriptType: DialogueScriptType? = useDialogueScriptType(selectedScript) :: DialogueScriptType?;
  local ref = React.useRef(nil :: ScrollingFrame?);

  React.useEffect(function()

    if not ref.current then

      return;

    end;

    ref.current.CanvasPosition = Vector2.new(0, 0);

    local tween: Tween?;
    local tweenTask: thread?;
    local function resetTween()

      if tweenTask then
        
        task.cancel(tweenTask);
        tweenTask = nil;

      end;

      if tween then
        
        tween:Cancel();
        tween = nil;

      end;

      ref.current.ScrollBarImageTransparency = 0;

      tweenTask = task.delay(3, function()
      
        local newTween = TweenService:Create(ref.current, TweenInfo.new(), {
          ScrollBarImageTransparency = 0.55;
        });
        tween = newTween;
        
        newTween:Play();

      end);
      
    end;

    local scrollingPositionConnection = ref.current:GetPropertyChangedSignal("CanvasPosition"):Connect(resetTween);
    resetTween();

    return function()

      if tween then
        
        tween:Cancel();
        tween = nil;

      end;

      if tweenTask then
        
        task.cancel(tweenTask);
        tweenTask = nil;

      end;

      scrollingPositionConnection:Disconnect();

    end;

  end, {selectedScript});

  return React.createElement("ScrollingFrame", {
    Size = UDim2.fromScale(1, 1);
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
    AutomaticCanvasSize = Enum.AutomaticSize.Y;
    CanvasSize = UDim2.fromScale(1, 0);
    ScrollingDirection = Enum.ScrollingDirection.Y;
    BorderSizePixel = 0;
    ScrollBarImageColor3 = colors.toolbar;
    ref = ref;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      HorizontalAlignment = Enum.HorizontalAlignment.Center;
    });
    UIFlexItem = React.createElement("UIFlexItem", {
      FlexMode = Enum.UIFlexMode.Shrink;
    });
    Content = React.createElement("Frame", {
      Size = UDim2.fromScale(1, 1);
      AutomaticSize = Enum.AutomaticSize.Y;
      BackgroundTransparency = 1;
    }, {
      UISizeConstraint = React.createElement("UISizeConstraint", {
        MaxSize = Vector2.new(750, math.huge);
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 15);
        PaddingRight = UDim.new(0, 15);
        PaddingTop = UDim.new(0, 15);
        PaddingBottom = UDim.new(0, 15);
      });
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 15);
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
      });
      Preview = if selectedScript then
        React.createElement(Preview, {
          layoutOrder = 1;
          selectedScript = selectedScript;
          dialogueScriptType = dialogueScriptType;
          plugin = plugin;
        })
      else nil;
      DialogueGroupContainer = if dialogueScriptType ~= "Redirect" then
        React.createElement(DialogueGroupContainer, {
          selectedScript = selectedScript;
          layoutOrder = 2;
          plugin = plugin;
          setSettingsTarget = setSettingsTarget;
        })
      else nil;
    });
  })

end;

return React.memo(Explorer);