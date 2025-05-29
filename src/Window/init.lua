--!strict
local Selection = game:GetService("Selection");

local React = require(script.Parent.roblox_packages.react);
local Toolbar = require(script.Toolbar);
local DialogueTable = require(script.DialogueTable);

export type WindowProperties = {
  repairDialogueServerParent: (dialogueServerParent: Model | BasePart) -> ();
  plugin: Plugin;
  pluginGUI: DockWidgetPluginGui;
  closeDialogueEditor: () -> ();
}

local function Window(props: WindowProperties)

  local dialogueServerParent: (Model | BasePart)?, setDialogueServerParent = React.useState(nil :: (Model | BasePart)?);
  local dialogueParent: ModuleScript?, setDialogueParent = React.useState(nil :: ModuleScript?);

  React.useEffect(function()
  
    local function checkSelection()

      local selection = Selection:Get();
      if #selection == 1 then

        local selectedInstance = selection[1];
        local dialogueServerParent = if selectedInstance.ClassName == "Model" or selectedInstance:IsA("BasePart") then selectedInstance else selectedInstance:FindFirstAncestorOfClass("Model") or selectedInstance:FindFirstAncestorWhichIsA("BasePart");
        setDialogueServerParent(dialogueServerParent);
        setDialogueParent(if selectedInstance == dialogueServerParent then dialogueServerParent:FindFirstChild("DialogueServer") else selectedInstance);

        if dialogueServerParent and dialogueServerParent:FindFirstChild("DialogueServer") then

          props.pluginGUI.Title = `Dialogue Maker • {dialogueServerParent.Name}`;

        else

          props.closeDialogueEditor();

        end;

      elseif #selection == 0 then

        props.closeDialogueEditor();

      end

    end;

    local selectionChangedConnection = Selection.SelectionChanged:Connect(checkSelection);
    task.spawn(checkSelection);

    return function()

      selectionChangedConnection:Disconnect();

    end;

  end, {dialogueServerParent});

  return if dialogueServerParent and dialogueParent then
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
          dialogueParent = dialogueParent;
          plugin = props.plugin;
          repairDialogueServerParent = props.repairDialogueServerParent;
          dialogueServerParent = dialogueServerParent;
        });
        DialogueTable = React.createElement(DialogueTable, {
          dialogueParent = dialogueParent;
          plugin = props.plugin;
        });
      })
    })
  else nil;

end;

return Window;