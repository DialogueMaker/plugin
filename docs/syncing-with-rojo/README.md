# Syncing with Rojo
By default, this plugin is made for Studio developers. Rojo's two-way sync is currently unstable, so Dialogue Maker's plugin is somewhat incompatible with Rojo; but, there are a few things you can do to make syncing a bit easier.

## Syncing loaders
### The git submodules method
Dialogue Maker is open-source, so you can easily make your own loader in your favorite code editor by using git submodules.

> [!NOTE]
> This method may defeat the purpose of the ["Reset Packages"](/docs/toolbar/README.md#reset-packages) button, but who cares? You'll have a loader that you can break all you want and easily revert by using Rojo and git. So much better.

#### Clone, fork, or create a template from Dialogue Maker Group's loader
Consider cloning the DialogueMaker/loader repository if you have edit access to the loader, you're doing some quick testing, or you just want to use the default loader as-is. 

Consider forking the DialogueMaker/loader repository if you want to push edits to the existing loader.

Consider creating a new repository from the DialogeMaker/loader template if you want to make your own loader, but want somewhere to start from.

#### Add your loader repository as a submodule to your game
Open up your terminal and move to the folder that you want the loader in. After you do, run the following command, but be sure to change "https://github.com/DialogueMaker/loader" to *your* loader's repository URL.

```bash
git submodule add https://github.com/DialogueMaker/loader DialogueMakerLoader/
```

#### Configure your loader's default.project.json
Add a "DialogueMaker_Loader" tag to your loader's properties in your submodule's defualt.project.json file. Here's an example of how your default.project.json file should look:

```json
{
  "name": "DialogueMakerLoader",
  "tree": {
    "$path": "src",
    "$properties": {
      "Tags": ["DialogueMaker_Loader"]
    },
    "roblox_packages": {
      "$path": "roblox_packages"
    }
  }
}
```

### The "save as file" method
Save your loader script as a file and add the .rbxm or .rbxml file to your Rojo project. Whenever you make a change in Roblox Studio, just save the file again. Easy peasy, but you won't be able to easily edit it using code editor. Consider using the previous method instead if you're looking for that kind of thing.

### The "don't do it" method (aka the "ignoreUnknownInstances" method)
In your project.json, you could always just mark the folder that the loader is in with "ignoreUnknownInstances" set to true. This may not be ideal though.

## Syncing `Conversation` and `Dialogue` scripts
These scripts are a bit more difficult to automatically sync from Roblox Studio.

### The "save as file" method
Save your Conversation ModuleScripts as a file and add them to your Rojo project. Whenever you make a change in Roblox Studio, just save the file again. You'll have to edit the conversations using Roblox Studio's script editor, but it's easier than the next method.

### The do-it-yourself method
You could manually add the ModuleScripts that host the `Conversation` or `Dialogue` into your Rojo project. Just be sure to also add an [init.meta.json file](https://rojo.space/docs/v7/sync-details/#meta-files) that has the "DialogueMaker_Conversation" or "DialogueMaker_Dialogue" tags in the ModuleScript's properties. Also, ensure the priorities are numbered correctly.

This can be *very* painful, so consider using the previous method unless you're aiming for precision in your repository.

### The "don't do it" method
If you don't want to save your conversations and dialogue in your repository, ["ignoreUnknownInstances"](https://rojo.space/docs/v7/project-format/#instance-description) can be your friend here. 

> [!WARNING]
> If you or a "friend" *accidentally* edits or deletes a conversation, the Dialogue Maker plugin won't be able to save you. You'll have to rollback to an older version of  your game by using another tool like [Roblox's version history](https://devforum.roblox.com/t/how-to-go-to-the-past-version-of-my-game-on-roblox-studio/960916/2).

---

Documentation writers: [Christian Toney](https://github.com/Christian-Toney)