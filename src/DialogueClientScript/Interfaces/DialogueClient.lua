--!strict

local IDialogueServer = require(script.Parent.DialogueServer);

type DialogueServer = IDialogueServer.DialogueServer;

export type DialogueClientSettings = {

  general: {

    -- This is the default theme that will be used when talking with NPCs
    theme: ModuleScript;

    shouldEndConversationOnCharacterRemoval: boolean;

  };
  responses: {

    -- Replace this with an audio ID that'll play every time a player selects a response. Replace with 0 to not play any sound.
    clickSound: number?;

  };
  keybinds: {

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

export type OptionalDialogueClientSettings = {

  general: {

    -- This is the default theme that will be used when talking with NPCs
    theme: ModuleScript?;

    shouldEndConversationOnCharacterRemoval: boolean?;

  }?;
  responses: {

    -- Replace this with an audio ID that'll play every time a player selects a response. Replace with 0 to not play any sound.
    clickSound: number?;

  }?;
  keybinds: {

    --[[
      Keyboard keybind to start a conversation with a character.
    ]]
    interactKey: Enum.KeyCode?;

    --[[
      Gamepad keybind to start a conversation with a character.
    ]]
    interactKeyGamepad: Enum.KeyCode?;

  }?;
};

export type DialogueClientProperties = {
  theme: ModuleScript?;
  dialogueServer: DialogueServer?;
}

export type DialogueClientMethods = {
  freezePlayer: (self: DialogueClient) -> ();
  unfreezePlayer: (self: DialogueClient) -> ();
  interact: (self: DialogueClient, dialogueServer: DialogueServer) -> ();
  getSettings: (self: DialogueClient) -> DialogueClientSettings;
  setSettings: (self: DialogueClient, newSettings: DialogueClientSettings) -> ();
  getDialogueServer: (self: DialogueClient) -> DialogueServer?;
  setDialogueServer: (self: DialogueClient, newDialogueServer: DialogueServer?) -> ();
}

export type DialogueClientEvents = {
  SettingsChanged: RBXScriptSignal<DialogueClientSettings>;
  DialogueServerChanged: RBXScriptSignal;
}

export type DialogueClient = DialogueClientProperties & DialogueClientMethods & DialogueClientEvents;

return {};