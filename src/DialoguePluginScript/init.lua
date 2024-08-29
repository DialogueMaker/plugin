--!strict
local Selection = game:GetService("Selection");
local StarterPlayer = game:GetService("StarterPlayer");
local StarterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts");
local ChangeHistoryService = game:GetService("ChangeHistoryService");

local CurrentDialogueContainer: ModuleScript?;
local Model;
local Window = require(script.ReactComponents.Window);

local React = require(script.Packages.react);
local ReactRoblox = require(script.Packages["react-roblox"]);

type EventTypes = {
  AddMessage: RBXScriptConnection?;
  AdjustSettingsRequested: RBXScriptConnection?;
  AttributeChanged: {RBXScriptConnection?};
  ChildAdded: RBXScriptConnection?;
  ChildRemoved: RBXScriptConnection?;
  DeleteMode: RBXScriptConnection?;
  DeleteYesButton: RBXScriptConnection?;
  DeleteNoButton: RBXScriptConnection?;
  PriorityFocusLost: {RBXScriptConnection?};
  TypeDropdown: {RBXScriptConnection?};
  ViewChildren: {RBXScriptConnection?};
  ViewContent: {RBXScriptConnection?};
  ViewParent: RBXScriptConnection?;
};

local Toolbar = plugin:CreateToolbar("Dialogue Maker by Beastslash");
local EditDialogueButton = Toolbar:CreateButton("Edit Dialogue", "Edit dialogue of a selected NPC. The selected object must be a singular model.", "rbxassetid://14109181603");
local isDialogueEditorOpen = false;

local PluginGui: DockWidgetPluginGui?;

-- Closes the editor when called
-- @since v1.0.0
local function closeDialogueEditor(): ()

  if PluginGui then PluginGui:Destroy(); end;
  EditDialogueButton:SetActive(false);
  isDialogueEditorOpen = false;

end;

-- Open the editor when called.
-- @since v1.0.0
local function openDialogueEditor(): ()

  PluginGui = plugin:CreateDockWidgetPluginGui("Dialogue Maker", DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, true, 525, 241, 525, 139));
  if PluginGui and CurrentDialogueContainer then

    PluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    PluginGui.Title = "Dialogue Maker";
    PluginGui:BindToClose(closeDialogueEditor);
    
    local pluginGUIRoot = ReactRoblox.createRoot(PluginGui);
    pluginGUIRoot:render(React.createElement(Window, {
      model = Model;
    }));
    
  end;

end;

-- Catch the button click event
EditDialogueButton.Click:Connect(function()

  if isDialogueEditorOpen then
    
    closeDialogueEditor();
    return;
    
  end;

  local isTestSuccessful, errorMessage = pcall(function()
    
    -- Check if the user is selecting an object.
    local SelectedObjects = Selection:Get();
    assert(#SelectedObjects ~= 0, "You didn't select an object.");
    assert(#SelectedObjects == 1, "You must select one object; not multiple objects.");

    -- Check if the model has a part
    Model = SelectedObjects[1];
    assert(Model:IsA("Model"), "You must select a Model, not a "..Model.ClassName..".");

    local ModelHasPart = false;
    for _, object in Model:GetChildren() do
      
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
  local function repairNPC(): ()

    if not Model:FindFirstChild("DialogueContainer") then
  
      -- Add the dialogue container to the NPC
      local DialogueContainer = Instance.new("Folder");
      DialogueContainer.Name = "DialogueContainer";
  
      -- Add the dialogue folder to the model
      DialogueContainer.Parent = Model;
      return;
  
    end;
  
    CurrentDialogueContainer = Model:FindFirstChild("DialogueContainer") :: ModuleScript;
    assert(CurrentDialogueContainer, "[Dialogue Maker] DialogueContainer not found...");
    
    if not Model:FindFirstChild("NPCDialogueSettings") then
  
      print("[Dialogue Maker] Adding settings script to "..Model.Name)
  
      local SettingsScript = script.NPCSettingsTemplate:Clone();
      SettingsScript.Name = "NPCDialogueSettings";
      SettingsScript.Parent = Model;
  
      print("[Dialogue Maker] Added settings script to "..Model.Name)
  
    end;
  
    -- Initialize DialogueLocations.
    local DialogueClientScript = StarterPlayerScripts:FindFirstChild("DialogueClientScript");
  
    assert(DialogueClientScript, "[Dialogue Maker] DialogueClientScript wasn't found in the StarterPlayerScripts! \nPlease replace the script by pressing the \"Fix Scripts\" button.");
  
    for _, dialogueLocation in DialogueClientScript.DialogueLocations:GetChildren() do
      
      if dialogueLocation.Value == Model then
        
        return;
        
      end
      
    end;
  
    local DialogueLocation = Instance.new("ObjectValue");
    DialogueLocation.Value = Model;
    DialogueLocation.Name = "DialogueLocation";
    DialogueLocation.Parent = DialogueClientScript.DialogueLocations;
  
  end;

  repairNPC();

  -- Add the chat receiver script in the starter player scripts
  if not StarterPlayerScripts:FindFirstChild("DialogueClientScript") then

    print("[Dialogue Maker] Adding DialogueClientScript to the StarterPlayerScripts...");
    local DialogueClientScript = script.DialogueClientScript:Clone()
    DialogueClientScript.Parent = StarterPlayerScripts;
    DialogueClientScript.Disabled = false;
    print("[Dialogue Maker] Added DialogueClientScript to the StarterPlayerScripts.");
    
    -- Add this model to the DialogueManager
    local DialogueLocation = Instance.new("ObjectValue");
    DialogueLocation.Value = Model;
    DialogueLocation.Name = "DialogueLocation";
    DialogueLocation.Parent = DialogueClientScript.DialogueLocations;

  end;

  -- Now we can open the dialogue editor.
  openDialogueEditor();

end);

local ResetScriptsButton = Toolbar:CreateButton("Fix Scripts", "Reset DialogueMakerSharedDependencies and DialogueClientScript back to the a stable version.", "rbxassetid://14109193905");
ResetScriptsButton.Click:Connect(function()

  -- Debounce
  ResetScriptsButton.Enabled = false;

  local Success, Msg = pcall(function()
    -- Set an undo point
    ChangeHistoryService:SetWaypoint("Resetting Dialogue Maker scripts");

    -- Make copies
    local NewDialogueClientScript = script.DialogueClientScript:Clone();
    local ClientAPI = NewDialogueClientScript.API:Clone();
    local NewThemes = NewDialogueClientScript.Themes:Clone();

    -- Save the old copies
    local OldDialogueClientScript = StarterPlayerScripts:FindFirstChild("DialogueClientScript") or NewDialogueClientScript:Clone();

    -- Remove the children from the new copies
    for _, child in OldDialogueClientScript:GetChildren() do
      
      child.Parent = nil;
      
    end;

    -- Enable the scripts
    OldDialogueClientScript.Disabled = false;

    -- Check for themes
    local OldThemes = OldDialogueClientScript:FindFirstChild("Themes");
    if not OldThemes then
      
      NewThemes.Parent = OldDialogueClientScript;
      
    end;

    -- Check for API
    local OldAPI = OldDialogueClientScript:FindFirstChild("API");
    if OldAPI then
      
      OldAPI.Parent = nil;
      
    end

    -- Take the children from the old scripts
    for _, Child in OldDialogueClientScript:GetChildren() do
      
      Child.Parent = NewDialogueClientScript;
      
    end;

    -- Delete the old scripts
    OldDialogueClientScript.Parent = nil;

    -- Put the new instances in their places
    NewDialogueClientScript.Parent = StarterPlayerScripts;
    ClientAPI.Parent = NewDialogueClientScript;

    -- Finalize the undo point
    ChangeHistoryService:SetWaypoint("Reset Dialogue Maker scripts");
    
  end)

  -- Done!
  ResetScriptsButton.Enabled = true;
  print("[Dialogue Maker] " .. if Success then "Fixed Dialogue Maker scripts!" else ("Couldn't fix scripts: " .. Msg));

end);

local RemoveUnusedInstancesButton = Toolbar:CreateButton("Remove Unused Instances", "Deletes unused actions, conditions, and dialogue locations.", "rbxassetid://14109207161")
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
              module.Parent = nil;

            end

          end

        elseif folder.Name ~= "DialogueLocations" then

          local NPC = child:FindFirstChild("NPC");
          if not NPC or not NPC.Value or not NPC.Value.Parent then

            count += 1;
            child.Parent = nil;

          end

        elseif not child.Value or not child.Value.Parent then

          count += 1;
          child.Parent = nil;

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