# DialogueServer
A `DialogueServer` object is used to contain information about your specific characters. Along with this, DialogueServer objects contain any [`Dialogue`](/src/DialogueClientScript/Classes/Dialogue/README.md) objects that are relevant to the character.

When you press "Edit Dialogue" while selecting a model or a base part, a module script named "DialogueServer" is automatically placed into it. The module script has the "DialogueMaker_DialogueServer" tag for easy identification for [triggers](/src/DialogueClientScript/Triggers/README.md) and other types of scripts.

The `DialogueServer` class is called DialogueServer because the object is typically located on an NPC that *serves* dialogue to the player, or the [`DialogueClient`](/src/DialogueClientScript/Classes/DialogueClient/README.md). It's important to note that `DialogueServer` objects are typically used by [client scripts](https://create.roblox.com/docs/reference/engine/classes/LocalScript) instead of [server scripts](https://create.roblox.com/docs/reference/engine/classes/Script).

## Static properties
### defaultSettings
An object of [default server settings](#dialogueserversettings) that all `DialogueServer` objects default to. Any setting that isn't explicitly configured in the [constructor](#newdialogueserversettings-module) is defined by the default settings.

The current default settings aim to best suit the average non-programmer. If you have any recommendations to these settings that may improve users workflow, feel free to [file an issue](https://github.com/).

#### clickDetector
| Key | Default type | Default value | Rationale |
| :- | :- | :- | :- |
| adornee | nil | nil | This property is for developers to manage a ClickDetector that they created, so there is no need for a default value. |
| instance | nil | nil | This property is for developers to manage a ClickDetector that they created, so there is no need for a default value. |
| shouldAutoCreate | boolean | false | Proximity prompts are more visible and accessible for players. |
| shouldDisappearDuringConversation | boolean | true | Hiding the click detector trigger during a conversation improves accessibility by hiding the hand pointer. |

#### general
| Key | Default type | Default value | Rationale |
| :- | :- | :- | :- |
| maxConversationDistance | nil | nil | Setting this value by default may not be helpful for *all* games, as some games may want to have long-distance conversations. |
| name | nil | nil | It is not feasible to automatically determine what the developer may want to call their character. Using a model name or a part name may not be helpful, as it can include internal information in some names. | 
| shouldFreezePlayer | boolean | true | Freezing the player improves accessibility because they can only focus on one thing: the conversation. |
| theme | nil | nil | This property is for developers to override the `DialogueClient` theme, so there is no need for a default value. |

#### promptRegion
| Key | Default type | Default value | Rationale |
| :- | :- | :- | :- |
| basePart | nil | nil | Prompt regions may wildly vary across games, so it is best to keep this empty by default. |

#### proximityPrompt
| Key | Default type | Default value | Rationale |
| :- | :- | :- | :- |
| adornee | nil | nil | If shouldAutoCreate is enabled, then this is automatically decided based on the parent of the ModuleScript that was set by the [constructor](#newdialogueserversettings-module). |
| instance | nil | nil | This property is for developers to manage a ProximityPrompt that they created, so there is no need for a default value. |
| shouldAutoCreate | boolean | true | Creating proximity prompts by default to trigger conversations helps Dialogue Maker out-of-the-box. A proximity prompt is generally the most accessible trigger across all devices when compared to other triggers. |

#### speechBubble
| Key | Default type | Default value | Rationale |
| :- | :- | :- | :- |
| adornee | nil | nil | If shouldAutoCreate is enabled, then this is automatically decided based on the parent of the ModuleScript that was set by the [constructor](#newdialogueserversettings-module). |
| billboardGUI | nil | nil | This property is for developers to manage a BillboardGui that they created, so there is no need for a default value. |
| button | nil | nil | This property is for developers to manage a GuiButton that they created, so there is no need for a default value. |
| shouldAutoCreate | boolean | false | Proximity prompts are more visible and accessible for players across devices. |

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

## Methods


## Relevant types
### ClickDetectorDialogueServerSettings
| Key | Type | Description |
| :- | :- | :- |
| shouldAutoCreate | boolean |  |
| shouldDisappearDuringConversation | boolean |  |
| instance | [ClickDetector](https://create.roblox.com/docs/en-us/reference/engine/classes/ClickDetector)? |  |
| adornee | [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)? |  |

### DialogueServerSettings
| Key | Type | Description |
| :- | :- | :- |
| clickDetector | [ClickDetectorDialogueServerSettings](#clickdetectordialogueserversettings) | Settings intended for the [pre-installed trigger for click detectors](/src/DialogueClientScript/Triggers/ClickDetectorTrigger.client.lua). |
| general | [GeneralDialogueServerSettings](#generaldialogueserversettings) | General settings for the character. |
| promptRegion | [PromptRegionDialogueServerSettings](#promptregiondialogueserversettings) | |
| proximityPrompt | [ProximityPromptDialogueServerSettings](#proximitypromptdialogueserversettings) | |
| speechBubble | [SpeechBubbleDialogueServerSettings](#speechbubbledialogueserversettings) | Settings intended for the [pre-installed trigger for speech bubbles](/src/DialogueClientScript/Triggers/ClickDetectorTrigger.client.lua). |
<!-- | timeout | [TimeoutDialogueServerSettings](#timeoutdialogueserversettings) | Settings for conversation timeouts. |
| typewriter | [TypewriterDialogueServerSettings](#typewriterdialogueserversettings) | Settings intended for StandardTheme's [typewriter hook](/src/DialogueClientScript/ReactHooks/useTypewriter.lua). | -->

### GeneralDialogueServerSettings
| Key | Type | Description |
| :- | :- | :- |
| name | string? |  |
| theme | ModuleScript? |  |
| shouldFreezePlayer | boolean |  |
| maxConversationDistance | number? |  |

### OptionalDialogueServerSettings
OptionalDialogueServerSettings is used to let developers configure *some* [settings](#dialogueserversettings) that they need, but offer the convenience of not configuring *all* settings. 

As of May 19, 2025, Roblox's current typechecker lacks a way to implement [recursive partial types](https://stackoverflow.com/a/47914631), so we created a new type where every property in DialogueServerSettings is optional. Refer to DialogueServerSettings for property documentation.

### PromptRegionDialogueServerSettings
| Key | Type | Description |
| :- | :- | :- |
| basePart | [BasePart](https://create.roblox.com/docs/en-us/reference/engine/classes/BasePart)? |  |

### ProximityPromptDialogueServerSettings
| Key | Type | Description |
| :- | :- | :- |
| shouldAutoCreate | boolean |  |
| instance | [ProximityPrompt](https://create.roblox.com/docs/en-us/reference/engine/classes/ProximityPrompt)? |  |

### SpeechBubbleDialogueServerSettings
| Key | Type | Description |
| :- | :- | :- |
| shouldAutoCreate | boolean |  |
| billboardGUI | [BillboardGui](https://create.roblox.com/docs/en-us/reference/engine/classes/BillboardGui)? |  |
| button | [GuiButton](https://create.roblox.com/docs/en-us/reference/engine/classes/GuiButton)? |  |
| adornee | [Instance](https://create.roblox.com/docs/en-us/reference/engine/classes/Instance)? |  |

---

Documentation contributors: Christian Toney
