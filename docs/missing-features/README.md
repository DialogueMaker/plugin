# Missing features
## Editing dialogue scripts made outside of the Dialogue Maker plugin
For your safety and security, editing dialogue created outside of the Dialogue Maker plugin is currently unsupported. 

The Client, Conversation, and Dialogue classes all depend on scripts to initialize them. Without creating a robust parser that could determine all of the possible ways `Conversation.new()` and `Dialogue.new()` could be called, it is impractical for Dialogue Maker to directly read or edit your dialogue from these scripts.