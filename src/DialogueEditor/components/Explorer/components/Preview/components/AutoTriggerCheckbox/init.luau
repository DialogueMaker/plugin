--!strict

local CollectionService = game:GetService("CollectionService");
local StarterPlayer = game:GetService("StarterPlayer");

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Checkbox = require(root.DialogueEditor.components.Checkbox);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);

export type AutoTriggerCheckboxProperties = {
  layoutOrder: number;
  selectedScript: ModuleScript;
}

local function AutoTriggerCheckbox(properties: AutoTriggerCheckboxProperties)

  local selectedScript = properties.selectedScript;
  local layoutOrder = properties.layoutOrder;
  local shouldAutoTriggerConversation, setShouldAutoTriggerConversation = React.useState(selectedScript:GetAttribute("ShouldAutoTriggerConversation"));
  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();

  React.useEffect(function()

    local autoTriggerConnection = selectedScript:GetAttributeChangedSignal("ShouldAutoTriggerConversation"):Connect(function()

      setShouldAutoTriggerConversation(selectedScript:GetAttribute("ShouldAutoTriggerConversation"));

    end);

    return function()

      autoTriggerConnection:Disconnect();

    end;

  end, {selectedScript});

  return React.createElement(Checkbox, {
    text = "Auto-trigger";
    isChecked = shouldAutoTriggerConversation;
    layoutOrder = layoutOrder;
    onChanged = function(isChecked: boolean)

      local historyIdentifier = beginHistoryRecording("Set auto-trigger conversation");

      selectedScript:SetAttribute("ShouldAutoTriggerConversation", isChecked);

      local loaderScript: Instance? = CollectionService:GetTagged("DialogueMakerLoader")[1];
      if isChecked then

        if not loaderScript then

          local newLoaderScript = root.Templates.LoaderTemplate:Clone();
          newLoaderScript.Name = "DialogueLoader";
          newLoaderScript:AddTag("DialogueMakerLoader");
          newLoaderScript.Parent = StarterPlayer.StarterPlayerScripts;
          loaderScript = newLoaderScript;

        end;

        assert(loaderScript and loaderScript:IsA("LocalScript"), "Loader script not found even after creating a new one. Huh!?");

        loaderScript.Enabled = true;

      elseif loaderScript and loaderScript:IsA("LocalScript") then

        -- Don't disable the loader script if any conversation is still set to auto-trigger.
        for _, conversationScript in CollectionService:GetTagged("DialogueMakerConversationScript") do

          if conversationScript:GetAttribute("ShouldAutoTriggerConversation") then
            
            return; 

          end;

        end;
        
        loaderScript.Enabled = false;

      end;

      finishHistoryRecording(historyIdentifier);

    end;
  });

end;

return React.memo(AutoTriggerCheckbox);