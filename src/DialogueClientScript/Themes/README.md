# Themes
Want to mix up how messages and responses are shown to players? It's time for a new theme. 

## Using themes
### Setting themes at the DialogueClient level
The theme at the DialogueClient level is the default theme for conversations. You can set the theme at the DialogueClient level when you create the DialogueClient object or by using the `setTheme()` method.

```luau
local StandardTheme = require(DialogueClientScript.Themes.StandardTheme);

-- Set theme when creating DialogueClient
local dialogueClient = DialogueClient.new({
  theme = StandardTheme;
});

-- Set theme after creating DialogueClient
dialogueClient:setTheme(StandardTheme);
```

### Setting themes at the DialogueServer level


### Setting themes at the Dialogue level
Setting themes per dialogue is unsupported for now, but this feature will be added in the future.

## Creating a theme

## Pre-installed themes
[StandardTheme](./StandardTheme) is the only pre-installed theme in the plugin. StandardTheme is available out-of-the-box, which can be especially helpful for developers who are unfamiliar with [React Lua](https://jsdotlua.github.io/react-lua/).

The "Themes" folder is intended for pre-installed themes, private themes, and themes that you get from the Roblox Store. If you are a developer who wants to contribute a theme to Dialogue Maker, consider publishing it to Wally or the Roblox Store instead of filing a pull request to this folder. This is because we want to keep Dialogue Maker as lightweight as possible, while maintaining convienence and customization.