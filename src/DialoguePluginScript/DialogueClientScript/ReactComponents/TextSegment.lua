--!strict
local React = require(script.Parent.Parent.Parent.Packages.react)

export type TextSegmentProperties = {
  text: string;
  skipEvent: RBXScriptSignal;
  letterDelay: number;
  layoutOrder: number;
}

local function TextSegment(props: TextSegmentProperties)

  local text = props.text;
  local textLabelRef = React.useRef(nil :: TextLabel?);
  local maxVisibleGraphemes, setMaxVisibleGraphemes = React.useState(0);

  React.useEffect(function()

    local typewriterTask = task.delay(props.letterDelay, function()

      local textLabel = textLabelRef.current;
      if textLabel and maxVisibleGraphemes < #textLabel.ContentText then

        setMaxVisibleGraphemes(maxVisibleGraphemes + 1);

      end;

    end);

    local skipConnection = props.skipEvent:Once(function()
    
      task.cancel(typewriterTask);
      setMaxVisibleGraphemes(-1);

    end);

    return function()

      skipConnection:Disconnect();

    end;

  end, {maxVisibleGraphemes});

  return React.createElement("TextLabel", {
    AutomaticSize = Enum.AutomaticSize.XY;
    Text = text;
    MaxVisibleGraphemes = maxVisibleGraphemes;
    ref = textLabelRef;
    layoutOrder = props.layoutOrder;
  })

end;

return TextSegment;