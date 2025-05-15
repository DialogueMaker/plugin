--!strict
local Selection = game:GetService("Selection");
local StarterPlayer = game:GetService("StarterPlayer");
local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts");
local ChangeHistoryService = game:GetService("ChangeHistoryService");

local Icons = require(script.Icons);
local React = require(script.Packages.react);
local ReactRoblox = require(script.Packages["react-roblox"]);
local Window = require(script.Window);

local EditDialogueButton: PluginToolbarButton;
local PluginGui: DockWidgetPluginGui?;

local function getSelectedModel(): Model?

  local selectedObjects = Selection:Get();
  if #selectedObjects ~= 1 then return nil; end;
  
  local model = selectedObjects[1];
  if not model:IsA("Model") then return nil; end;
  
  return model;

end;

-- Closes the editor when called
-- @since v1.0.0
local function closeDialogueEditor(): ()

  if PluginGui then 

    PluginGui:Destroy();
    PluginGui = nil;

  end;
  EditDialogueButton:SetActive(false);
  EditDialogueButton.Enabled = getSelectedModel() ~= nil;

end;

local function repairNPC(model: Model): ()

  if not model:FindFirstChild("DialogueContainer") then

    -- Add the dialogue container to the NPC
    local DialogueContainer = Instance.new("Folder");
    DialogueContainer.Name = "DialogueContainer";

    -- Add the dialogue folder to the model
    DialogueContainer.Parent = model;
    return;

  end;
  
  if not model:FindFirstChild("NPCDialogueSettings") then

    print(`[Dialogue Maker] Adding settings script to {model.Name}`);

    local SettingsScript = script.Templates.NPCSettingsTemplate:Clone();
    SettingsScript.Name = "NPCDialogueSettings";
    SettingsScript.Parent = model;

    print(`[Dialogue Maker] Added settings script to {model.Name}`)

  end;

  -- Initialize dialogue locations for indexing.
  model:AddTag("DialogueMakerNPC");

end;

-- Open the editor when called.
-- @since v1.0.0
local function openDialogueEditor(model: Model): ()

  PluginGui = plugin:CreateDockWidgetPluginGui(
    `Dialogue Maker - Model "{model.Name}"`, 
    DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, 512, 241, 512, 150));
  if PluginGui then

    PluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    PluginGui.Title = `Dialogue Maker - Model "{model.Name}"`;
    PluginGui:BindToClose(closeDialogueEditor);
    
    local pluginGUIRoot = ReactRoblox.createRoot(PluginGui);
    pluginGUIRoot:render(React.createElement(Window, {
      plugin = plugin;
      model = model;
      repairNPC = function()

        repairNPC(model);

      end;
    }));
    
  end;

end;

local Toolbar = plugin:CreateToolbar("Dialogue Maker by Beastslash");

local themeName = settings().Studio.Theme.Name;
EditDialogueButton = Toolbar:CreateButton("Edit Dialogue", "Edit dialogue of a selected NPC. The selected object must be a singular model.", Icons[themeName].editDialogueButton);
EditDialogueButton.Click:Connect(function()

  if PluginGui then
    
    closeDialogueEditor();
    return;
    
  end;

  local model: Model;
  local isTestSuccessful, errorMessage = pcall(function()
    
    -- Check if the user is selecting an object.
    local SelectedObjects = Selection:Get();
    assert(#SelectedObjects ~= 0, "You didn't select an model.");
    assert(#SelectedObjects == 1, "You must select one model; not multiple models.");

    -- Check if the model has a part
    model = SelectedObjects[1]
    assert(model:IsA("Model"), `You must select a model, not a {model.ClassName}.`);

    local ModelHasPart = false;
    for _, object in model:GetChildren() do
      
      if object:IsA("BasePart") then
        
        ModelHasPart = true;
        break;
        
      end
      
    end;

    assert(ModelHasPart, "Your selected model doesn't have a part inside of it.");
    
  end);
  
  if not isTestSuccessful then

    EditDialogueButton:SetActive(false);
    error("[Dialogue Maker] " .. errorMessage, 0);
    
  end

  -- Verify NPC dialogue folder
  repairNPC(model);

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
  openDialogueEditor(model);

end);
EditDialogueButton:SetActive(PluginGui ~= nil);

Selection.SelectionChanged:Connect(function()

  EditDialogueButton.Enabled = PluginGui ~= nil or getSelectedModel() ~= nil;

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

local RemoveUnusedInstancesButton = Toolbar:CreateButton("Remove Unused Instances", "Deletes unused actions, conditions, and dialogue locations.", Icons[themeName].removeUnusedInstancesButton)
RemoveUnusedInstancesButton.Click:Connect(function()

  RemoveUnusedInstancesButton.Enabled = false;

  local count = 0;
  pcall(function()

    -- Set an undo point
    ChangeHistoryService:SetWaypoint("Removing unused Dialogue Maker instances");

    -- Remove the unused instances
    for _, folder in StarterPlayerScripts.DialogueClientScript:GetChildren() do

      if not folder:IsA("Folder") then

        continue;

      end

      for _, child in folder:GetChildren() do

        if folder.Name == "Actions" then

          for _, module in child:GetChildren() do

            local NPC = module:FindFirstChild("NPC");
            if not NPC or not NPC.Value or not NPC.Value.Parent then

              count += 1;
              module:Destroy();

            end

          end

        elseif not child.Value or not child.Value.Parent then

          count += 1;
          child:Destroy();

        end;

      end;

    end;

    -- Finalize the undo point
    ChangeHistoryService:SetWaypoint("Removed unused Dialogue Maker instances");
  end)

  -- Done!
  RemoveUnusedInstancesButton.Enabled = true;
  local plural = if count ~= 1 then "s" else "";
  print(`[Dialogue Maker] Removed unused {count} Dialogue Maker instance{plural}!`)

end);

local function refreshButtons()

  local themeName = settings().Studio.Theme.Name;
  EditDialogueButton.Icon = Icons[themeName].editDialogueButton;
  ResetScriptsButton.Icon = Icons[themeName].resetScriptsButton;
  RemoveUnusedInstancesButton.Icon = Icons[themeName].removeUnusedInstancesButton;

end;

settings().Studio.ThemeChanged:Connect(refreshButtons);