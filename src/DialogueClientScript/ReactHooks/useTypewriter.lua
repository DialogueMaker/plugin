--!strict
local React = require(script.Parent.Parent.Packages.react);

export type TypewriterProperties = {
  text: string;
  letterDelay: number;
  skipPageEvent: RBXScriptSignal?;
  shouldUseRichText: boolean?;
  onComplete: () -> ();
};

local function useTypewriter(properties: TypewriterProperties): number
  
  local maxVisibleGraphemes, setMaxVisibleGraphemes = React.useState(0);

  React.useEffect(function()
  
    setMaxVisibleGraphemes(0);

  end, {properties.text});

  React.useEffect(function(): ()

    local typewriterTask = task.delay(properties.letterDelay, function()

      local textLabel = Instance.new("TextLabel");
      textLabel.Text = properties.text;
      textLabel.RichText = not not properties.shouldUseRichText;

      local contentText = textLabel.ContentText;
      textLabel:Destroy();

      if maxVisibleGraphemes ~= -1 and maxVisibleGraphemes < #contentText then

        setMaxVisibleGraphemes(maxVisibleGraphemes + 1);

      else

        properties.onComplete();

      end;

    end);

    if properties.skipPageEvent then

      local skipConnection = properties.skipPageEvent:Once(function()
      
        task.cancel(typewriterTask);
        setMaxVisibleGraphemes(-1);

      end);

      return function()

        skipConnection:Disconnect();

      end;

    end;

  end, {properties.text :: unknown, maxVisibleGraphemes});

  return maxVisibleGraphemes;

end;

return useTypewriter;