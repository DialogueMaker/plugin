--!strict
-- This script defines a completion action for a dialogue.
-- It is executed after the theme finishes typing the dialogue, allowing you to perform any neccessary actions.
-- If the function returns true, the condition is met and the dialogue can proceed. Otherwise, the dialogue is skipped.
-- 
-- See documentation: https://github.com/DialogueMaker/dialogue

local packages = script.Parent.Parent.DialogueMakerKit.Packages; -- Automatically replaced by the plugin.
local DialogueMakerTypes = require(packages.DialogueMakerTypes);

type RunCompletionActionFunction = DialogueMakerTypes.RunCompletionActionFunction;

local runCompletionAction: RunCompletionActionFunction = function(self)

end;

return runCompletionAction; 
