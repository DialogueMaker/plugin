--!strict
local root = script.Parent.Parent.Parent;
local React = require(root.Packages.react);
local DialogueItem = require(script.DialogueItem);
local useStudioColors = require(root.useStudioColors);

export type DialogueTableBodyProperties = {
  dialogueParent: ModuleScript | Folder;
  setDialogueParent: (ModuleScript | Folder) -> ();
  isDeleteModeEnabled: boolean;
  plugin: Plugin;
}

local function DialogueTableBody(props: DialogueTableBodyProperties)

  local colors = useStudioColors();

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
            key = childContentScript:GetDebugId();
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

  return if #dialogueItems > 0 then
    React.createElement("ScrollingFrame", {
      LayoutOrder = 3;
      Size = UDim2.new(1, 0, 1, 0);
      BackgroundColor3 = colors.backgroundTableRow;
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
  else (
    React.createElement("Frame", {
      LayoutOrder = 3;
      Size = UDim2.fromScale(1, 1);
      BackgroundTransparency = 1;
    }, {
      Message = React.createElement("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY;
        AnchorPoint = Vector2.new(0.5, 0.5);
        Position = UDim2.new(0.5, 0, 0.5, 0);
        Size = UDim2.new();
        BackgroundTransparency = 1;
        Text = `No dialogue found. Press the "Add message" button to start.`;
        TextColor3 = colors.textPlaceholder;
        FontFace = Font.fromId(11702779517);
        TextSize = 14;
        TextXAlignment = Enum.TextXAlignment.Center;
      }, {
        UIPadding = React.createElement("UIPadding", {
          PaddingBottom = UDim.new(0, 22);
        });
      })
    })
  )

end;

return DialogueTableBody;