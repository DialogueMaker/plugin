--!strict

local root = script.Parent.Parent.Parent.Parent;
local Client = require(root.DialogueMakerKit.Packages.Client);
local Conversation = require(root.DialogueMakerKit.Packages.Conversation);
local Dialogue = require(root.DialogueMakerKit.Packages.Dialogue);

export type Validator = (value: any) -> ();
export type SettingMetadata = {name: string; label: string; description: string; type: string; defaultValue: any; validator: Validator?};
export type SettingMetadataGroup = {name: string; settings: {SettingMetadata}};
export type SettingMetadataGroupMap = {[string]: {SettingMetadataGroup}};

local function validateKey(key: string?): ()
  
  if not key then
    
    return;

  end

  local keyCode = Enum.KeyCode:FromName(key);

  assert(keyCode, `Invalid key: {key}`);
  
end

local metadata: SettingMetadataGroupMap = {
  loader = {
    {
      name = "keybinds";
      settings = {
        {
          name = "interactKey";
          label = "Action key";
          description = "The key that the player can press to interact with the dialogue.";
          type = "string";
          defaultValue = Client.defaultSettings.keybinds.interactKey.Name;
          validator = validateKey;
        };
        {
          name = "interactKeyGamepad";
          label = "Gamepad action key";
          description = "The key that the player can press on a gamepad to interact with the dialogue.";
          type = "string";
          defaultValue = Client.defaultSettings.keybinds.interactKeyGamepad.Name;
          validator = validateKey;
        };
      };
    };
    {
      name = "theme";
      settings = {
        {
          name = "componentScript";
          label = "Component script";
          description = "The script that contains the theme component.";
          type = "Instance";
          className = "ModuleScript";
        };
      };
    };
    {
      name = "typewriter";
      settings = {
        {
          name = "canPlayerSkipDelay";
          label = "Allow player to skip delay";
          description = "If enabled, the player can skip the delay between characters being typed out in the conversation.";
          type = "boolean";
          defaultValue = Client.defaultSettings.typewriter.canPlayerSkipDelay;
        };
        {
          name = "characterDelaySeconds";
          label = "Character delay in seconds";
          description = "The delay between each character being typed out in the conversation.";
          type = "number";
          defaultValue = Client.defaultSettings.typewriter.characterDelaySeconds;
        };
        {
          name = "shouldShowResponseWhileTyping";
          label = "Show response while typing";
          description = "If enabled, responses will be shown while the typewriter effect is typing out the text.";
          type = "boolean";
          defaultValue = Client.defaultSettings.typewriter.shouldShowResponseWhileTyping;
        };
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