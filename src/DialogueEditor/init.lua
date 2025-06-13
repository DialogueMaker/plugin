--!strict

local Selection = game:GetService("Selection");

local React = require(script.Parent.roblox_packages.react);
local Toolbar = require(script.Toolbar);
local Explorer = require(script.Explorer);
local Settings = require(script.Settings);

export type DialogueEditorProperties = {
  plugin: Plugin;
  pluginGUI: DockWidgetPluginGui;
  closeDialogueEditor: () -> ();
}

local function DialogueEditor(props: DialogueEditorProperties)

  local conversationScript: ModuleScript?, setConversationScript = React.useState(nil :: ModuleScript?);
  local selectedScript: ModuleScript?, setSelectedScript = React.useState(nil :: ModuleScript?);
  local settingsType, setSettingsType = React.useState(nil);

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

          if not conversationScript then

            props.closeDialogueEditor();
            return;

          end;

        end;

        local selectedScript = if conversationScript == selectedInstance or (isSelectionAModuleScript and selectedInstance:HasTag("DialogueMakerDialogueScript")) then selectedInstance else nil;
        if not selectedScript then

          props.closeDialogueEditor();
          return;

        end;

        setConversationScript(conversationScript);
        setSelectedScript(selectedScript);

      elseif #selection == 0 then

        props.closeDialogueEditor();

      end

    end;

    local selectionChangedConnection = Selection.SelectionChanged:Connect(checkSelection);
    task.spawn(checkSelection);

    return function()

      selectionChangedConnection:Disconnect();

    end;

  end, {});

  React.useEffect(function(): ()
  
    if conversationScript then

      local function updateTitle()

        props.pluginGUI.Title = `Dialogue Maker • {conversationScript.Name}`;

      end;

      local updateTitleConnection = conversationScript:GetPropertyChangedSignal("Name"):Connect(updateTitle);
      updateTitle();

      return function()

        updateTitleConnection:Disconnect();

      end;

    end;

  end, {conversationScript});

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 1, 0);
    BackgroundTransparency = 1;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 0);
    });
    Toolbar = React.createElement(Toolbar, {
      plugin = props.plugin;
      selectedScript = selectedScript;
      conversationScript = conversationScript;
    });
    Explorer = if not settingsType and selectedScript then
      React.createElement(Explorer, {
        selectedScript = selectedScript;
        plugin = props.plugin;
      })
    else nil;
    Settings = if settingsType then
      React.createElement(Settings, {
        type = settingsType;
      })
    else nil;
  });

end;

return DialogueEditor;