--!strict

local root = script.Parent;
local React = require(root.roblox_packages.react);
local Toolbar = require(script.components.Toolbar);
local Explorer = require(script.components.Explorer);
local Settings = require(script.components.Settings);
local InitialSetupScreen = require(script.components.InitialSetupScreen);
local useDialogueMakerScriptSelection = require(script.hooks.useDialogueMakerScriptSelection);
local useAutomaticWidgetTitle = require(script.hooks.useAutomaticWidgetTitle);
local useAutomaticClose = require(script.hooks.useAutomaticClose);
local useDialogueMakerPackages = require(script.hooks.useDialogueMakerPackages);

export type DialogueEditorProperties = {
  plugin: Plugin;
  pluginGUI: DockWidgetPluginGui;
  closeDialogueEditor: () -> ();
}

local function DialogueEditor(props: DialogueEditorProperties)

  local selectedScript, conversationScript = useDialogueMakerScriptSelection();
  local settingsTarget, setSettingsTarget = React.useState(nil :: ModuleScript?);
  local closeDialogueEditor = props.closeDialogueEditor;

  useAutomaticWidgetTitle(props.pluginGUI, conversationScript);
  useAutomaticClose(closeDialogueEditor);

  local dialogueMakerPackages = useDialogueMakerPackages();

  if not dialogueMakerPackages then

    return React.createElement(InitialSetupScreen, {
      plugin = props.plugin;
      pluginGUI = props.pluginGUI;
      closeDialogueEditor = closeDialogueEditor;
    });

  end;

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
      settingsTarget = settingsTarget;
      setSettingsTarget = setSettingsTarget;
      layoutOrder = 1;
    });
    Explorer = if not settingsTarget then
      React.createElement(Explorer, {
        selectedScript = selectedScript;
        plugin = props.plugin;
        setSettingsTarget = setSettingsTarget;
        layoutOrder = 2;
      })
    else nil;
    Settings = if settingsTarget then
      React.createElement(Settings, {
        initialSettingsTarget = settingsTarget;
        layoutOrder = 2;
      })
    else nil;
  });

end;

return React.memo(DialogueEditor);