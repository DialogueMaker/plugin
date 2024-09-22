--!strict
local React = require(script.Parent.Parent.Parent.Parent.Packages.react);

export type TextSegmentProperties = {
  text: string;
  skipPageEvent: RBXScriptSignal?;
  letterDelay: number;
  layoutOrder: number;
  textSize: number;
  onComplete: () -> ();
  isTest: boolean?;
}

local function TextSegment(props: TextSegmentProperties, textLabelRef: any)

  local text = props.text;
  local maxVisibleGraphemes, setMaxVisibleGraphemes = React.useState(0);
  local textLabelRefFallback = React.useRef(nil :: TextLabel?);

  React.useEffect(function()
  
    setMaxVisibleGraphemes(0);

  end, {text});

  React.useEffect(function(): ()

    if not props.isTest then

      local typewriterTask = task.delay(props.letterDelay, function()

        local textLabel = (textLabelRef or textLabelRefFallback).current;
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

    end;

  end, {maxVisibleGraphemes});

  return React.createElement("TextLabel", {
    AutomaticSize = Enum.AutomaticSize.XY;
    Text = text;
    MaxVisibleGraphemes = maxVisibleGraphemes;
    ref = textLabelRef or textLabelRefFallback;
    LayoutOrder = props.layoutOrder;
    FontFace = Font.fromId(11702779517, Enum.FontWeight.Regular);
    TextSize = props.textSize;
    BackgroundTransparency = 1;
    Visible = not props.isTest;
    TextXAlignment = Enum.TextXAlignment.Left;
    TextWrapped = true;
  })

end;

return React.forwardRef(TextSegment);