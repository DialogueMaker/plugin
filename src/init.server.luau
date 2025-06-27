--!strict

local RunService = game:GetService("RunService");
local Selection = game:GetService("Selection");

local Icons = require(script.Icons);
local React = require(script.roblox_packages.react);
local ReactErrorBoundary = require(script.roblox_packages.ReactErrorBoundary);
local ErrorComponent = require(script.ErrorComponent);
local ErrorBoundary = ReactErrorBoundary.ErrorBoundary;
local ReactRoblox = require(script.roblox_packages["react-roblox"]);
local DialogueEditor = require(script.DialogueEditor);

if RunService:IsRunning() then

  return;

end;

local toolbar = plugin:CreateToolbar("Dialogue Maker");
local themeName = settings().Studio.Theme.Name;
local dialogueEditorButton = toolbar:CreateButton("Dialogue Maker", "Toggles the Dialogue Maker window.", Icons[themeName].logo);
local pluginGUI: DockWidgetPluginGui?;

local function getSelectedInstance(): Instance?

  local selectedObjects = Selection:Get();
  if #selectedObjects ~= 1 then return nil; end;
  
  local instance = selectedObjects[1];
  
  return instance;

end;

local function refreshToolbar()

  local themeName = settings().Studio.Theme.Name;
  local selectedInstance = getSelectedInstance();
  dialogueEditorButton.Icon = Icons[themeName].logo;
  dialogueEditorButton.Enabled = selectedInstance ~= nil;
  dialogueEditorButton:SetActive(pluginGUI ~= nil);

end;

local pluginGUIRoot: ReactRoblox.RootType? = nil;
local function closeDialogueEditor(): ()

  if pluginGUIRoot then

    pluginGUIRoot:unmount();
    pluginGUIRoot = nil;

  end;

  if pluginGUI then 

    pluginGUI:Destroy();
    pluginGUI = nil;

  end;
  
  refreshToolbar();

end;

local function openDialogueEditor(): ()

  local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, 584, 300, 1, 1);
  local title = `Dialogue Maker Plugin {script:GetAttribute("Version")}`;
  local newPluginGui = plugin:CreateDockWidgetPluginGui(title, widgetInfo);
  pluginGUI = newPluginGui;

  newPluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
  newPluginGui.Title = title;
  newPluginGui:BindToClose(closeDialogueEditor);
  
  local newPluginGUIRoot = ReactRoblox.createRoot(newPluginGui);
  newPluginGUIRoot:render(
    React.createElement(ErrorBoundary, {
      FallbackComponent = ErrorComponent :: any;
      onError = function(errorObject)

        task.spawn(function()
        
          error(errorObject);

        end);

      end;
    }, {
      React.createElement(DialogueEditor, {
        plugin = plugin;
        pluginGUI = newPluginGui;
        closeDialogueEditor = closeDialogueEditor;
      })
    })
  );
  pluginGUIRoot = newPluginGUIRoot;

  refreshToolbar();

end;

dialogueEditorButton.Click:Connect(function()

  if pluginGUI then
    
    closeDialogueEditor();
    
  else

    openDialogueEditor();
    
  end;

end);

settings().Studio.ThemeChanged:Connect(refreshToolbar);
Selection.SelectionChanged:Connect(refreshToolbar);
refreshToolbar();

plugin.Unloading:Connect(function()

  closeDialogueEditor();

end)