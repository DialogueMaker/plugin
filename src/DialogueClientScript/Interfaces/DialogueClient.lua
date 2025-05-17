--!strict

local IDialogueServer = require(script.Parent.Interfaces.DialogueServer);
type DialogueServer = IDialogueServer.DialogueServer;

export type DialogueClientProperties = {
  isTalkingWithNPC: boolean;
  theme: ModuleScript?;
  dialogueServers: {DialogueServer};
}

export type DialogueClientMethods = {
  interact: (self: DialogueClient, dialogueServer: DialogueServer) -> ();
  setTheme: (self: DialogueClient, theme: ModuleScript) -> ();
  toggleAllTriggers: (self: DialogueClient, shouldEnable: boolean) -> ();
}

export type DialogueClientEvents = {
  ThemeChanged: RBXScriptSignal<ModuleScript>;
}

export type DialogueClient = DialogueClientProperties & DialogueClientMethods & DialogueClientEvents;

return {};