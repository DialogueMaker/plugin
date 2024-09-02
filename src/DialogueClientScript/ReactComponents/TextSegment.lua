--!strict
local React = require(script.Parent.Parent.Packages.react);

export type TextSegmentProperties = {
  text: string;
  skipEvent: RBXScriptSignal?;
  letterDelay: number;
  layoutOrder: number;
  onComplete: () -> ();
  isTest: boolean?;
}

local function TextSegment(props: TextSegmentProperties, textLabelRef: any)

  local text = props.text;
  local maxVisibleGraphemes, setMaxVisibleGraphemes = React.useState(0);
  local textLabelRefFallback = React.useRef(nil :: TextLabel?);

  React.useEffect(function(): ()

    if not props.isTest then

      local typewriterTask = task.delay(props.letterDelay, function()

        local textLabel = (textLabelRef or textLabelRefFallback).current;
        if textLabel and maxVisibleGraphemes < #textLabel.ContentText then

          setMaxVisibleGraphemes(maxVisibleGraphemes + 1);

        else

          props.onComplete();

        end;

      end);

      if props.skipEvent then

        local skipConnection = props.skipEvent:Once(function()
        
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
    TextSize = 16;
    BackgroundTransparency = 1;
    Visible = not props.isTest;
  })

end;

return React.forwardRef(TextSegment);