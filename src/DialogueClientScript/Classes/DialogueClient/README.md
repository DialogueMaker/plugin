# DialogueClient
## Static properties
### defaultSettings
#### responses
#### keybinds

### sharedDialogueClient
> [!TIP]
> Consider using [setSharedDialogueClient()](#setshareddialogueclientdialogueclient) instead of directly setting this value. If you directly set this value, the [SharedDialogueClientChanged static event](#shareddialogueclientchanged) will not fire.

## Static methods
### getSharedDialogueClient()
Gets the [shared dialogue client](#shareddialogueclient). Errors if there is no shared dialogue client set.

### setSharedDialogueClient(dialogueClient)

### waitForSharedDialogueClient()
Waits for the shared dialogue client to be set, then returns it. 

## Static events
### SharedDialogueClientChanged
> [!WARNING]
> If you directly set the [sharedDialogueClient static property](#shareddialogueclient), this event will not fire.

## Constructors
### new(dialogueClientSettings, moduleScript)

## Methods
### interact()

### getSettings()

### setSettings(newSettings)

## Events
### SettingsChanged
> [!WARNING]
> If you directly set [settings](#settings) instead of using [setSettings()](#setsettingsnewsettings), then this event will not fire.

### DialogueServerChanged


## Relevant types
### DialogueClientSettings

### GeneralDialogueClientSettings

### KeybindDialogueClientSettings

### OptionalDialogueClientSettings

### ResponseDialogueClientSettings

---

Documentation contributors: Christian Toney
