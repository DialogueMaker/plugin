--!strict

local root = script.Parent.Parent.Parent.Parent;
local Client = require(root.DialogueMakerKit.Packages.Client);
local Conversation = require(root.DialogueMakerKit.Packages.Conversation);
local Dialogue = require(root.DialogueMakerKit.Packages.Dialogue);

local function validateKey(key: string?): ()
  
  if not key then
    
    return;

  end

  local keyCode = Enum.KeyCode:FromName(key);

  assert(keyCode, `Invalid key: {key}`);
  
end

local metadata = {
  loader = {
    keybinds = {
      interactKey = {
        name = "Action key";
        description = "The key that the player can press to interact with the dialogue.";
        type = "string";
        defaultValue = Client.defaultSettings.keybinds.interactKey.Name;
        validator = validateKey;
      };
      interactKeyGamepad = {
        name = "Gamepad action key";
        description = "The key that the player can press on a gamepad to interact with the dialogue.";
        type = "string";
        defaultValue = Client.defaultSettings.keybinds.interactKeyGamepad.Name;
        validator = validateKey;
      };
    };
    theme = {
      componentScript = {
        name = "Component script";
        description = "The script that contains the theme component.";
        type = "Instance";
        className = "ModuleScript";
      };
    };
    typewriter = {
      canPlayerSkipDelay = {
        name = "Allow player to skip delay";
        description = "If enabled, the player can skip the delay between characters being typed out in the conversation.";
        type = "boolean";
        defaultValue = Client.defaultSettings.typewriter.canPlayerSkipDelay;
      };
      characterDelaySeconds = {
        name = "Character delay in seconds";
        description = "The delay between each character being typed out in the conversation.";
        type = "number";
        defaultValue = Client.defaultSettings.typewriter.characterDelaySeconds;
      };
      shouldShowResponseWhileTyping = {
        name = "Show response while typing";
        description = "If enabled, responses will be shown while the typewriter effect is typing out the text.";
        type = "boolean";
        defaultValue = Client.defaultSettings.typewriter.shouldShowResponseWhileTyping;
      };
    };
  };
  conversation = {
    speaker = {
      name = {
        name = "Speaker name";
        description = "The name of the speaker in the conversation.";
        type = "string";
        defaultValue = Conversation.defaultSettings.speaker.name;
      }
    };
    theme = {
      componentScript = {
        name = "Component script";
        type = "Instance";
        description = "The script that contains the theme component.";
        className = "ModuleScript";
      };
    };
    typewriter = {
      canPlayerSkipDelay = {
        name = "Allow player to skip delay";
        description = "If enabled, the player can skip the delay between characters being typed out in the conversation.";
        type = "boolean";
        defaultValue = Conversation.defaultSettings.typewriter.canPlayerSkipDelay;
      };
      characterDelaySeconds = {
        name = "Character delay in seconds";
        description = "The delay between each character being typed out in the conversation.";
        type = "number";
        defaultValue = Conversation.defaultSettings.typewriter.characterDelaySeconds;
      };
      shouldShowResponseWhileTyping = {
        name = "Show response while typing";
        description = "If enabled, responses will be shown while the typewriter effect is typing out the text.";
        type = "boolean";
        defaultValue = Conversation.defaultSettings.typewriter.shouldShowResponseWhileTyping;
      };
    };
  };
  dialogue = {
    theme = {
      componentScript = {
        name = "Component script";
        type = "Instance";
        description = "The script that contains the theme component.";
        className = "ModuleScript";
      };
    };
    typewriter = {
      canPlayerSkipDelay = {
        name = "Allow player to skip delay";
        description = "If enabled, the player can skip the delay between characters being typed out in the conversation.";
        type = "boolean";
        defaultValue = Dialogue.defaultSettings.typewriter.canPlayerSkipDelay;
      };
      characterDelaySeconds = {
        name = "Character delay in seconds";
        description = "The delay between each character being typed out in the conversation.";
        type = "number";
        defaultValue = Dialogue.defaultSettings.typewriter.characterDelaySeconds;
      };
      shouldShowResponseWhileTyping = {
        name = "Show response while typing";
        description = "If enabled, responses will be shown while the typewriter effect is typing out the text.";
        type = "boolean";
        defaultValue = Dialogue.defaultSettings.typewriter.shouldShowResponseWhileTyping;
      };
    };
    speaker = {
      name = {
        name = "Speaker name";
        description = "The name of the speaker in the dialogue.";
        type = "string";
        defaultValue = Dialogue.defaultSettings.speaker.name;
      }
    };
  };
};

return metadata;