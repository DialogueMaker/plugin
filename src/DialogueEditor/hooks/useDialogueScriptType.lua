--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);

export type DialogueScriptType = "Conversation" | "Message" | "Response" | "Redirect";
local function useDialogueScriptType(dialogueScript: ModuleScript?)

  local getType = React.useCallback(function(): DialogueScriptType?

    if not dialogueScript then

      return;

    end;

    if dialogueScript:HasTag("DialogueMakerConversationScript") then

      return "Conversation";

    elseif dialogueScript:HasTag("DialogueMakerDialogueScript") then
      
      return dialogueScript:GetAttribute("DialogueType") :: ("Message" | "Response" | "Redirect")?;

    end;

    return;

  end, { dialogueScript });

  local dialogueType: DialogueScriptType?, setDialogueType = React.useState(getType());

  React.useEffect(function(): ()

    if not dialogueScript then

      return;

    end;

    local typeChangedConnection = dialogueScript:GetAttributeChangedSignal("DialogueType"):Connect(function()
      
      setDialogueType(getType());
      
    end);
  
    setDialogueType(getType());

    return function()
    
      typeChangedConnection:Disconnect();
      
    end;

  end, { dialogueScript });

  return dialogueType;

end

return useDialogueScriptType;