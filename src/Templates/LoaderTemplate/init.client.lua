--!strict
-- This script is automatically generated and edited by the Dialogue Maker plugin.
-- If you want to edit this script, please do so using the plugin's interface, or mark this script as manually modified first.
-- Otherwise, your changes shall be sent to the grinder, and ruthlessly overwritten.
--
-- Sidenote: If you're a programmer, consider using the Dialogue Maker Kit directly instead of using the plugin.
-- It might be more suitable for your needs as it provides more flexibility, especially if you're using
-- external tools like Rojo to manage your code.
-- 
-- See documentation: https://github.com/DialogueMaker/dialogue

local CollectionService = game:GetService("CollectionService");

local packages = script.Parent.Parent.DialogueMakerKit.Packages; -- Automatically replaced by the plugin.
local Client = require(packages.Client);
local DialogueMakerTypes = require(packages.DialogueMakerTypes);

local ThemeComponent = require(packages.StandardTheme); -- Automatically replaced by the plugin.

type Conversation = DialogueMakerTypes.Conversation;

for _, possibleConversationScript in CollectionService:GetTagged("DialogueMakerConversationScript") do

  task.spawn(function()

    while possibleConversationScript:IsA("ModuleScript") and possibleConversationScript:GetAttribute("ShouldAutoLoad") do

      -- Get the proximity prompt location from the script.
      local proximityPromptLocation = possibleConversationScript:FindFirstChild("ProximityPromptLocation");
      local proximityPrompt: ProximityPrompt;
      if proximityPromptLocation and proximityPromptLocation:IsA("ObjectValue") then

        proximityPrompt = proximityPromptLocation.Value;

      end;

      assert(proximityPrompt and proximityPrompt:IsA("ProximityPrompt"), "");

      -- Disable the prompt to prevent multiple triggers after the proximity prompt is triggered.
      proximityPrompt.Triggered:Wait();
      
      local oldProximityPromptState = proximityPrompt.Enabled;
      proximityPrompt.Enabled = false; 

      -- Load the conversation.
      local conversation = require(possibleConversationScript) :: Conversation;
      local client = Client.new({
        dialogue = conversation:getNextVerifiedDialogue();
        -- START REPLACEMENT
        settings = {
          theme = {
            component = ThemeComponent;
          };
        };
      });

      client.dialogueGUI.Destroying:Wait();
      
      proximityPrompt.Enabled = oldProximityPromptState;

    end

  end);

end