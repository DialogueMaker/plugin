--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent.Parent.Parent;
local VirtualService = require(root.VirtualService);
local React = require(root.roblox_packages.react);
local DialogueGroup = require(script.components.DialogueGroup);
local useRefreshDialogueMakerScripts = require(root.DialogueEditor.hooks.useRefreshDialogueMakerScripts);
local TabSelector = require(root.DialogueEditor.components.TabSelector);
local TabSelectorButton = require(root.DialogueEditor.components.TabSelector.TabSelectorButton);

type DialogueItemType = DialogueGroup.DialogueItemType;

export type DialogueTableBodyProperties = {
  layoutOrder: number;
  selectedScript: ModuleScript?;
  plugin: Plugin;
}

local function DialogueGroupContainer(props: DialogueTableBodyProperties)

  Selection = if VirtualService.mocks.isEnabled then VirtualService.mocks.services.Selection else Selection;

  local layoutOrder = props.layoutOrder;
  local selectedScript = props.selectedScript;
  local refreshDialogueMakerScripts = useRefreshDialogueMakerScripts();

  local getSelectedTab = React.useCallback(function(): DialogueItemType?

    if not selectedScript then

      return "Conversation" :: DialogueItemType;

    end;

    for _, dialogueType in {"Message", "Response", "Redirect"} do

      local messagesFolder = selectedScript:FindFirstChild(`{dialogueType}s`);
      if messagesFolder and #messagesFolder:GetChildren() > 0 then

        return dialogueType :: DialogueItemType;

      end;

    end;

    return;

  end, {selectedScript});

  local getDialogueScripts = React.useCallback(function(folderName: string): {ModuleScript}

    local dialogueFolder = if selectedScript then selectedScript:FindFirstChild(folderName) else nil;
    if not selectedScript or not dialogueFolder then

      return {};

    end;

    local dialogueScripts: {ModuleScript} = {};
    for _, possibleDialogueScript in dialogueFolder:GetChildren() do

      if possibleDialogueScript:IsA("ModuleScript") and possibleDialogueScript:HasTag(if folderName == "Conversations" then "DialogueMakerConversationScript" else "DialogueMakerDialogueScript") then

        table.insert(dialogueScripts, possibleDialogueScript);

      end;

    end;

    local function sortByMessagePriority(dialogueA: ModuleScript, dialogueB: ModuleScript)
        
      local messageAPriority = tonumber(dialogueA.Name) or math.huge;
      local messageBPriority = tonumber(dialogueB.Name) or math.huge;
      
      return messageAPriority < messageBPriority;
      
    end;

    table.sort(dialogueScripts, sortByMessagePriority);

    return dialogueScripts;

  end, {selectedScript});

  local conversations, setConversations = React.useState(getDialogueScripts("Conversations"));
  local redirects, setRedirects = React.useState(getDialogueScripts("Redirects"));
  local responses, setResponses = React.useState(getDialogueScripts("Responses"));
  local messages, setMessages = React.useState(getDialogueScripts("Messages"));
  local selectedTab: DialogueItemType?, setSelectedTab = React.useState(getSelectedTab());

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
      setConversations(getDialogueScripts("Conversations"));
      setRedirects(getDialogueScripts("Redirects"));
      setResponses(getDialogueScripts("Responses"));
      setMessages(getDialogueScripts("Messages"));

      if selectedTab and selectedScript then

        local folder = selectedScript:FindFirstChild(selectedTab);
        setSelectedTab(if folder then selectedTab else getSelectedTab());

      else

        setSelectedTab(getSelectedTab());

      end;

      -- Separate the dialogue item types.
      if selectedScript then

        for _, folderName in {"Messages", "Responses", "Redirects"} do
          
          local dialogueFolder = selectedScript:FindFirstChild(folderName);
          if not dialogueFolder then

            continue;

          end;

          for _, possibleDialogueScript in dialogueFolder:GetChildren() do

            if not possibleDialogueScript:HasTag("DialogueMakerDialogueScript") then

              continue;

            end;
            
            table.insert(contentScriptConnections, possibleDialogueScript:GetAttributeChangedSignal("DialogueType"):Connect(refreshTable));
            table.insert(contentScriptConnections, possibleDialogueScript:GetAttributeChangedSignal("DialogueContent"):Connect(refreshTable));
            table.insert(contentScriptConnections, possibleDialogueScript:GetPropertyChangedSignal("Name"):Connect(refreshTable));

          end;

          table.insert(contentScriptConnections, dialogueFolder.ChildAdded:Connect(refreshTable));
          table.insert(contentScriptConnections, dialogueFolder.ChildRemoved:Connect(refreshTable));
          
        end;

        table.insert(contentScriptConnections, selectedScript.ChildAdded:Connect(refreshTable));
        table.insert(contentScriptConnections, selectedScript.ChildRemoved:Connect(refreshTable));

      else
        
        local selection = Selection:Get();
        if #selection == 1 then

          local conversationsParent = if selection[1]:IsA("Folder") then selection[1] else selection[1]:FindFirstChild("Conversations");

          if not conversationsParent then

            table.insert(contentScriptConnections, selection[1].ChildAdded:Connect(refreshTable));
            return;

          end;

          table.insert(contentScriptConnections, conversationsParent.ChildAdded:Connect(refreshTable));
          table.insert(contentScriptConnections, conversationsParent.ChildRemoved:Connect(refreshTable));

          for _, possibleConversationScript in conversationsParent:GetChildren() do

            if possibleConversationScript:IsA("ModuleScript") and possibleConversationScript:HasTag("DialogueMakerConversationScript") then
              
              table.insert(conversations, possibleConversationScript);
            
            end;

          end;

        end;

      end;

    end;
    
    task.spawn(refreshTable);

    return function()

      cleanupConnections();

    end;

  end, {selectedScript :: unknown, getSelectedTab, refreshDialogueMakerScripts});

  local tabs = {};
  local dialogueGroup = React.createElement(React.Fragment);
  for categoryIndex, scriptList in {conversations, redirects, responses, messages} do

    if (not selectedScript and categoryIndex > 1) or (selectedScript and categoryIndex == 1) then

      continue;

    end;

    local dialogueType: DialogueItemType = ({"Conversation", "Redirect", "Response", "Message"})[categoryIndex] :: DialogueItemType;
    local tab = React.createElement(TabSelectorButton, {
      key = dialogueType;
      text = `{dialogueType}s` :: string;
      layoutOrder = categoryIndex;
      isDisabled = #scriptList == 0;
      isSelected = selectedTab == dialogueType;
      onSelected = function()

        setSelectedTab(dialogueType);

      end;
    });

    table.insert(tabs, tab);

    if selectedTab ~= dialogueType then

      continue;

    end;
    
    dialogueGroup = React.createElement(DialogueGroup, {
      name = dialogueType :: DialogueItemType;
      layoutOrder = categoryIndex;
      plugin = props.plugin;
      dialogueScripts = scriptList;
    });

  end;

  return React.createElement("Frame", {
    LayoutOrder = layoutOrder;
    BackgroundTransparency = 1;
    Size = UDim2.fromScale(1, 0);
    AutomaticSize = Enum.AutomaticSize.Y;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 15);
    });
    TabSelector = React.createElement(TabSelector, {}, tabs);
    DialogueGroup = dialogueGroup;
  });

end;

return React.memo(DialogueGroupContainer);