--!strict
-- This script is managed by the Dialogue Maker plugin.
-- If you want to edit this script, please do so using the plugin's interface, or mark this script as manually modified first.
-- Otherwise, your changes shall be sent to the grinder, and ruthlessly overwritten.
--
-- Sidenote: If you're a programmer, consider using the Dialogue Maker Kit directly instead of using the plugin.
-- It might be more suitable for your needs as it provides more flexibility, especially if you're using
-- external tools like Rojo to manage your code.
-- 
-- See documentation: https://github.com/DialogueMaker/conversation

local packages = script.Parent.Parent.DialogueMakerKit.Packages; -- Automatically replaced by the plugin.
local Conversation = require(packages.Conversation);
local DialogueMakerTypes = require(packages.DialogueMakerTypes);

type Dialogue = DialogueMakerTypes.Dialogue;

local properties = {
  -- START SETTINGS REPLACEMENT
  -- END SETTINGS REPLACEMENT
}

local children = {};

local messagesFolder = script:FindFirstChild("Messages");
local responsesFolder = script:FindFirstChild("Responses");
local redirectsFolder = script:FindFirstChild("Redirects");
local messages = if messagesFolder then messagesFolder:GetChildren() else {};
local responses = if responsesFolder then responsesFolder:GetChildren() else {};
local redirects = if redirectsFolder then redirectsFolder:GetChildren() else {};

local function sortByPriority(dialogueA: ModuleScript, dialogueB: ModuleScript)
      
  local dialogueAPriority = tonumber(dialogueA.Name) or math.huge;
  local dialogueBPriority = tonumber(dialogueB.Name) or math.huge;
  
  return dialogueAPriority < dialogueBPriority;
  
end;

table.sort(messages, sortByPriority);
table.sort(responses, sortByPriority);
table.sort(redirects, sortByPriority);

for _, folder in {redirectsFolder, responsesFolder, messagesFolder} do

  for _, childInstance in folder:GetChildren() do

    if not childInstance:IsA("ModuleScript") then
      
      continue;

    end;

    local childDialogue = require(childInstance) :: Dialogue;

    table.insert(children, childDialogue);

  end;

end;

local conversation = Conversation.new(properties, children);

return conversation; 
