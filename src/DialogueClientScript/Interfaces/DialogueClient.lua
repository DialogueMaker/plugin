--!strict

local IDialogueServer = require(script.Parent.DialogueServer);
type DialogueServer = IDialogueServer.DialogueServer;

export type DialogueClientSettings = {

  theme: {

    -- This is the default theme that will be used when talking with NPCs
    defaultTheme: ModuleScript;

  };

  responses: {

    -- Replace this with an audio ID that'll play every time a player selects a response. Replace with 0 to not play any sound.
    defaultClickSound: number;

  };
  keybinds: {

    --[[
      Minimum distance from a character required for keybinds should work.
    ]]
    minimumDistanceFromCharacter: number;

    --[[
      Keyboard keybind to start a conversation with a character.
    ]]
    interactKey: Enum.KeyCode?;

    --[[
      Gamepad keybind to start a conversation with a character.
    ]]
    interactKeyGamepad: Enum.KeyCode?;

  };
};

export type DialogueClientProperties = {
  isTalkingWithNPC: boolean;
  theme: ModuleScript?;
  dialogueServers: {DialogueServer};
  settings: DialogueClientSettings;
}

export type DialogueClientMethods = {
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