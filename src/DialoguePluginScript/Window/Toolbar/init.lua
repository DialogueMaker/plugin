--!strict
local ChangeHistoryService = game:GetService("ChangeHistoryService");

local React = require(script.Parent.Parent.Packages.react);
local ToolbarButton = require(script.ToolbarButton);
local useStudioColors = require(script.Parent.Parent.useStudioColors);

type ToolbarProps = {
  dialogueParent: ModuleScript | Folder;
  setDialogueParent: (ModuleScript | Folder) -> ();
  model: Model;
  repairNPC: () -> ();
  isDeleteModeEnabled: boolean;
  setIsDeleteModeEnabled: (boolean) -> ();
  plugin: Plugin;
}

local function Toolbar(props: ToolbarProps)

  local colors = useStudioColors();
  local dialogueParent = props.dialogueParent;

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 40);
    LayoutOrder = 1;
    BackgroundColor3 = colors.toolbar;
    BorderSizePixel = 0;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
    });
    ViewParentButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14098871159";
      text = "View parent";
      layoutOrder = 1;
      isDisabled = dialogueParent:IsA("Folder");
      onClick = function()

        props.setDialogueParent(props.dialogueParent.Parent :: ModuleScript | Folder);

      end;
    });
    AddMessageButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14099284898";
      text = "Add message";
      layoutOrder = 2;
      onClick = function()

        local identifier = ChangeHistoryService:TryBeginRecording("Add message to NPC");
        if ChangeHistoryService:IsRecordingInProgress(identifier) then

          ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);
          identifier = ChangeHistoryService:TryBeginRecording("Delete dialogue item");
          assert(identifier, "[Dialogue Maker] ChangeHistoryService failed to begin recording.");

        end;

        -- Ensure the NPC is properly configured.
        props.repairNPC();

        -- Find a name for the content script.
        local targetPriority = 1;
        for _, instance in dialogueParent:GetChildren() do
          
          local comparedName = tonumber(instance.Name);
          if comparedName and comparedName >= targetPriority then
            
            targetPriority = comparedName + 1;
            
          end
          
        end;
        
        -- Create the content script.
        local MessageContentScript = script.Parent.Parent.Templates.DialogueTemplate:Clone();
        MessageContentScript.Name = targetPriority;
        MessageContentScript:SetAttribute("DialogueType", "Message");
        MessageContentScript.Parent = dialogueParent;

        ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit);

      end;
    });
    AdjustSettingsButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14099277263";
      text = "Adjust settings";
      layoutOrder = 3;
      onClick = function()

        props.repairNPC();

        local npcDialogueSettingsScript = props.model:FindFirstChild("NPCDialogueSettings") :: Script;
        props.plugin:OpenScript(npcDialogueSettingsScript);

      end;
    });
    ToggleDeleteModeButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14099268988";
      text = "Toggle delete mode";
      layoutOrder = 4;
      BackgroundColor3 = if props.isDeleteModeEnabled then Color3.fromRGB(217, 39, 39) else nil;
      isHighlighted = props.isDeleteModeEnabled;
      onClick = function()
    
        local isDeleteModeEnabled = not props.isDeleteModeEnabled;
        props.setIsDeleteModeEnabled(isDeleteModeEnabled);
        print("[Dialogue Maker] " .. if isDeleteModeEnabled then "Warning: Delete Mode has been enabled!" else "Whew. Delete Mode has been disabled.");

      end;
    });
  });

end;

return Toolbar;