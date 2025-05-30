# Dialogue editor window
You can use the **dialogue editor window** to easily change dialogue priorities, initialize and label [`DialogueServer`](/src/DialogueClientScript/Classes/DialogueServer/README.md) objects, and change dialogue types.

The dialogue editor window automatically closes if the Explorer selection changes to an instance that isn't a ModuleScript and a descendant of a [`DialogueServer`](/src/DialogueClientScript/Classes/DialogueServer/README.md) ModuleScript. The window remains open if a `DialogueServer` ModuleScript or its parent are selected, as long as the parent is a BasePart or a Model. Although Workspace is a Model, the window will close if that is selected.

![An example of the Dialogue Editor interface. The buttons shown are "View parent", "Add message", and "Adjust settings".](dialogue-editor-example.png)

## Why can't I edit text or settings in the Dialogue Editor?
Short reason: To protect you from malicious code. 

Long reason: See [issue #98](https://github.com/DialogueMaker/plugin/issues/98).

## Toolbar
### View parent
Selects the parent ModuleScript, if applicable. This button is disabled if there is no parent `Dialogue` or `DialogueServer` object.

### Add message
Adds a ModuleScript that contains a `Dialogue` object. This button does not automatically open the script. To do this, you need to press the "Options" dropdown on the new message, then press the "Configure" button.  

### Adjust settings
Opens the selected ModuleScript in Roblox's script editor so you can adjust the `DialogueServer` settings from there.

---

Documentation writers: Christian Toney