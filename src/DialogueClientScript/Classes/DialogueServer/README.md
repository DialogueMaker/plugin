# DialogueServer
A `DialogueServer` object is used to contain information about your specific characters. Along with this, DialogueServer objects contain any [`Dialogue`](/src/DialogueClientScript/Classes/Dialogue/README.md) objects that are relevant to the character.

When you press "Edit Dialogue" while selecting a model or a base part, a module script named "DialogueServer" is automatically placed into it. The module script has the "DialogueMaker_DialogueServer" tag for easy identification for [triggers](/src/DialogueClientScript/Triggers/README.md) and other types of scripts.

The `DialogueServer` class is called DialogueServer because the object is typically located on an NPC that *serves* dialogue to the player, or the [`DialogueClient`](/src/DialogueClientScript/Classes/DialogueClient/README.md). It's important to note that `DialogueServer` objects are typically used by [client scripts](https://create.roblox.com/docs/reference/engine/classes/LocalScript) instead of [server scripts](https://create.roblox.com/docs/reference/engine/classes/Script).

## Static properties
### defaultSettings
An object of [default server settings](#dialogueserversettings) that all `DialogueServer` objects default to. Any setting that isn't explicitly configured in the [constructor](#newdialogueserversettings-module) is defined by the default settings.

The current default settings are opinionated and aim to best suit the average non-programmer. If you have any recommendations to these settings that may improve users workflow, feel free to [file an issue](https://github.com/).

```luau
local defaultSettings = {
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
    shouldLookAtPlayer = false; 
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
    shouldAutoCreate = false; 
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
### new(dialogueServerSettings, module)
Creates and returns a new `DialogueServer` object.

#### Parameters
| Name | Type | Description |
| :- | :- | :- |
| dialogueServerSettings | [OptionalDialogueServerSettings](#optionaldialogueserversettings) | Setting overrides for the DialogueServer. Anything that isn't set will be defined by the default settings. |

## Properties
### settings
The `DialogueServer`'s [settings](#dialogueserversettings). They start out with the [default settings](#defaultsettings), but they can be overwritten by [the constructor](#newdialogueserversettings-module) or direct assignment.

## Relevant types
### ClickDetectorDialogueServerSettings
TBA

### DialogueServerSettings
| Name | Type | Description |
| :- | :- | :- |
| clickDetector | [ClickDetectorDialogueServerSettings](#clickdetectordialogueserversettings) | Settings intended for the [pre-installed trigger for click detectors](/src/DialogueClientScript/Triggers/ClickDetectorTrigger.client.lua). |
| general | [GeneralDialogueServerSettings](#generaldialogueserversettings) | General settings for the character. |
| humanoid | [HumanoidDialogueServerSettings](#humanoiddialogueserversettings) | Humanoid settings for the character. [StandardTheme](/src/DialogueClientScript/Themes/StandardTheme) uses these. |
| promptRegion | [PromptRegionDialogueServerSettings](#promptregiondialogueserversettings) | |
| proximityPrompt | [ProximityPromptDialogueServerSettings](#proximitypromptdialogueserversettings) | |
| speechBubble | [SpeechBubbleDialogueServerSettings](#speechbubbledialogueserversettings) | Settings intended for the [pre-installed trigger for speech bubbles](/src/DialogueClientScript/Triggers/ClickDetectorTrigger.client.lua). |
| timeout | [TimeoutDialogueServerSettings](#timeoutdialogueserversettings) | Settings for conversation timeouts. |
| typewriter | [TypewriterDialogueServerSettings](#typewriterdialogueserversettings) | Settings intended for StandardTheme's [typewriter hook](/src/DialogueClientScript/ReactHooks/useTypewriter.lua). |

### GeneralDialogueServerSettings
TBA

### HumanoidDialogueServerSettings
TBA

### OptionalDialogueServerSettings
OptionalDialogueServerSettings is used to let developers configure *some* [settings](#dialogueserversettings) that they need, but offer the convenience of not configuring *all* settings. 

As of May 19, 2025, Roblox's current typechecker lacks a way to implement [recursive partial types](https://stackoverflow.com/a/47914631), so we created a new type where every property in DialogueServerSettings is optional. Refer to DialogueServerSettings for property documentation.

### PromptRegionDialogueServerSettings
TBA

### ProximityPromptDialogueServerSettings
TBA

### SpeechBubbleDialogueServerSettings
TBA

### TimeoutDialogueServerSettings
TBA

### TypewriterDialogueServerSettings
TBA

---

Documentation contributors: Christian Toney
