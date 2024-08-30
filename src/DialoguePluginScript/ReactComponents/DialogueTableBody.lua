--!strict
local React = require(script.Parent.Parent.Packages.react);
local DialogueItem = require(script.Parent.DialogueItem);

export type DialogueTableBodyProperties = {
  viewingPriority: string;
  dialogueParent: ModuleScript | Folder;
  dialogueContainer: Folder;
  isDeleteModeEnabled: boolean;
}

local function DialogueTableBody(props: DialogueTableBodyProperties)

  local dialogueParent = props.dialogueParent;
  local isDeleteModeEnabled = props.isDeleteModeEnabled;

  local dialogueItems, setDialogueItems = React.useState({});
  React.useEffect(function()
  
    local contentScriptConnections: {RBXScriptConnection} = {};

    local function refreshTable()

      for _, connection in contentScriptConnections do

        connection:Disconnect();

      end;

      -- Separate the dialogue item types.
      local responses: {ModuleScript} = {};
      local messages: {ModuleScript} = {};
      local redirects: {ModuleScript} = {};
      for _, PossibleDialogueItem in dialogueParent:GetChildren() do
        
        if PossibleDialogueItem:IsA("ModuleScript") and tonumber(PossibleDialogueItem.Name) then
          
          -- Get the dialogue item type.
          local DialogueType = PossibleDialogueItem:GetAttribute("DialogueType");
          table.insert(if DialogueType == "Response" then responses elseif DialogueType == "Message" then messages else redirects, PossibleDialogueItem);
          
        end
        
      end
      
      -- Sort the directory based on priority
      local function sortByMessagePriority(dialogueA: ModuleScript, dialogueB: ModuleScript)
        
        local messageAPriority = tonumber(dialogueA.Name) or math.huge;
        local messageBPriority = tonumber(dialogueB.Name) or math.huge;
        
        return messageAPriority < messageBPriority;
        
      end;
      
      table.sort(responses, sortByMessagePriority);
      table.sort(messages, sortByMessagePriority);
      table.sort(redirects, sortByMessagePriority);

      -- Create new status
      local currentZIndex = #responses + #messages + #redirects;
      local dialogueItems = {};
      local currentLayoutOrder = 1;
      for categoryIndex, category in {responses, messages, redirects} do

        for _, childContentScript in category do

          -- Make sure the message container is completely visible, even when dropdowns are open.
          local dialogueItem = React.createElement(DialogueItem, {
            type = ({"Response", "Message", "Redirect"})[categoryIndex];
            layoutOrder = currentLayoutOrder;
            zIndex = currentZIndex;
            contentScript = childContentScript;
            isDeleteModeEnabled = isDeleteModeEnabled;
            priority = childContentScript.Name;
            dialogueContainer = props.dialogueContainer;
          });

          table.insert(dialogueItems, dialogueItem);

          currentZIndex -= 1;
          currentLayoutOrder += 1;

          table.insert(contentScriptConnections, childContentScript:GetPropertyChangedSignal("Name"):Connect(refreshTable));

        end;

      end;
      setDialogueItems(dialogueItems);

    end;
    
    local childAddedEvent = dialogueParent.ChildAdded:Connect(refreshTable);
    local childRemovedEvent = dialogueParent.ChildRemoved:Connect(refreshTable);
    refreshTable();

    return function()

      childAddedEvent:Disconnect();
      childRemovedEvent:Disconnect();

    end;

  end, {dialogueParent :: any, isDeleteModeEnabled});

  return React.createElement("ScrollingFrame", {}, {
    React.createElement("UIListLayout", {
      Name = "UIListLayout"
    });
    dialogueItems;
  })

end;

return DialogueTableBody;