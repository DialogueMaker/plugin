# Toolbar
As the plugin loads, it will create a Toolbar so you can access the tools of the Dialogue Maker.

## Buttons
### Create Conversation
This button creates a ModuleScript that contains a [`Conversation`]() object, selects that ModuleScript, then runs the [Edit Conversation](#edit-server) script.

This button is enabled if you are selecting an instance *and* not selecting a ModuleScript with a "DialogueMakerConversation" tag or a "DialogueMaker_Dialogue" tag.

### Edit Conversation
If the [Dialogue Editor](/docs/dialogue-editor-window/README.md) is closed, this button opens it. For convenience, this checks for a ModuleScript with a "DialogueMaker_Loader" tag in your game. If there isn't one, this button runs the [Initialize Client](#initialize-client) script. 

If the Dialogue Editor is open, this button closes the window.

This button is enabled if you are currently a ModuleScript with a "DialogueMakerConversation" tag or a "DialogueMaker_Dialogue" tag.

### Initialize Client
This creates a ModuleScript that contains a [`DialogueClient`]() object. To reduce friction, the location depends on if you already have a ModuleScript with a "DialogueMaker_Loader" tag. If you do, this button simply replaces that script with a new one. If you don't, this button creates one in your StarterPlayerScripts.

### Adjust Settings
This opens the ModuleScript that contains your [`DialogueClient`]() object. 

In this script, you can edit `DialogueClient` settings, such as the default theme. 

This button is enabled if there a ModuleScript with a `DialogueMaker_Loader" tag in your game. Press [Initialize Client](#initialize-client) if this button is disabled.

### Reset Packages
This deletes the roblox_packages folder of the [DialogueClientScript](https://github.com/DialogueMaker/client), then replaces it with a new roblox_packages folder from the plugin's copy of a DialogueClientScript. This can be helpful if the packages become corrupted somehow, or if the Dialogue Maker Client gets a minor update.

This button is enabled if there a ModuleScript with a `DialogueMaker_Loader" tag in your game. Press [Initialize Client](#initialize-client) if this button is disabled.