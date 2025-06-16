--!strict
-- This script is managed by the Dialogue Maker plugin.
-- If you want to edit this script, please do so using the plugin's interface, or mark this script as manually modified first.
-- Otherwise, your changes shall be sent to the grinder, and ruthlessly overwritten.
--
-- Sidenote: If you're a programmer, consider using the Dialogue Maker Kit directly instead of using the plugin.
-- It might be more suitable for your needs as it provides more flexibility, especially if you're using
-- external tools like Rojo to manage your code.
-- 
-- See documentation: https://github.com/DialogueMaker/dialogue

local packages = script.Parent.Parent.DialogueMakerKit.Packages; -- Automatically replaced by the plugin.
local Dialogue = require(packages.Dialogue);
local DialogueMakerTypes = require(packages.DialogueMakerTypes);

type Dialogue = DialogueMakerTypes.Dialogue;

local dialogueType = script:GetAttribute("DialogueType");
local properties = {
  type = dialogueType;
  -- START SETTINGS REPLACEMENT
  -- END SETTINGS REPLACEMENT
  -- START SCRIPT REPLACEMENT
  -- END SCRIPT REPLACEMENT
};

local content = script:GetAttribute("DialogueContent");

local children: {Dialogue} = {};
local redirectValue = script:FindFirstChild("RedirectValue");

if redirectValue and redirectValue:IsA("ObjectValue") and dialogueType == "Redirect" then

  if not redirectValue.Value then
    
    return;

  end;

  assert(redirectValue.Value:IsA("ModuleScript"), "RedirectValue must be a ModuleScript");

  local destinationDialogue = require(redirectValue.Value) :: Dialogue;

  table.insert(children, destinationDialogue);

else
  
  local messages = script:FindFirstChild("Messages");
  local responses = script:FindFirstChild("Responses");
  local redirects = script:FindFirstChild("Redirects");

  local function sortByPriority(dialogueA: ModuleScript, dialogueB: ModuleScript)
        
    local dialogueAPriority = tonumber(dialogueA.Name) or math.huge;
    local dialogueBPriority = tonumber(dialogueB.Name) or math.huge;
    
    return dialogueAPriority < dialogueBPriority;
    
  end;
  
  table.sort(messages, sortByPriority);
  table.sort(responses, sortByPriority);
  table.sort(redirects, sortByPriority);

  for _, folder in {redirects, responses, messages} do

    for _, childInstance in folder:GetChildren() do

      if not childInstance:IsA("ModuleScript") then
        
        continue;

      end;

      local childDialogue = require(childInstance) :: Dialogue;

      table.insert(children, childDialogue);

    end;

  end;

end;

local dialogue = Dialogue.new(content, properties, children);

return dialogue;