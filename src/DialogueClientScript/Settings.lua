--!strict
local Types = require(script.Parent.types);
type ClientSettings = Types.ClientSettings;

local Settings: ClientSettings = {

  -- [ Theme Settings ] --
  defaultTheme = "BareBonesTheme";

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