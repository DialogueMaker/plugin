--!strict
local Selection = game:GetService("Selection");
local StarterPlayer = game:GetService("StarterPlayer");
local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts");
local ChangeHistoryService = game:GetService("ChangeHistoryService");

local Icons = require(script.Icons);
local React = require(script.roblox_packages.react);
local ReactRoblox = require(script.roblox_packages["react-roblox"]);
local Window = require(script.Window);

local EditDialogueButton: PluginToolbarButton;
local pluginGUI: DockWidgetPluginGui?;

local function getSelectedInstance(): BasePart | Model?

  local selectedObjects = Selection:Get();
  if #selectedObjects ~= 1 then return nil; end;
  
  local instance = selectedObjects[1];
  if not instance:IsA("Model") and not instance:IsA("BasePart") then 
  
    local possibleDialogueServerParent = instance:FindFirstAncestorWhichIsA("Model") or instance:FindFirstAncestorWhichIsA("BasePart");
    local possibleDialogueServer = possibleDialogueServerParent and possibleDialogueServerParent:FindFirstChild("DialogueServer");
    if possibleDialogueServer and possibleDialogueServer:HasTag("DialogueMaker_DialogueServer") then

      instance = possibleDialogueServerParent;

    end;

  end;
  
  return instance;

end;

-- Closes the editor when called
-- @since v1.0.0
local function closeDialogueEditor(): ()

  if pluginGUI then 

    pluginGUI:Destroy();
    pluginGUI = nil;

  end;
  EditDialogueButton:SetActive(false);
  EditDialogueButton.Enabled = getSelectedInstance() ~= nil;

end;

local function repairDialogueServerParent(dialogueServerParent: Model | BasePart): ()
  
  if not dialogueServerParent:FindFirstChild("DialogueServer") then

    print(`[Dialogue Maker] Adding settings script to {dialogueServerParent.Name}...`);

    local SettingsScript = script.DialogueClientScript.Templates.DialogueServerTemplate:Clone();
    SettingsScript.Name = "DialogueServer";
    SettingsScript.Parent = dialogueServerParent;

  end;

end;

-- Open the editor when called.
-- @since v1.0.0
local function openDialogueEditor(): ()

  pluginGUI = plugin:CreateDockWidgetPluginGui(
    `Dialogue Maker`, 
    DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, 512, 241, 512, 150));
  if pluginGUI then

    pluginGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    pluginGUI.Title = `Dialogue Maker`;
    pluginGUI:BindToClose(closeDialogueEditor);
    
    local pluginGUIRoot = ReactRoblox.createRoot(pluginGUI);
    pluginGUIRoot:render(React.createElement(Window, {
      plugin = plugin;
      pluginGUI = pluginGUI;
      repairDialogueServerParent = repairDialogueServerParent;
      closeDialogueEditor = function()

        pluginGUIRoot:unmount();
        closeDialogueEditor();

      end;
    }));
    
  end;

end;

local Toolbar = plugin:CreateToolbar("Dialogue Maker by Beastslash");

local themeName = settings().Studio.Theme.Name;
EditDialogueButton = Toolbar:CreateButton("Edit Dialogue", "Edit dialogue of a selected NPC. The selected object must be a singular model.", Icons[themeName].editDialogueButton);
EditDialogueButton.Click:Connect(function()

  if pluginGUI then
    
    closeDialogueEditor();
    return;
    
  end;

  local selectedInstance = getSelectedInstance();
  
  if not selectedInstance then

    EditDialogueButton:SetActive(false);
    return;
    
  end

  -- Verify NPC dialogue folder
  repairDialogueServerParent(selectedInstance);

  -- Add the chat receiver script in the StarterPlayerScripts.
  if not StarterPlayerScripts:FindFirstChild("DialogueClientScript") then

    print("[Dialogue Maker] Adding DialogueClientScript to the StarterPlayerScripts...");
    local DialogueClientScript = script.DialogueClientScript:Clone()
    DialogueClientScript.Parent = StarterPlayerScripts;
    DialogueClientScript.Disabled = false;
    print("[Dialogue Maker] Added DialogueClientScript to the StarterPlayerScripts.");

  end;

  -- Now we can open the dialogue editor.
  EditDialogueButton:SetActive(true);
  openDialogueEditor();

end);
EditDialogueButton:SetActive(pluginGUI ~= nil);

Selection.SelectionChanged:Connect(function()

  EditDialogueButton.Enabled = pluginGUI ~= nil or getSelectedInstance() ~= nil;

end);

local ResetScriptsButton = Toolbar:CreateButton("Fix Scripts", "Reset DialogueMakerSharedDependencies and DialogueClientScript back to the a stable version.", Icons[themeName].resetScriptsButton);
ResetScriptsButton.Click:Connect(function()

  -- Debounce
  ResetScriptsButton.Enabled = false;

  local Success, Msg = pcall(function()

    -- Set an undo point just in case the user wants to revert this.
    ChangeHistoryService:SetWaypoint("Resetting Dialogue Maker scripts");

    -- Delete the old script
    local oldDialogueClientScript = StarterPlayerScripts:FindFirstChild("DialogueClientScript");
    if oldDialogueClientScript then

      oldDialogueClientScript:Destroy();

    end;

    -- Put the new instances in their places
    local newDialogueClientScript = script.DialogueClientScript:Clone();
    newDialogueClientScript.Enabled = true;
    newDialogueClientScript.Parent = StarterPlayerScripts;

    -- Finalize the undo point
    ChangeHistoryService:SetWaypoint("Reset Dialogue Maker scripts");
    
  end)

  -- Done!
  ResetScriptsButton.Enabled = true;
  print("[Dialogue Maker] " .. if Success then "Fixed Dialogue Maker scripts!" else ("Couldn't fix scripts: " .. Msg));

end);

local function refreshButtons()

  local themeName = settings().Studio.Theme.Name;
  EditDialogueButton.Icon = Icons[themeName].editDialogueButton;
  ResetScriptsButton.Icon = Icons[themeName].resetScriptsButton;

end;

settings().Studio.ThemeChanged:Connect(refreshButtons);