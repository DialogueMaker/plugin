--!strict
-- This script defines a condition for a dialogue.
-- If the function returns true, the condition is met and the dialogue can proceed. Otherwise, the dialogue is skipped.
-- 
-- See documentation: https://github.com/DialogueMaker/dialogue

local packages = script.Parent.Parent.DialogueMakerKit.Packages; -- Automatically replaced by the plugin.
local DialogueMakerTypes = require(packages.DialogueMakerTypes);

type VerifyConditionFunction = DialogueMakerTypes.VerifyConditionFunction;

local verifyCondition: VerifyConditionFunction = function(self)

  return true;

end;

return verifyCondition; 
