--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local DialogueGroup = require(script.DialogueGroup);
local useRefreshDialogueMakerScripts = require(root.DialogueEditor.hooks.useRefreshDialogueMakerScripts);
local TabSelector = require(root.DialogueEditor.components.TabSelector);
local TabSelectorButton = require(root.DialogueEditor.components.TabSelector.TabSelectorButton);

type DialogueItemType = DialogueGroup.DialogueItemType;

export type DialogueTableBodyProperties = {
  selectedScript: ModuleScript?;
  plugin: Plugin;
  setSettingsTarget: (target: ModuleScript?) -> ();
}

local function DialogueGroupContainer(props: DialogueTableBodyProperties)

  local selectedScript = props.selectedScript;
  local setSettingsTarget = props.setSettingsTarget;

  local refreshDialogueMakerScripts = useRefreshDialogueMakerScripts();

  local conversations, setConversations = React.useState({} :: {ModuleScript});
  local redirects, setRedirects = React.useState({} :: {ModuleScript});
  local responses, setResponses = React.useState({} :: {ModuleScript});
  local messages, setMessages = React.useState({} :: {ModuleScript});
  local selectedTab: DialogueItemType?, setSelectedTab = React.useState(nil :: DialogueItemType?);

  React.useEffect(function(): ()
  
    setSelectedTab(nil);
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

  local tabs = {};
  local dialogueGroups = {};
  for categoryIndex, scriptList in {conversations, redirects, responses, messages} do

    local dialogueType: DialogueItemType = ({"Conversation", "Redirect", "Response", "Message"})[categoryIndex] :: DialogueItemType;
    if not selectedTab and #scriptList > 0 then

      setSelectedTab(dialogueType);
      break;

    end;

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
    
    local dialogueGroup = React.createElement(DialogueGroup, {
      name = dialogueType :: DialogueItemType;
      layoutOrder = categoryIndex;
      plugin = props.plugin;
      key = dialogueType;
      scriptList = scriptList;
      setSettingsTarget = setSettingsTarget;
    });

    table.insert(dialogueGroups, dialogueGroup);

  end;

  return React.createElement("ScrollingFrame", {
    LayoutOrder = 2;
    Size = UDim2.fromScale(1, 1);
    BackgroundTransparency = 1;
    BorderSizePixel = 0;
    AutomaticCanvasSize = Enum.AutomaticSize.Y;
    CanvasSize = UDim2.fromScale(0, 0);
    ScrollingDirection = Enum.ScrollingDirection.Y;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 15);
    });
    TabSelector = React.createElement(TabSelector, {}, tabs);
    DialogueGroups = React.createElement(React.Fragment, {}, dialogueGroups);
  });

end;

return React.memo(DialogueGroupContainer);