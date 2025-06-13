--!strict

local Selection = game:GetService("Selection");
local RunService = game:GetService("RunService");

local Icons = require(script.Icons);
local React = require(script.roblox_packages.react);
local ReactRoblox = require(script.roblox_packages["react-roblox"]);
local Window = require(script.Window);

if RunService:IsRunning() then

  return;

end;

local toolbar = plugin:CreateToolbar("Dialogue Maker");
local themeName = settings().Studio.Theme.Name;
local dialogueEditorButton = toolbar:CreateButton("Dialogue Editor", "Toggles the Dialogue Editor window.", Icons[themeName].createDialogueButton);
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
  dialogueEditorButton.Icon = Icons[themeName].createDialogueButton;
  dialogueEditorButton.Enabled = selectedInstance ~= nil;
  dialogueEditorButton:SetActive(pluginGUI ~= nil);

end;

local function closeDialogueEditor(): ()

  if pluginGUI then 

    pluginGUI:Destroy();
    pluginGUI = nil;

  end;
  
  refreshToolbar();

end;

local function openDialogueEditor(): ()

  local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, 512, 241, 512, 150);
  local newPluginGui = plugin:CreateDockWidgetPluginGui(`Dialogue Editor`, widgetInfo);
  pluginGUI = newPluginGui;

  newPluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
  newPluginGui.Title = "Dialogue Editor";
  newPluginGui:BindToClose(closeDialogueEditor);
  
  local pluginGUIRoot = ReactRoblox.createRoot(newPluginGui);
  pluginGUIRoot:render(React.createElement(Window, {
    plugin = plugin;
    pluginGUI = newPluginGui;
    closeDialogueEditor = function()

      pluginGUIRoot:unmount();
      closeDialogueEditor();

    end;
  }));

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

refreshToolbar();