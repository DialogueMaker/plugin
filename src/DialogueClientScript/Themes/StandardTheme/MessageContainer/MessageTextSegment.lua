--!strict
local DialogueClientScript = script.Parent.Parent.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local useTypewriter = require(DialogueClientScript.ReactHooks.useTypewriter);
local types = require(DialogueClientScript.Types);
type TextSegmentProperties = types.TextSegmentProperties;

local function TextSegment(props: TextSegmentProperties)

  local text = props.text;
  local maxVisibleGraphemes = useTypewriter({
    text = text;
    letterDelay = props.letterDelay;
    onComplete = props.onComplete;
    textLabelRef = props.ref;
  });

  return React.createElement("TextLabel", {
    AutomaticSize = Enum.AutomaticSize.XY;
    Text = text;
    ref = props.ref;
    MaxVisibleGraphemes = maxVisibleGraphemes;
    LayoutOrder = props.layoutOrder;
    FontFace = Font.fromName("Builder Sans", Enum.FontWeight.Regular);
    TextSize = props.textSize;
    BackgroundTransparency = 1;
    TextXAlignment = Enum.TextXAlignment.Left;
    TextWrapped = true;
  })

end;

return TextSegment;