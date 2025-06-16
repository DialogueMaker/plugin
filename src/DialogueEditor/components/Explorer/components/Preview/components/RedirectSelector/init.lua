--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local ContentPreview = require(script.Parent.ContentPreview);
local Paragraph = require(root.DialogueEditor.components.Paragraph);
local InstanceInput = require(root.DialogueEditor.components.InstanceInput);

export type RedirectSelectorProperties = {
  selectedScript: ModuleScript;
  layoutOrder: number;
}

local function RedirectSelector(properties: RedirectSelectorProperties)

  local selectedScript = properties.selectedScript;
  local layoutOrder = properties.layoutOrder;
  
  local getDestinationScript = React.useCallback(function(): ModuleScript?

    local destinationScript = selectedScript:FindFirstChild("RedirectValue");
    if not destinationScript or not destinationScript:IsA("ObjectValue") or not destinationScript.Value or not destinationScript.Value:IsA("ModuleScript") then

      return;

    end

    return destinationScript.Value;

  end, {selectedScript});

  local destinationScript: ModuleScript?, setDestinationScript = React.useState(getDestinationScript());

  React.useEffect(function()

    local function refreshDestinationScript()

      setDestinationScript(getDestinationScript());
    
    end;

    refreshDestinationScript();
    local childAddedConnection = selectedScript.ChildAdded:Connect(refreshDestinationScript);
    local childRemovedConnection = selectedScript.ChildRemoved:Connect(refreshDestinationScript);

    return function()
      
      childAddedConnection:Disconnect();
      childRemovedConnection:Disconnect();
   
    end;
  
  end, {selectedScript :: unknown, getDestinationScript});

  local destinationDialogueType: string? = if destinationScript then destinationScript:GetAttribute("DialogueType") :: string? else nil;
  if typeof(destinationDialogueType) ~= "string" then

    destinationDialogueType = nil;

  end;

  return React.createElement(ContentPreview, {
    layoutOrder = layoutOrder;
  }, {
    NotificationLabel = React.createElement(Paragraph, {
      text = `The conversation should continue from the following {(destinationDialogueType or "dialogue"):lower()}:`;
      layoutOrder = 1;
    });
    NotificationButton = React.createElement(InstanceInput, {
      layoutOrder = 2;
      value = destinationScript :: Instance?;
      className = "ModuleScript";
      onChanged = function(instance)

        if instance and not instance:HasTag("DialogueMakerDialogueScript") then

          return;

        end;

        local destinationScriptValue = selectedScript:FindFirstChild("RedirectValue");
        if not destinationScriptValue then

          local newDestinationScriptValue = Instance.new("ObjectValue");
          newDestinationScriptValue.Name = "RedirectValue";
          newDestinationScriptValue.Parent = selectedScript;
          destinationScriptValue = newDestinationScriptValue;

        end;

        assert(destinationScriptValue and destinationScriptValue:IsA("ObjectValue"), "Expected RedirectValue to be an ObjectValue");

        destinationScriptValue.Value = instance;
        setDestinationScript(getDestinationScript());

      end;
    });
  });

end;

return React.memo(RedirectSelector);