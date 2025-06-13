--!strict

local metadata = {
  conversation = {
    speaker = {
      name = {
        name = "Speaker name";
        description = "The name of the speaker in the conversation.";
        type = "string";
      }
    };
    theme = {
      componentScript = {
        name = "Component script";
        description = "The script that contains the theme component.";
        className = "ModuleScript";
      };
    };
    typewriter = {
      canPlayerSkipDelay = {
        name = "Allow player to skip delay";
        description = "If enabled, the player can skip the delay between characters being typed out in the conversation.";
        type = "boolean";
      };
      characterDelaySeconds = {
        name = "Character delay in seconds";
        description = "The delay between each character being typed out in the conversation.";
        type = "number";
      };
      shouldShowResponseWhileTyping = {
        name = "Show response while typing";
        description = "If enabled, responses will be shown while the typewriter effect is typing out the text.";
        type = "boolean";
      };
    };
  };
  dialogue = {
    theme = {
      componentScript = {
        name = "Component script";
        description = "The script that contains the theme component.";
        className = "ModuleScript";
      };
    };
    typewriter = {
      canPlayerSkipDelay = {
        name = "Allow player to skip delay";
        description = "If enabled, the player can skip the delay between characters being typed out in the conversation.";
        type = "boolean";
      };
      characterDelaySeconds = {
        name = "Character delay in seconds";
        description = "The delay between each character being typed out in the conversation.";
        type = "number";
      };
      shouldShowResponseWhileTyping = {
        name = "Show response while typing";
        description = "If enabled, responses will be shown while the typewriter effect is typing out the text.";
        type = "boolean";
      };
    }
  };
  game = {
    loader = {
      useDefault = {
        name = "Use default loader";
        description = "If enabled, the Dialogue Maker Kit will use the default loader to load conversations.";
        defaultValue = true;
        type = "boolean";
      };
    };
    packages = {
      location = {
        name = "Package location";
        description = "The folder where Dialogue Maker Kit packages are located.";
        defaultValue = nil;
        className = "Folder";
      }
    };
  };
  loader = {
    theme = {
      componentScript = {
        name = "Component script";
        description = "The script that contains the theme component.";
        className = "ModuleScript";
        isRequired = true;
      };
    };
  };
};

return metadata;