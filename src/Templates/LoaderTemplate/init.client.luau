--!strict
-- This script is managed by the Dialogue Maker plugin.
-- If you want to edit this script, please do so using the plugin's interface, or mark this script as manually modified first.
-- Otherwise, your changes shall be sent to the grinder, and ruthlessly overwritten.
--
-- Sidenote: If you're a programmer, consider using the Dialogue Maker Kit directly instead of using the plugin.
-- It might be more suitable for your needs as it provides more flexibility, especially if you're using
-- external tools like Rojo to manage your code.

local CollectionService = game:GetService("CollectionService");

local packages = script.Parent.Parent.DialogueMakerKit.Packages; -- Automatically replaced by the plugin.
local Client = require(packages.Client);
local DialogueMakerTypes = require(packages.DialogueMakerTypes);

type Conversation = DialogueMakerTypes.Conversation;

local triggerTasks: {thread} = {};

local function refreshTriggers()

  for _, triggerTask in triggerTasks do

    if coroutine.status(triggerTask) == "running" then

      task.cancel(triggerTask);

    end;

  end;

  triggerTasks = {};

  for _, possibleConversationScript in CollectionService:GetTagged("DialogueMakerConversationScript") do

    local triggerTask = task.spawn(function()

      while possibleConversationScript:IsA("ModuleScript") and possibleConversationScript:GetAttribute("ShouldAutoTriggerConversation") do

        -- Get the proximity prompt location from the script.
        local proximityPromptLocation = possibleConversationScript:FindFirstChild("ProximityPromptLocation");
        local proximityPrompt: ProximityPrompt?;
        if proximityPromptLocation and proximityPromptLocation:IsA("ObjectValue") then

          proximityPrompt = proximityPromptLocation.Value;

        end;
        
        if not proximityPrompt then

          local parent = possibleConversationScript;
          repeat
            
            parent = parent.Parent;
          
          until not parent or (parent:IsA("Model") and parent.PrimaryPart) or parent:IsA("BasePart");

          assert(parent, "No valid parent found for proximity prompt in conversation script: " .. possibleConversationScript.Name);

          local newProximityPrompt = Instance.new("ProximityPrompt");
          newProximityPrompt.Parent = parent;
          proximityPrompt = newProximityPrompt;

          local newProximityPromptLocation = Instance.new("ObjectValue");
          newProximityPromptLocation.Name = "ProximityPromptLocation";
          newProximityPromptLocation.Value = proximityPrompt;
          newProximityPromptLocation.Parent = possibleConversationScript;

        end;

        assert(proximityPrompt, `No proximity prompt found at {possibleConversationScript:GetFullName()}.`);

        -- Disable the prompt to prevent multiple triggers after the proximity prompt is triggered.
        proximityPrompt.Triggered:Wait();
        
        local oldProximityPromptState = proximityPrompt.Enabled;
        proximityPrompt.Enabled = false; 

        -- Load the conversation.
        local conversation = require(possibleConversationScript) :: Conversation;
        local client = Client.new({
          dialogue = conversation:getNextVerifiedDialogue();
          -- START SETTINGS REPLACEMENT
          settings = {
            theme = {
              component = require(packages.StandardTheme);
            };
          };
          -- END SETTINGS REPLACEMENT
        });

        client.dialogueGUI.Destroying:Wait();
        
        proximityPrompt.Enabled = oldProximityPromptState;

      end

    end);

    table.insert(triggerTasks, triggerTask);

  end

end;

CollectionService:GetInstanceAddedSignal("DialogueMakerConversationScript"):Connect(refreshTriggers);
CollectionService:GetInstanceRemovedSignal("DialogueMakerConversationScript"):Connect(refreshTriggers);
refreshTriggers();