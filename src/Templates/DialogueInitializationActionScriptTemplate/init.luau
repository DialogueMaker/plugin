--!strict
-- This script defines an initialization action for a dialogue.
-- It is executed before the dialogue starts, allowing you to set up any necessary state or perform actions.
-- If the function returns true, the condition is met and the dialogue can proceed. Otherwise, the dialogue is skipped.
-- 
-- See documentation: https://github.com/DialogueMaker/dialogue

local packages = script.Parent.Parent.DialogueMakerKit.Packages; -- Automatically replaced by the plugin.
local DialogueMakerTypes = require(packages.DialogueMakerTypes);

type RunInitializationActionFunction = DialogueMakerTypes.RunInitializationActionFunction;

local runInitializationAction: RunInitializationActionFunction = function(self)

end;

return runInitializationAction; 
