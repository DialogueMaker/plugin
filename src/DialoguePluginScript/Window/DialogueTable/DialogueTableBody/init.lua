--!strict
local root = script.Parent.Parent.Parent;
local React = require(root.Packages.react);
local Colors = require(root.Colors);
local DialogueItem = require(script.DialogueItem);

export type DialogueTableBodyProperties = {
  dialogueParent: ModuleScript | Folder;
  setDialogueParent: (ModuleScript | Folder) -> ();
  isDeleteModeEnabled: boolean;
  plugin: Plugin;
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
      
      table.sort(redirects, sortByMessagePriority);
      table.sort(responses, sortByMessagePriority);
      table.sort(messages, sortByMessagePriority);

      -- Create new status
      local currentZIndex = #redirects + #responses + #messages;
      local dialogueItems = {};
      local currentLayoutOrder = 1;
      for categoryIndex, category in {redirects, responses, messages} do

        for _, childContentScript in category do

          -- Make sure the message container is completely visible, even when dropdowns are open.
          local dialogueItem = React.createElement(DialogueItem, {
            type = ({"Redirect", "Response", "Message"})[categoryIndex];
            layoutOrder = currentLayoutOrder;
            zIndex = currentZIndex;
            contentScript = childContentScript;
            isDeleteModeEnabled = isDeleteModeEnabled;
            priority = childContentScript.Name;
            dialogueParent = dialogueParent;
            setDialogueParent = props.setDialogueParent;
            plugin = props.plugin;
          });

          table.insert(dialogueItems, dialogueItem);

          currentZIndex -= 1;
          currentLayoutOrder += 1;

          table.insert(contentScriptConnections, childContentScript:GetPropertyChangedSignal("Name"):Connect(refreshTable));
          table.insert(contentScriptConnections, childContentScript:GetAttributeChangedSignal("DialogueType"):Connect(refreshTable));

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

  return React.createElement("ScrollingFrame", {
    LayoutOrder = 2;
    Size = UDim2.new(1, 0, 1, 0);
    BackgroundColor3 = Colors.backgroundTableRow;
    BorderSizePixel = 0;
    AutomaticCanvasSize = Enum.AutomaticSize.Y;
    CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingDirection = Enum.ScrollingDirection.Y;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    UIFlexItem = React.createElement("UIFlexItem", {
      FlexMode = Enum.UIFlexMode.Shrink;
    });
    Children = React.createElement(React.Fragment, {}, {dialogueItems});
  })

end;

return DialogueTableBody;