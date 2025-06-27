--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local VirtualService = require(root.VirtualService);

local function useDialogueMakerScriptSelection()

  Selection = if VirtualService.mocks.isEnabled then VirtualService.mocks.services.Selection else Selection;

  local getScripts = React.useCallback(function()

    local selection = Selection:Get();
    if #selection ~= 1 then

      return nil, nil;

    end;

    local selectedInstance = selection[1];
    local isSelectionAModuleScript = selectedInstance:IsA("ModuleScript");

    if not isSelectionAModuleScript and selectedInstance:IsA("Folder") and selectedInstance.Parent and selectedInstance.Parent:IsA("ModuleScript") then

      selectedInstance = selectedInstance.Parent;
      isSelectionAModuleScript = true;

    end;

    local conversationScript = if isSelectionAModuleScript and selectedInstance:HasTag("DialogueMakerConversationScript") then selectedInstance else nil;
    if not conversationScript then

      local parent = selectedInstance.Parent;
      while parent do

        if not parent:IsA("ModuleScript") then
          
          break;

        end;
        
        if parent:HasTag("DialogueMakerConversationScript") then
          
          conversationScript = parent;
          break;

        end;
        
        parent = parent.Parent;
      
      end;

    end;

    local selectedScript = if conversationScript == selectedInstance or (isSelectionAModuleScript and selectedInstance:HasTag("DialogueMakerDialogueScript")) then selectedInstance else nil;

    return selectedScript, conversationScript;

  end, {});
  local initialSelectedScript, initialConversationScript = React.useMemo(getScripts, {});
  local selectedScript, setSelectedScript = React.useState(initialSelectedScript);
  local conversationScript, setConversationScript = React.useState(initialConversationScript);

  React.useEffect(function()

    local function checkSelection()

      local newSelectedScript, newConversationScript = getScripts();

      if newSelectedScript ~= selectedScript then

        setSelectedScript(newSelectedScript);

      end;

      if newConversationScript ~= conversationScript then

        setConversationScript(newConversationScript);

      end;

    end;

    local selectionChangedConnection = Selection.SelectionChanged:Connect(checkSelection);
    task.spawn(checkSelection);

    return function()

      selectionChangedConnection:Disconnect();

    end;

  end, {selectedScript, conversationScript});

  return selectedScript, conversationScript;

end;

return useDialogueMakerScriptSelection;