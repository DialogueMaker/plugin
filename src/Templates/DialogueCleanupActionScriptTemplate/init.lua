--!strict
-- This script defines a cleanup action for a dialogue.
-- It is executed before the dialogue goes away, allowing you to clean up any state or perform actions.
-- If the function returns true, the condition is met and the dialogue can proceed. Otherwise, the dialogue is skipped.
-- 
-- See documentation: https://github.com/DialogueMaker/dialogue

local packages = script.Parent.Parent.DialogueMakerKit.Packages; -- Automatically replaced by the plugin.
local DialogueMakerTypes = require(packages.DialogueMakerTypes);

type RunCleanupActionFunction = DialogueMakerTypes.RunCleanupActionFunction;

local runCleanupAction: RunCleanupActionFunction = function(self)

end;

return runCleanupAction; 
