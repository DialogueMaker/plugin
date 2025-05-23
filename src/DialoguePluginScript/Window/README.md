# Dialogue editor window
You can use the **dialogue editor window** to easily change dialogue priorities, initialize and label [`DialogueServer`](/src/DialogueClientScript/Classes/DialogueServer/README.md) objects, and change dialogue types.

The dialogue editor window automatically closes if the Explorer selection changes to an instance that isn't a ModuleScript and a descendant of a [`DialogueServer`](/src/DialogueClientScript/Classes/DialogueServer/README.md) ModuleScript. The window remains open if a `DialogueServer` ModuleScript or its parent are selected, as long as the parent is a BasePart or a Model. Although Workspace is a Model, the window will close if that is selected.

![An example of the Dialogue Editor interface. The buttons shown are "View parent", "Add message", and "Adjust settings".](dialogue-editor-example.png)

## Why can't I edit text in the Dialogue Editor?
Unfortunately, it is currently not feasible to modify most dialogue properties and methods within the dialogue editor window. This is because dialogue can be dynamic, meaning that the values of them can change during runtime. Running these scripts in Studio's edit mode can pose a security risk, as someone malicious could edit them before the plugin runs them. As such, you can only edit dialogue within Roblox's script editor or your favorite external editor. 

If Roblox adds some sort of in-Studio sandbox environment for plugins, we can look at adding additional GUI support for dialogue editing; but for now, any pull request that changes this functionality may be closed. 

## Components
* [DialogueTable](./DialogueTable/README.md)
* [Toolbar]()