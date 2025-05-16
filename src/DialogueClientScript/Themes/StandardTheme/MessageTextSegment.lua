--!strict
local DialogueClientScript = script.Parent.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);

export type TextSegmentProperties = {
  text: string;
  skipPageEvent: RBXScriptSignal?;
  letterDelay: number;
  layoutOrder: number;
  textSize: number;
  onComplete: () -> ();
}

local function MessageTextSegment(props: TextSegmentProperties)

  local text = props.text;
  local maxVisibleGraphemes, setMaxVisibleGraphemes = React.useState(0);
  local textLabelRef = React.useRef(nil :: TextLabel?);

  React.useEffect(function()
  
    setMaxVisibleGraphemes(0);

  end, {text});

  React.useEffect(function(): ()

    local typewriterTask = task.delay(props.letterDelay, function()

      local textLabel = textLabelRef.current;
      if maxVisibleGraphemes ~= -1 and textLabel and maxVisibleGraphemes < #textLabel.ContentText then

        setMaxVisibleGraphemes(maxVisibleGraphemes + 1);

      else

        props.onComplete();

      end;

    end);

    if props.skipPageEvent then

      local skipConnection = props.skipPageEvent:Once(function()
      
        task.cancel(typewriterTask);
        setMaxVisibleGraphemes(-1);

      end);

      return function()

        skipConnection:Disconnect();

      end;

    end;

  end, {maxVisibleGraphemes});

  return React.createElement("TextLabel", {
    AutomaticSize = Enum.AutomaticSize.XY;
    Text = text;
    MaxVisibleGraphemes = maxVisibleGraphemes;
    ref = textLabelRef;
    LayoutOrder = props.layoutOrder;
    FontFace = Font.fromName("Builder Sans", Enum.FontWeight.Regular);
    TextSize = props.textSize;
    BackgroundTransparency = 1;
    TextXAlignment = Enum.TextXAlignment.Left;
    TextWrapped = true;
  })

end;

return MessageTextSegment;