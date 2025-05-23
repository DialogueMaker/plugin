# Dialogue
A `Dialogue` object contains all of the information needed for a message, a response, or a redirect.

Some Dialogue properties can be edited using the [dialogue editor window](/src/DialoguePluginScript/Window/README.md) of the plugin.

## Static properties
### defaultSettings
#### theme

#### typewriter

#### timeout

## Constructors
### new(properties, moduleScript)

## Properties
### type
The specific type of dialogue that this is. This value is automatically determined by the "DialogueType" attribute set on the provided ModuleScript.

> **Type**
> <br />"Message" | "Response" | "Redirect"

### settings

## Methods
### getChildren()
> **Returns**
> <br />[`Dialogue`](#dialogue)

### getContent()
> [!CAUTION]
> Using effects in responses can break your dialogue in StandardTheme, so avoid using them in responses unless you're using another theme. This functionality will be supported in a future version.

> [!WARNING]
> Currently, only the first item is used in responses. The rest of the items are ignored when using StandardTheme.

> [!WARNING]
> [`DialogueClient`](/src/DialogueClientScript/Classes/DialogueClient/README.md) objects do not call this method on redirects.

> [!WARNING]
> [`DialogueClient`](/src/DialogueClientScript/Classes/DialogueClient/README.md) objects yield for this function, so players could think that the dialogue "froze" on lengthy tasks. Avoid using this method for actions; instead, use the dedicated [runAction()](#runactiondialoguestate) method.

Returns a user-defined ordered list of strings or effects. This represents a list represents a message or a response.

To fit the content into your theme, consider using a [`DialogueContentFitter`](/src/DialogueClientScript/Classes/DialogueContentFitter/README.md).

> **Returns**
> <br />An mixed array of string and [`Effect`](/src/DialogueClientScript/Classes/Effect/README.md) objects.

### getSettings()
Returns a *clone* of the settings that this dialogue uses. 

The true settings object is kept private to avoid unexpected behavior, and to ensure the [SettingsChanged](#settingschanged) event works.

> **Returns**
> <br />[`DialogueSettings`](#dialoguesettings)

### runAction(dialogueState)
> [!WARNING]
> [`DialogueClient`](/src/DialogueClientScript/Classes/DialogueClient/README.md) objects yield for this function, so players could think that the dialogue "froze" on lengthy tasks. Consider using a [task](https://create.roblox.com/docs/reference/engine/libraries/task#spawn) or a [coroutine](https://create.roblox.com/docs/reference/engine/libraries/coroutine#wrap) for non-blocking actions.

Executes a user-defined function.

> **Parameters**
> | Name | Type | Description |
> | :- | :- | :- |
> | dialogueState | "Initializing" \| "Completed" | A dialogue state that can potentially change the functionality of this function. Can be helpful for determining before a message is shown and after it is fully shown. |

> **Returns**
> <br />void

### setSettings(settings)
Overwrites the current settings object with a new settings object.

> **Returns**
> <br />[`DialogueSettings`](#dialoguesettings)

### verifyCondition()

## Events
### SettingsChanged

## Relevant types
### TimeoutDialogueSettings
| Key | Type | Description |
| :- | :- | :- |
| seconds | number? |  |
| shouldWaitForResponse | boolean |  |

### TypewriterDialogueSettings
| Key | Type | Description |
| :- | :- | :- |
| characterDelaySeconds | number |  |
| canPlayerSkipDelay | boolean |  |

---

Documentation contributors: Christian Toney
