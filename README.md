# Roblox Dialogue Maker plugin
## About
The Dialogue Maker is an open-source plugin for creating RPG-like dialogue boxes for NPCs in your Roblox game! It comes with a GUI that allows you to add messages and player responses to your NPCs.

## Features
* Responsive dialogue editor
* Trigger dialogue with proximity regions and ClickDetectors
* Prioritize your dialogue with conditions and message stacking
* Run functions before and after a message
* Impose dialogue timeouts
* Embed variables that are customizable throughout the conversation
* Add responses for the player to add interactivity to the conversation
* Add dialogue redirects
* Customize themes per NPC and per screen size
* Add message pauses

## Where can I get it?
You can either get [the version Beastslash updates at the Roblox Library](https://www.roblox.com/library/4930928141/Dialogue-Maker-Beta) or you can build your own version by using the scripts in this repository.

## How do I use it?
Check out the [documentation](/docs/README.md).

## Development
### Can I contribute?
Sure! If you feel like that the Dialogue Maker can be improved for everyone, just send a feature request in the issues. You could also submit a pull request if you already added it yourself. Beastslash will sync changes made between the plugin and repository.

### Third-party tools
To contribute, you'll need to install some third-party tools that make development more efficient.

* [pesde](https://github.com/pesde-pkg/pesde/releases/tag/v0.7.0-rc.3%2Bregistry.0.2.3-rc.2): This is used for installing packages that the plugin uses, such as [React Lua](https://github.com/jsdotlua/react-lua). It's also used to install packages that the [client](https://github.com/DialogueMaker/client) uses. Be sure to use v0.7.0-rc3 or above because earlier versions of pesde require admin access. You can learn more about pesde here [on their website](https://docs.pesde.dev/).

* [Rojo](https://rojo.space/) *(automatically installed)*: This package is responsible for connecting code editors like Visual Studio Code to Roblox Studio. The command-line version is automatically installed when you run `psede install` in the root of this project, but you should also install the Visual Studio Code [extension](https://marketplace.visualstudio.com/items?itemName=evaera.vscode-rojo) to make things easier for you. You can learn more about Rojo [on their website](https://rojo.space/).

* [darklua](https://darklua.com/) *(automatically installed)*: This is used to resolve path require variables such as `@pkg`. This is automatically installed when you run `psede install` in the root of this project. You can learn more about darklua [on their website](https://darklua.com/).

* [React](https://react.luau.page/) *(automatically installed)*: This is used to programmatically create the graphical windows you see while using the plugin. This is automatically installed when you run `psede install` in the root of this project.

## Acknowledgements
* [**Christian "Sudobeast" Toney**](https://christiantoney.com) - Producer and Lead Programmer
* [**BHickey94**](https://github.com/BHickey94) - Code Contributor
* [**GAVsi115**](https://devforum.roblox.com/u/gavsi115/summary) - Code Contributor and Bug Reporter
* [**extravent3**](https://devforum.roblox.com/u/extravent3/summary) - Issue Sponsor and Bug Reporter
* [**ruax2891**](https://twitter.com/ruax2891) - QA Tester
* [**InkyTheBlue**](https://twitter.com/InkyTheBlueDerg) - QA Tester
* [**BeatArcade**](https://www.roblox.com/users/2893686241/profile) - Bug Reporter
* [**joshuajon**](https://github.com/joshuajon) - Bug Reporter
* [**LordMerc**](https://devforum.roblox.com/u/lordmerc/summary) - Bug Reporter
* [**thomkok13**](https://devforum.roblox.com/u/thomkok13/summary) - Bug Reporter
* [**kitifulnines**](https://devforum.roblox.com/u/kitifulnines/summary**) - [Bug Reporter](https://github.com/Beastslash/roblox-dialogue-maker/issues/88)
* [**DavidColetta**](https://github.com/DavidColetta) - [Bug Reporter](https://github.com/Beastslash/roblox-dialogue-maker/issues/86)
