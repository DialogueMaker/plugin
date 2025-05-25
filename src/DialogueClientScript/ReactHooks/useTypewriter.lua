--!strict
local DialogueClientScript = script.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);

type Dialogue = IDialogue.Dialogue;

export type TypewriterProperties = {
  text: string;
  letterDelay: number;
  skipPageSignal: RBXScriptSignal?;
  shouldUseRichText: boolean?;
  onComplete: () -> ();
};

local function useTypewriter(properties: TypewriterProperties): number
  
  local maxVisibleGraphemes, setMaxVisibleGraphemes = React.useState(0);

  React.useEffect(function(): ()

    if properties.letterDelay == 0 then

      setMaxVisibleGraphemes(-1);
      properties.onComplete();

    else

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

      if properties.skipPageSignal then

        local skipConnection = properties.skipPageSignal:Once(function()
        
          task.cancel(typewriterTask);
          setMaxVisibleGraphemes(-1);

        end);

        return function()

          skipConnection:Disconnect();

        end;

      end;
      
    end;

  end, {properties.text :: unknown, maxVisibleGraphemes, properties.letterDelay});

  return maxVisibleGraphemes;

end;

return useTypewriter;