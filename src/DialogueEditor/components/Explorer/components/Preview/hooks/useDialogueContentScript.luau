--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);

local function useDialogueContentScript(dialogueScript: ModuleScript): (ModuleScript?, boolean)

  local getDialogueContentScript = React.useCallback(function(): ModuleScript?
  
    local contentScript = dialogueScript:FindFirstChild("ContentScript");
    if contentScript and contentScript:IsA("ModuleScript") then
    
      return contentScript;
    
    end

    return;

  end, { dialogueScript });

  local dialogueContentScript: ModuleScript?, setDialogueContentScript = React.useState(getDialogueContentScript());
  local isEnabled, setIsEnabled = React.useState(if dialogueContentScript then not dialogueContentScript:GetAttribute("IsDisabled") else false);

  React.useEffect(function()

    local function updateDialogueContentScript()

      setDialogueContentScript(getDialogueContentScript());

    end

    local childAddedConnection = dialogueScript.ChildAdded:Connect(updateDialogueContentScript);
    local childRemovedConnection = dialogueScript.ChildRemoved:Connect(updateDialogueContentScript);
    task.spawn(updateDialogueContentScript);

    return function()

      childAddedConnection:Disconnect();
      childRemovedConnection:Disconnect();

    end;
  
  end, { dialogueScript });

  React.useEffect(function()

    if not dialogueContentScript then
      
      setIsEnabled(false);
      return;
    
    end;

    local attributeChangedConnection = dialogueContentScript:GetAttributeChangedSignal("IsDisabled"):Connect(function()

      setIsEnabled(not dialogueContentScript:GetAttribute("IsDisabled"));

    end);

    setIsEnabled(not dialogueContentScript:GetAttribute("IsDisabled"));

    return function()

      attributeChangedConnection:Disconnect();

    end;
  
  end, { dialogueContentScript });

  return dialogueContentScript, isEnabled;

end;

return useDialogueContentScript;