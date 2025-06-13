--!strict
-- This script is automatically generated and edited by the Dialogue Maker plugin.
-- If you want to edit this script, please do so using the plugin's interface, or mark this script as manually modified first.
-- Otherwise, your changes shall be sent to the grinder, and ruthlessly overwritten.
--
-- Sidenote: If you're a programmer, consider using the Dialogue Maker Kit directly instead of using the plugin.
-- It might be more suitable for your needs as it provides more flexibility, especially if you're using
-- external tools like Rojo to manage your code.
-- 
-- See documentation: https://github.com/DialogueMaker/conversation

local packages = script.Parent.Parent.DialogueMakerKit.Packages; -- Automatically replaced by the plugin.
local Dialogue = require(packages.Dialogue);
local Conversation = require(packages.Conversation);

local properties = {
  -- START REPLACEMENT
  -- END REPLACEMENT
}

local conversation = Conversation.new(properties, Dialogue.listFromInstance(script));

return conversation; 
