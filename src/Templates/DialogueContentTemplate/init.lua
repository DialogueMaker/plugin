--!strict
-- This script is describes the content of a message or a response.
-- It is dynamic, meaning it can be changed at runtime. This is useful for localization, effects, and other dynamic content.
-- To protect you from malicious code running with plugin-level access, the Dialogue Maker plugin cannot preview this script.
-- 
-- See documentation: https://github.com/DialogueMaker/dialogue

local packages = script.Parent.Parent.DialogueMakerKit.Packages; -- Automatically replaced by the plugin.
local DialogueMakerTypes = require(packages.DialogueMakerTypes);

type GetContentFunction = DialogueMakerTypes.GetContentFunction;

local getContent: GetContentFunction = function(self)

  return {"Hello world!"};

end;

return getContent; 
