# Missing features
## Editing dialogue scripts using the Dialogue Maker plugin
For your safety and security, editing dialogue created outside of the Dialogue Maker plugin is currently unsupported. 

The Client, Conversation, and Dialogue classes all depend on scripts to initialize them. Without creating a robust parser that could determine all of the possible ways `Conversation.new()` and `Dialogue.new()` could be called, it is impractical for Dialogue Maker to directly read or edit your dialogue from these scripts.  

## Showing dynamic dialogue content in the Dialogue Maker plugin
To uphold safety, security, and feasibility, showing dynamic dialogue content in the Dialogue Maker plugin is currently unsupported. 

"Dynamic dialogue content" includes any dialogue content that isn't one, static string. This includes stuff like effects, variables (i.e. including the current player name in the message), and conditions.

Behind the scenes, the Dialogue Maker plugin uses [attributes]() to store your conversation's dialogue. It also uses [`ObjectValue`]() objects for your redirects. The Dialogue Maker plugin uses template scripts to read those values into new `Conversation` and `Dialogue` objects. The Dialogue Maker plugin also uses those values to safely show messages and responses to you, without requiring [`ModuleScript`]() objects.

The Dialogue Maker plugin is unable to automatically determine whether dialogue content is static or dynamic; but, you can manually mark dynamic dialogue content using the plugin. 