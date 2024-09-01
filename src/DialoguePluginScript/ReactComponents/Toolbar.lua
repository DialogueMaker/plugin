--!strict
local React = require(script.Parent.Parent.Packages.react);
local ToolbarButton = require(script.Parent.ToolbarButton);

type ToolbarProps = {
  dialogueParent: ModuleScript | Folder;
  setDialogueParent: (ModuleScript | Folder) -> ();
  selectedNPCModel: Model;
  repairSelectedNPC: () -> ();
  isDeleteModeEnabled: boolean;
  setIsDeleteModeEnabled: (boolean) -> ();
}

local function Toolbar(props: ToolbarProps)

  local dialogueParent = props.dialogueParent;

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 40);
    LayoutOrder = 1;
    BackgroundColor3 = Color3.fromRGB(74, 74, 74);
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

        props.setDialogueParent(props.dialogueParent);

      end;
    });
    AddMessageButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14099284898";
      text = "Add message";
      layoutOrder = 2;
      onClick = function()

        -- Find a name for the content script.
        local targetPriority = 1;
        for _, instance in dialogueParent:GetChildren() do
          
          local comparedName = tonumber(instance.Name);
          if comparedName and comparedName >= targetPriority then
            
            targetPriority = comparedName + 1;
            
          end
          
        end;
        
        -- Create the content script.
        local MessageContentScript = script.Parent.Parent.Templates.ContentTemplate:Clone();
        MessageContentScript.Name = targetPriority;
        MessageContentScript:SetAttribute("DialogueType", "Message");
        MessageContentScript.Parent = dialogueParent;

      end;
    });
    AdjustSettingsButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14099277263";
      text = "Adjust settings";
      layoutOrder = 3;
      onClick = function()

        props.repairSelectedNPC();

        local npcDialogueSettingsScript = props.selectedNPCModel:FindFirstChild("NPCDialogueSettings") :: Script;
        plugin:OpenScript(npcDialogueSettingsScript);

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
    ManualButton = React.createElement(ToolbarButton, {
      iconImage = "rbxassetid://14103671946";
      text = "View manual";
      layoutOrder = 5;
    });
  });

end;

return Toolbar;