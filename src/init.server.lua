--!strict

local ChangeHistoryService = game:GetService("ChangeHistoryService");
local CollectionService = game:GetService("CollectionService");
local Selection = game:GetService("Selection");
local StarterPlayer = game:GetService("StarterPlayer");
local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts");
local RunService = game:GetService("RunService");

local Icons = require(script.Icons);
local React = require(script.roblox_packages.react);
local ReactRoblox = require(script.roblox_packages["react-roblox"]);
local Window = require(script.Window);

if RunService:IsRunning() then

  return;

end;

local toolbar = plugin:CreateToolbar("Dialogue Maker by Beastslash");
local themeName = settings().Studio.Theme.Name;
local createDialogueButton = toolbar:CreateButton("Create Conversation", "Creates a ModuleScript that contains a Conversation, selects that ModuleScript, then runs the Edit Server script.", Icons[themeName].createDialogueButton);
local editDialogueButton = toolbar:CreateButton("Edit Conversation", "", Icons[themeName].editDialogueButton);
local initializeClientButton = toolbar:CreateButton("Initialize Client", "", Icons[themeName].initializeClientButton);
local adjustClientSettingsButton = toolbar:CreateButton("Adjust Client Settings", "", Icons[themeName].adjustClientSettingsButton);
local resetClientPackagesButton = toolbar:CreateButton("Reset Client Packages", "", Icons[themeName].resetClientPackagesButton);
local pluginGUI: DockWidgetPluginGui?;

local function getSelectedInstance(): Instance?

  local selectedObjects = Selection:Get();
  if #selectedObjects ~= 1 then return nil; end;
  
  local instance = selectedObjects[1];
  
  return instance;

end;

local function getDialogueClientScript(): LocalScript?

  local dialogueClientScripts = CollectionService:GetTagged("DialogueMaker_Loader");
  local dialogueClientScript;
  for _, possibleDialogueClientScript in dialogueClientScripts do

    if possibleDialogueClientScript:IsA("LocalScript") then

      if dialogueClientScript then

        warn(`[Dialogue Maker] Extra Dialogue Maker Client script found at {dialogueClientScript:GetFullName()}. This is not supported, please remove the extra ones. We'll use {possibleDialogueClientScript:GetFullName()} instead.`);

      end;

      dialogueClientScript = possibleDialogueClientScript;

    end;

  end;

  return dialogueClientScript;

end;

local function refreshButtons()

  editDialogueButton:SetActive(pluginGUI ~= nil);
  
  local themeName = settings().Studio.Theme.Name;
  createDialogueButton.Icon = Icons[themeName].createDialogueButton;
  editDialogueButton.Icon = Icons[themeName].editDialogueButton;
  resetClientPackagesButton.Icon = Icons[themeName].resetClientPackagesButton;
  initializeClientButton.Icon = Icons[themeName].initializeClientButton;
  adjustClientSettingsButton.Icon = Icons[themeName].adjustClientSettingsButton;

  local selectedInstance = getSelectedInstance();
  local isSelectingConversation = if selectedInstance then selectedInstance:HasTag("DialogueMakerConversation") else false;
  local isSelectingDialogue = if selectedInstance then selectedInstance:HasTag("DialogueMaker_Dialogue") else false;
  editDialogueButton.Enabled = pluginGUI ~= nil or isSelectingDialogue or isSelectingConversation;
  createDialogueButton.Enabled = if selectedInstance then not isSelectingDialogue and not isSelectingConversation else false;

  local dialogueClientScript = getDialogueClientScript();
  adjustClientSettingsButton.Enabled = dialogueClientScript ~= nil;
  resetClientPackagesButton.Enabled = dialogueClientScript ~= nil;

end;

local function closeDialogueEditor(): ()

  if pluginGUI then 

    pluginGUI:Destroy();
    pluginGUI = nil;

  end;
  
  refreshButtons();

end;

local function openDialogueEditor(): ()

  local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, 512, 241, 512, 150);
  local newPluginGui = plugin:CreateDockWidgetPluginGui(`Dialogue Maker`, widgetInfo);
  pluginGUI = newPluginGui;

  newPluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
  newPluginGui.Title = `Dialogue Maker`;
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

  refreshButtons();

end;

local function initializeDialogueClientScript()

  local didSucceed, errorMessage = pcall(function()

    -- Set an undo point just in case the user wants to revert this.
    if ChangeHistoryService:IsRecordingInProgress() then

      ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);

    end;

    print("[Dialogue Maker] Adding DialogueClientScript...");

    local historyServiceIdentifier = ChangeHistoryService:TryBeginRecording("Initialize Dialogue Maker Client script");
    
    -- Put the new instance in place of the old script.
    local currentDialogueClientScript = getDialogueClientScript();
    local newDialogueClientScript = script.DialogueClientScript:Clone();
    newDialogueClientScript:AddTag("DialogueMaker_Loader");
    newDialogueClientScript.Parent = if currentDialogueClientScript then currentDialogueClientScript.Parent else StarterPlayerScripts;
    newDialogueClientScript.Enabled = true;

    if currentDialogueClientScript then

      -- Using .Parent = nil because :Destroy() prevents undoing.
      currentDialogueClientScript.Parent = nil;

    end;

    print(`[Dialogue Maker] Added DialogueClientScript to {newDialogueClientScript.Parent:GetFullName()}.`);

    -- Finalize the undo point
    ChangeHistoryService:FinishRecording(historyServiceIdentifier, Enum.FinishRecordingOperation.Commit);

  end);

  if not didSucceed then

    warn(`[Dialogue Maker] Failed to initialize Dialogue Maker Client script: {errorMessage}`);
    return;

  end;

  refreshButtons();

end;

local function editSelectedDialogue()

  local selectedInstance = getSelectedInstance();
  if not selectedInstance or (not selectedInstance:HasTag("DialogueMakerConversation") and not selectedInstance:HasTag("DialogueMaker_Dialogue")) then

    editDialogueButton:SetActive(false);
    return;
    
  end;

  -- Just for convenience.
  local dialogueClientScript = getDialogueClientScript();
  if not dialogueClientScript then

    initializeDialogueClientScript();

  end;

  -- Now we can open the dialogue editor.
  editDialogueButton:SetActive(true);
  openDialogueEditor();

end;

local function initializeConversationScript()

  local selectedInstance = getSelectedInstance();
  
  if not selectedInstance or selectedInstance:HasTag("DialogueMakerConversation") then

    createDialogueButton:SetActive(false);
    return;
    
  end;

  print(`[Dialogue Maker] Adding Conversation script to {selectedInstance.Name}...`);

  local conversationScript = script.Templates.ConversationTemplate:Clone();
  conversationScript.Name = "Conversation";
  conversationScript.Parent = selectedInstance;

  print(`[Dialogue Maker] Added Conversation script to {conversationScript:GetFullName()}.`);

  conversationScript = conversationScript;

  -- Select the new dialogue module script
  Selection:Set({conversationScript});

  -- Open the dialogue editor
  editSelectedDialogue();

end;

local function openDialogueClientScript()

  local dialogueClientScript = getDialogueClientScript();
  if not dialogueClientScript then

    warn("[Dialogue Maker] No DialogueClientScript found. Please initialize it first.");
    return;

  end;

  plugin:OpenScript(dialogueClientScript);

end;

local function resetClientPackages()

  -- Debounce
  resetClientPackagesButton.Enabled = false;
  
  local dialogueClientScript = getDialogueClientScript();
  if not dialogueClientScript then

    warn("[Dialogue Maker] No DialogueClientScript found. Please initialize it first.");
    return;

  end;

  local didSucceed, errorMessage = pcall(function()

    -- Set an undo point just in case the user wants to revert this.
    if ChangeHistoryService:IsRecordingInProgress() then

      ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);

    end;

    local historyServiceIdentifier = ChangeHistoryService:TryBeginRecording("Reset Dialogue Maker Client packages");

    -- Delete the old script packages.
    local robloxPackages = dialogueClientScript:FindFirstChild("roblox_packages");
    if robloxPackages then

      -- Using .Parent = nil because :Destroy() prevents undoing.
      robloxPackages.Parent = nil;

    end;

    -- Put the new instances in their places
    local newPackages = script.DialogueClientScript.roblox_packages:Clone();
    newPackages.Parent = dialogueClientScript;

    -- Finalize the undo point
    ChangeHistoryService:FinishRecording(historyServiceIdentifier, Enum.FinishRecordingOperation.Commit);

    print("[Dialogue Maker] Reset Dialogue Maker Client packages successfully.");

  end);

  if not didSucceed then

    warn(`[Dialogue Maker] Failed to reset Dialogue Maker Client packages: {errorMessage}`);

  end;

  resetClientPackagesButton.Enabled = true;
  
end;

createDialogueButton.Click:Connect(initializeConversationScript);
editDialogueButton.Click:Connect(function()

  if pluginGUI then
    
    closeDialogueEditor();
    return;
    
  end;

  editSelectedDialogue()

end);
initializeClientButton.Click:Connect(initializeDialogueClientScript);
adjustClientSettingsButton.Click:Connect(openDialogueClientScript);
resetClientPackagesButton.Click:Connect(resetClientPackages);

Selection.SelectionChanged:Connect(refreshButtons);
settings().Studio.ThemeChanged:Connect(refreshButtons);

refreshButtons();