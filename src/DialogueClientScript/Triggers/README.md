# Triggers
As of Dialogue Maker v5.0.0, you can create custom triggers for conversations. 

## Configuring triggers at the DialogueClient level

You can put your custom triggers in this folder, or you can put them somewhere else in your game. Just make sure to get the shared DialogueClient, call `:interact()`, and you're good to go.

> [!WARNING]
> It is not recommended to get a DialogueClient via bindable functions and events. [You will only receive a *copy* of the DialogueClient object instead of the *real* object.](https://create.roblox.com/docs/scripting/events/bindable#table-identities) In this case, your trigger probably won't work properly.

## Configuring triggers at the DialogueServer level
Maybe you want to have specific NPCs with triggers instead of all of them. Good news: Dialogue Maker gives you that control.

You can create new settings in that NPC's `DialogueServer` ModuleScript, and handle them from your trigger script. For example, we added multiple DialogueServer-level settings for pre-installed triggers. To see how we handle them, check out the [pre-installed triggers](#pre-installed-triggers).

## Pre-installed triggers
For organization, pre-installed triggers are located in the "Triggers" folder of the DialogueClientScript. 

* [Trigger conversations with a ClickDetector](./ClickDetectorTrigger.client.lua)
* [Trigger conversations with a prompt region part](./PromptRegionTrigger.client.lua)
* [Trigger conversations with a floating speech bubble](./SpeechBubbleTrigger.client.lua)
* [Trigger conversations with a ProximityPrompt](./ProximityPromptTrigger.client.lua)
