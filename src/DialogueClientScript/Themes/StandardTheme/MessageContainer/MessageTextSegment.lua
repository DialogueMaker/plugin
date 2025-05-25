--!strict
local DialogueClientScript = script.Parent.Parent.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local useTypewriter = require(DialogueClientScript.ReactHooks.useTypewriter);
local types = require(DialogueClientScript.Types);
type TextComponentProperties = types.TextComponentProperties;

local function TextSegment(props: TextComponentProperties)

  local ref = React.useRef(nil :: TextLabel?);

  local text = props.text;
  local maxVisibleGraphemes = useTypewriter({
    text = text;
    letterDelay = props.letterDelay;
    onComplete = props.onComplete;
    skipPageEvent = props.skipPageEvent;
  });

  return React.createElement("TextLabel", {
    AutomaticSize = Enum.AutomaticSize.XY;
    Text = text;
    ref = props.ref2 or ref;
    MaxVisibleGraphemes = maxVisibleGraphemes;
    LayoutOrder = props.layoutOrder;
    FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
    TextSize = props.textSize;
    BackgroundTransparency = 1;
    TextXAlignment = Enum.TextXAlignment.Left;
    TextWrapped = true;
    TextColor3 = Color3.new(1, 1, 1);
  })

end;

return TextSegment;