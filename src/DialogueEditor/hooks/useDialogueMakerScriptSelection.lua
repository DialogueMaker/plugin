--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);

local function useDialogueMakerScriptSelection()

  local selectedScript, setSelectedScript = React.useState(nil :: ModuleScript?);
  local conversationScript, setConversationScript = React.useState(nil :: ModuleScript?);

  React.useEffect(function()
  
    local function checkSelection()

      local selection = Selection:Get();
      if #selection == 1 then

        local selectedInstance = selection[1];
        local isSelectionAModuleScript = selectedInstance:IsA("ModuleScript");
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

        setConversationScript(conversationScript);
        setSelectedScript(selectedScript);

      elseif #selection == 0 then

        setConversationScript(nil);
        setSelectedScript(nil);

      end

    end;

    local selectionChangedConnection = Selection.SelectionChanged:Connect(checkSelection);
    task.spawn(checkSelection);

    return function()

      selectionChangedConnection:Disconnect();

    end;

  end, {});

  return selectedScript, conversationScript;

end;

return useDialogueMakerScriptSelection;