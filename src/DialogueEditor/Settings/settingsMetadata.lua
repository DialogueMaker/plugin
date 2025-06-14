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