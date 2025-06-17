--!strict

local root = script.Parent.Parent.Parent.Parent;
local Conversation = require(root.DialogueMakerKit.Packages.Conversation);
local Dialogue = require(root.DialogueMakerKit.Packages.Dialogue);

local metadata = {
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
        -- defaultValue = Conversation.defaultSettings.typewriter.shouldShowResponseWhileTyping;
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
  loader = {
    theme = {
      componentScript = {
        name = "Component script";
        description = "The script that contains the theme component.";
        type = "Instance";
        className = "ModuleScript";
        isRequired = true;
      };
    };
  };
};

return metadata;