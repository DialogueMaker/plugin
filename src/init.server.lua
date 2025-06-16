--!strict

local ChangeHistoryService = game:GetService("ChangeHistoryService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Selection = game:GetService("Selection");

local Icons = require(script.Icons);
local React = require(script.roblox_packages.react);
local ReactRoblox = require(script.roblox_packages["react-roblox"]);
local DialogueEditor = require(script.DialogueEditor);

if RunService:IsRunning() then

  return;

end;

local toolbar = plugin:CreateToolbar("Dialogue Maker");
local themeName = settings().Studio.Theme.Name;
local dialogueEditorButton = toolbar:CreateButton("Dialogue Editor", "Toggles the Dialogue Editor window.", Icons[themeName].createDialogueButton);
local addDialogueMakerKitButton = toolbar:CreateButton("Add Dialogue Maker Kit", "Adds a Dialogue Maker Kit to ReplicatedStorage.", Icons[themeName].createDialogueButton);
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

  local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, 512, 241, 512, 150);
  local newPluginGui = plugin:CreateDockWidgetPluginGui(`Dialogue Editor`, widgetInfo);
  pluginGUI = newPluginGui;

  newPluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
  newPluginGui.Title = "Dialogue Editor";
  newPluginGui:BindToClose(closeDialogueEditor);
  
  local newPluginGUIRoot = ReactRoblox.createRoot(newPluginGui);
  newPluginGUIRoot:render(React.createElement(DialogueEditor, {
    plugin = plugin;
    pluginGUI = newPluginGui;
    closeDialogueEditor = closeDialogueEditor;
  }));
  pluginGUIRoot = newPluginGUIRoot;

  refreshToolbar();

end;

local function addDialogueMakerKit()

  -- Start a history change recording.
  if ChangeHistoryService:IsRecordingInProgress() then
    
    ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);

  end;

  local historyIdentifier = ChangeHistoryService:TryBeginRecording("Add Dialogue Maker Kit");
  assert(historyIdentifier, "[Dialogue Maker] ChangeHistoryService failed to begin recording.");

  -- Add the Dialogue Maker Kit to the game.
  local dialogueMakerKit = script.DialogueMakerKit:Clone();
  dialogueMakerKit.Parent = ReplicatedStorage;

  print(`[Dialogue Maker] Successfully added Dialogue Maker Kit. You can find it at {dialogueMakerKit:GetFullName()}.`);
  
  ChangeHistoryService:FinishRecording(historyIdentifier, Enum.FinishRecordingOperation.Commit);

end;

dialogueEditorButton.Click:Connect(function()

  if pluginGUI then
    
    closeDialogueEditor();
    
  else

    openDialogueEditor();
    
  end;


end);

addDialogueMakerKitButton.Click:Connect(addDialogueMakerKit);

settings().Studio.ThemeChanged:Connect(refreshToolbar);
Selection.SelectionChanged:Connect(refreshToolbar);
refreshToolbar();

plugin.Unloading:Connect(function()

  closeDialogueEditor();

end)