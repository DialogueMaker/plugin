--!strict

local IDialogueServer = require(script.Parent.DialogueServer);
type DialogueServer = IDialogueServer.DialogueServer;

export type DialogueClientSettings = {

  theme: {

    -- This is the default theme that will be used when talking with NPCs
    defaultTheme: ModuleScript;

  };

  responses: {

    -- Whether to show the responses after the message has finished playing
    showResponsesAfterMessageFinished: boolean;

    -- Replace this with an audio ID that'll play every time a player selects a response. Replace with 0 to not play any sound.
    defaultClickSound: number;

  };

  triggers: {

    -- Minimum distance from a character required for keybinds should work
    minimumDistanceFromCharacter: number;

    -- Whether keybinds should work
    keybindsEnabled: boolean;

    -- Keyboard keybind to start a conversation with an NPC
    defaultChatTriggerKey: Enum.KeyCode;

    -- Gamepad keybind to start a conversation with an NPC
    defaultChatTriggerKeyGamepad: Enum.KeyCode;

    -- Keyboard keybind to continue a conversation with an NPC
    defaultChatContinueKey: Enum.KeyCode;

    -- Gamepad keybind to continue a conversation with an NPC
    defaultChatContinueKeyGamepad: Enum.KeyCode;

  };

};

export type DialogueClientProperties = {
  isTalkingWithNPC: boolean;
  theme: ModuleScript?;
  dialogueServers: {DialogueServer};
  settings: DialogueClientSettings;
}

export type DialogueClientMethods = {
  addDialogueServer: (self: DialogueClient, dialogueServer: DialogueServer) -> ();
  freezePlayer: (self: DialogueClient) -> ();
  unfreezePlayer: (self: DialogueClient) -> ();
  interact: (self: DialogueClient, dialogueServer: DialogueServer) -> ();
  setTheme: (self: DialogueClient, theme: ModuleScript) -> ();
  toggleAllTriggers: (self: DialogueClient, shouldEnable: boolean) -> ();
}

export type DialogueClientEvents = {
  ThemeChanged: RBXScriptSignal<ModuleScript>;
}

export type DialogueClient = DialogueClientProperties & DialogueClientMethods & DialogueClientEvents;

return {};