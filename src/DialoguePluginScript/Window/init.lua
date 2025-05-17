--!strict
local Selection = game:GetService("Selection");

local React = require(script.Parent.Packages.react);
local Toolbar = require(script.Toolbar);
local DialogueTable = require(script.DialogueTable);

export type WindowProperties = {
  repairNPC: (model: Model) -> ();
  plugin: Plugin;
  pluginGUI: DockWidgetPluginGui;
  closeDialogueEditor: () -> ();
}

local function Window(props: WindowProperties)

  local model: Model?, setModel = React.useState(nil :: Model?);
  local dialogueParent: ModuleScript?, setDialogueParent = React.useState(nil :: ModuleScript?);

  React.useEffect(function()
  
    local function checkSelection()

      local selection = Selection:Get();
      if #selection == 1 then

        local selectedInstance = selection[1];
        local model = if selectedInstance:IsA("Model") then selectedInstance else selectedInstance:FindFirstAncestorWhichIsA("Model");
        props.pluginGUI.Title = `Dialogue Maker • {model.Name}`;
        setModel(model);
        setDialogueParent(if selectedInstance == model then model:FindFirstChild("DialogueServer") else selectedInstance);

      elseif #selection == 0 then

        props.closeDialogueEditor();

      end

    end;

    local selectionChangedConnection = Selection.SelectionChanged:Connect(checkSelection);
    task.spawn(checkSelection);

    return function()

      selectionChangedConnection:Disconnect();

    end;

  end, {model});

  return if model and dialogueParent then
    React.createElement("Frame", {
      Size = UDim2.new(1, 0, 1, 0);
      BackgroundTransparency = 1;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 0);
      });
      Editor = if model:HasTag("DialogueMakerNPC") then 
        React.createElement(React.Fragment, {}, {
          Toolbar = React.createElement(Toolbar, {
            dialogueParent = dialogueParent;
            plugin = props.plugin;
            repairNPC = props.repairNPC;
            model = model;
          });
          DialogueTable = React.createElement(DialogueTable, {
            dialogueParent = dialogueParent;
            plugin = props.plugin;
          });
        })
      else (
        React.createElement("TextButton", {
          Text = "Initialize NPC";
          [React.Event.Activated] = function()

            props.repairNPC(model);
            setDialogueParent(model:FindFirstChild("DialogueServer") :: ModuleScript);

          end;
        })
      )
    })
  else nil;

end;

return Window;