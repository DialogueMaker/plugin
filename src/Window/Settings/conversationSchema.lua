--!strict

local schema = {
  theme = {
    componentScript = {
      name = "Component script";
      description = "The script that contains the theme component.";
      className = "ModuleScript";
      shouldRequire = true;
    };
  };
  speaker = {
    name = {
      name = "Speaker name";
      description = "The name of the speaker in the conversation.";
      type = "string";
    }
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
    soundTemplate = {
      name = "Sound template";
      description = "The sound template to use for the typewriter effect.";
      className = "Sound";
    };
  };
};

return schema;