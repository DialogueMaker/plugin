--!strict

local root = script.Parent;
local React = require(root.roblox_packages.react);
local Toolbar = require(script.Toolbar);
local Explorer = require(script.Explorer);
local Settings = require(script.Settings);
local useDialogueMakerScriptSelection = require(script.hooks.useDialogueMakerScriptSelection);
local useAutomaticWidgetTitle = require(script.hooks.useAutomaticWidgetTitle);

export type DialogueEditorProperties = {
  plugin: Plugin;
  pluginGUI: DockWidgetPluginGui;
}

local function DialogueEditor(props: DialogueEditorProperties)

  local selectedScript, conversationScript = useDialogueMakerScriptSelection();
  local settingsTarget, setSettingsTarget = React.useState(nil :: ModuleScript?);

  useAutomaticWidgetTitle(props.pluginGUI, conversationScript);

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