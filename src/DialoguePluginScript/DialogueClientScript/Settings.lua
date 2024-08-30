--!strict
local Types = require(script.Parent.Types);
type ClientSettings = Types.ClientSettings;

local Settings: ClientSettings = {

  -- [ Theme Settings ] --
  defaultTheme = "BigAndBoldDialogue";

  -- [ Response Settings ] --
  showResponsesAfterMessageFinished = true; 
  defaultClickSound = 0; 

  -- [ Chat Triggers and Keybinds ] --
  minimumDistanceFromCharacter = 10; 
  keybindsEnabled = true; 
  defaultChatTriggerKey = Enum.KeyCode.F; 
  defaultChatTriggerKeyGamepad = Enum.KeyCode.ButtonX; 
  defaultChatContinueKey = Enum.KeyCode.F; 
  defaultChatContinueKeyGamepad = Enum.KeyCode.ButtonA; 

};

return Settings;