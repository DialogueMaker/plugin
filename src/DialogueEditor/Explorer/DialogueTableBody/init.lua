--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local DialogueItem = require(script.DialogueItem);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useRefreshDialogueMakerScripts = require(root.DialogueEditor.hooks.useRefreshDialogueMakerScripts);

export type DialogueTableBodyProperties = {
  selectedScript: ModuleScript?;
  plugin: Plugin;
  setSettingsTarget: (target: ModuleScript?) -> ();
}

local function DialogueTableBody(props: DialogueTableBodyProperties)

  local selectedScript = props.selectedScript;
  local setSettingsTarget = props.setSettingsTarget;

  local colors = useStudioColors();
  local refreshDialogueMakerScripts = useRefreshDialogueMakerScripts();

  local conversations, setConversations = React.useState({} :: {ModuleScript});
  local redirects, setRedirects = React.useState({} :: {ModuleScript});
  local responses, setResponses = React.useState({} :: {ModuleScript});
  local messages, setMessages = React.useState({} :: {ModuleScript});
  

  React.useEffect(function(): ()
  
    local contentScriptConnections: {RBXScriptConnection} = {};

    local function cleanupConnections()
      
      for _, connection in contentScriptConnections do
        
        connection:Disconnect();
        
      end;

      contentScriptConnections = {};

    end;

    local function refreshTable()

      cleanupConnections();
      refreshDialogueMakerScripts();

      -- Separate the dialogue item types.
      local conversations: {ModuleScript} = {};
      local responses: {ModuleScript} = {};
      local messages: {ModuleScript} = {};
      local redirects: {ModuleScript} = {};

      if selectedScript then

        for _, possibleDialogueScript in selectedScript:GetChildren() do
          
          if possibleDialogueScript:IsA("ModuleScript") then

            if possibleDialogueScript:HasTag("DialogueMakerDialogueScript") then
            
              local dialogueType = possibleDialogueScript:GetAttribute("DialogueType");
              local targetTable = if dialogueType == "Message" then messages elseif dialogueType == "Response" then responses else redirects;
              table.insert(targetTable, possibleDialogueScript);
              table.insert(contentScriptConnections, possibleDialogueScript:GetAttributeChangedSignal("DialogueType"):Connect(refreshTable));
              table.insert(contentScriptConnections, possibleDialogueScript:GetAttributeChangedSignal("DialogueContent"):Connect(refreshTable));
            
            else
            
              warn(`{possibleDialogueScript:GetFullName()} is not a valid DialogueMaker script.`);
              continue;

            end;

            table.insert(contentScriptConnections, possibleDialogueScript:GetPropertyChangedSignal("Name"):Connect(refreshTable));

          end
          
        end;

      else
        
        local selection = Selection:Get();
        if #selection == 1 then

          for _, possibleConversationScript in selection[1]:GetChildren() do

            if possibleConversationScript:IsA("ModuleScript") and possibleConversationScript:HasTag("DialogueMakerConversationScript") then
              
              table.insert(conversations, possibleConversationScript);
            
            end;

          end;

        end;

      end;

      local function sortByMessagePriority(dialogueA: ModuleScript, dialogueB: ModuleScript)
        
        local messageAPriority = tonumber(dialogueA.Name) or math.huge;
        local messageBPriority = tonumber(dialogueB.Name) or math.huge;
        
        return messageAPriority < messageBPriority;
        
      end;
      
      table.sort(conversations, sortByMessagePriority);
      table.sort(redirects, sortByMessagePriority);
      table.sort(responses, sortByMessagePriority);
      table.sort(messages, sortByMessagePriority);
      
      setConversations(conversations);
      setRedirects(redirects);
      setResponses(responses);
      setMessages(messages);

    end;
    
    local selection = Selection:Get();
    if selection[1] then

      local childAddedEvent = selection[1].ChildAdded:Connect(refreshTable);
      local childRemovedEvent = selection[1].ChildRemoved:Connect(refreshTable);
      refreshTable();

      return function()

        cleanupConnections();
        childAddedEvent:Disconnect();
        childRemovedEvent:Disconnect();

      end;

    end;

  end, {selectedScript});

  -- Create new status
  local currentZIndex = #redirects + #responses + #messages;
  local dialogueItems = {};
  local currentLayoutOrder = 1;
  for categoryIndex, category in {conversations, redirects, responses, messages} do

    for _, childContentScript in category do

      -- Make sure the message container is completely visible, even when dropdowns are open.
      local dialogueItem = React.createElement(DialogueItem, {
        type = ({"Conversation", "Redirect", "Response", "Message"})[categoryIndex] :: DialogueItem.DialogueItemType;
        layoutOrder = currentLayoutOrder;
        zIndex = currentZIndex;
        contentScript = childContentScript;
        plugin = props.plugin;
        key = childContentScript:GetDebugId();
        setSettingsTarget = setSettingsTarget;
      });

      table.insert(dialogueItems, dialogueItem);

      currentZIndex -= 1;
      currentLayoutOrder += 1;

    end;

  end;

  return if #dialogueItems > 0 then (
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
      DialogueItems = React.createElement(React.Fragment, {}, {dialogueItems});
    })
  ) else (
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
  );

end;

return React.memo(DialogueTableBody);