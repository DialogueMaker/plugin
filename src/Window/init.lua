--!strict
local Selection = game:GetService("Selection");

local React = require(script.Parent.roblox_packages.react);
local Toolbar = require(script.Toolbar);
local DialogueTable = require(script.DialogueTable);

export type WindowProperties = {
  plugin: Plugin;
  pluginGUI: DockWidgetPluginGui;
  closeDialogueEditor: () -> ();
}

local function Window(props: WindowProperties)

  local dialogueServerScript: ModuleScript?, setDialogueServerScript = React.useState(nil :: ModuleScript?);
  local selectedScript: ModuleScript?, setSelectedScript = React.useState(nil :: ModuleScript?);

  React.useEffect(function()
  
    local function checkSelection()

      local selection = Selection:Get();
      if #selection == 1 then

        local selectedInstance = selection[1];
        local isSelectionAModuleScript = selectedInstance:IsA("ModuleScript");
        local dialogueServerScript = if isSelectionAModuleScript and selectedInstance:HasTag("DialogueMaker_DialogueServer") then selectedInstance else nil;
        if not dialogueServerScript then

          local parent = selectedInstance.Parent;
          while parent do

            if not parent:IsA("ModuleScript") then
              
              break;

            end;
            
            if parent:HasTag("DialogueMaker_DialogueServer") then
              
              dialogueServerScript = parent;
              break;

            end;
            
            parent = parent.Parent;
          
          end;

          if not dialogueServerScript then

            props.closeDialogueEditor();
            return;

          end;

        end;

        local selectedScript = if dialogueServerScript == selectedInstance or (isSelectionAModuleScript and selectedInstance:HasTag("DialogueMaker_Dialogue")) then selectedInstance else nil;
        if not selectedScript then

          props.closeDialogueEditor();
          return;

        end;

        setDialogueServerScript(dialogueServerScript);
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
  
    if dialogueServerScript then

      local function updateTitle()

        props.pluginGUI.Title = `Dialogue Maker • {dialogueServerScript.Name}`;

      end;

      local updateTitleConnection = dialogueServerScript:GetPropertyChangedSignal("Name"):Connect(updateTitle);
      updateTitle();

      return function()

        updateTitleConnection:Disconnect();

      end;

    end;

  end, {dialogueServerScript});

  return if dialogueServerScript and selectedScript then
    React.createElement("Frame", {
      Size = UDim2.new(1, 0, 1, 0);
      BackgroundTransparency = 1;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 0);
      });
      Editor = React.createElement(React.Fragment, {}, {
        Toolbar = React.createElement(Toolbar, {
          plugin = props.plugin;
          selectedScript = selectedScript;
          dialogueServerScript = dialogueServerScript;
        });
        DialogueTable = React.createElement(DialogueTable, {
          selectedScript = selectedScript;
          plugin = props.plugin;
        });
      })
    })
  else nil;

end;

return Window;