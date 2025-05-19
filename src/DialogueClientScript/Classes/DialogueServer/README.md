# DialogueServer
A `DialogueServer` object is used to contain information about your specific characters. Along with this, DialogueServer objects contain any [`Dialogue`](/src/DialogueClientScript/Classes/Dialogue/README.md) objects that are relevant to the character.

When you press "Edit Dialogue" while selecting a model or a base part, a module script named "DialogueServer" is automatically placed into it. The module script has the "DialogueMaker_DialogueServer" tag for easy identification for [triggers](/src/DialogueClientScript/Triggers/README.md) and other types of scripts.

## Static properties
### defaultSettings
An object of [DefaultServerSettings](#dialogueserversettings) that all `DialogueServer` objects default to. Any setting that isn't configured in the [constructor](#newdialogueserversettings) is defined by the default settings.

Here are the current default settings:
```luau
defaultSettings = {
  general = {
    name = nil;
    theme = nil;
    shouldFreezePlayer = true; 
    shouldEndConversationIfOutOfDistance = false;
    maxConversationDistance = 10;
  };
  typewriter = {
    characterDelaySeconds = 0.025; 
    canPlayerSkipDelay = true; 
  };
  humanoid = {
    shouldLookAtPlayer = true; 
    neckRotationMaxX = 0.8726;
    neckRotationMaxY = 1.0472; 
    neckRotationMaxZ = 0.8726; 
  };
  promptRegion = {
    basePart = nil; 
  };
  timeout = {	
    seconds = nil; 
    shouldWaitForResponse = true; 
  };
  clickDetector = { 
    shouldAutoCreate = true; 
    shouldDisappearDuringConversation = true; 
    instance = nil;
  };
  proximityPrompt = { 
    shouldAutoCreate = true; 
    instance = nil; 
  };
  speechBubble = {
    shouldAutoCreate = false; 
    button = nil;
    billboardGUI = nil;
    adornee = nil;
  };
}
```

## Constructors
### new(dialogueServerSettings)
Creates and returns a new `DialogueServer` object.

#### Parameters
| Name | Type | Description |
| :- | :- | :- |
| dialogueServerSettings | [OptionalDialogueServerSettings](#optionaldialogueserversettings) | Setting overrides for the DialogueServer. Anything that isn't set will be defined by the default settings. |

## Relevant types

### DialogueServerSettings

### OptionalDialogueServerSettings
OptionalDialogueServerSettings is used to let developers configure *some* settings that they need, but offer the convenience of not configuring *all* settings. 

As of May 19, 2025, Roblox's current typechecker lacks a way to implement [recursive partial types](https://stackoverflow.com/a/47914631), so we created a new type where every property in [DialogueServerSettings](#dialogueserversettings) is optional. Refer to DialogueServerSettings for property documentation.

---

Documentation contributors: Christian Toney