# Dialogue editor window
You can use the **dialogue editor window** to easily change dialogue priorities, initialize and label [`DialogueServer`](/src/DialogueClientScript/Classes/DialogueServer/README.md) objects, and change dialogue types.

The dialogue editor window automatically closes if the Explorer selection changes to an instance that isn't a ModuleScript and a descendant of a [`DialogueServer`](/src/DialogueClientScript/Classes/DialogueServer/README.md) ModuleScript. The window remains open if a `DialogueServer` ModuleScript or its parent are selected, as long as the parent is a BasePart or a Model. Although Workspace is a Model, the window will close if that is selected.

![An example of the Dialogue Editor interface. The buttons shown are "View parent", "Add message", and "Adjust settings".](dialogue-editor-example.png)

## Why can't I edit text or settings in the Dialogue Editor?
See [issue #98](https://github.com/DialogueMaker/plugin/issues/98).

## Toolbar
### View parent

### Add message

### Adjust settings

---

Documentation writers: Christian Toney