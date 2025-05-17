--!strict

export type DialogueServerSettings = {

  general: {

    npcName: string; 

    showName: boolean; 

    fitName: boolean; 

    theme: ModuleScript?; 

    letterDelay: number; 

    allowPlayerToSkipDelay: boolean; 

    freezePlayer: boolean; 

    endConversationIfOutOfDistance: boolean;

    maxConversationDistance: number;

    npcLooksAtPlayerDuringDialogue: boolean;

    npcNeckRotationMaxX: number;

    npcNeckRotationMaxY: number;

    npcNeckRotationMaxZ: number;

  };

  promptRegion: {

    enabled: boolean;

    location: BasePart?;

  };

  timeout: {

    enabled: boolean;

    seconds: number;

    waitForResponse: boolean;

  };

  speechBubble: {

    enabled: boolean;

    location: BasePart?;

  };

  clickDetector: {

    enabled: boolean;

    autoCreate: boolean;

    disappearsWhenDialogueActive: boolean;

    location: ClickDetector?;

  };

  proximityPrompt: {

    enabled: boolean;

    autoCreate: boolean;

    location: ProximityPrompt?;

  };

};

export type DialogueServerProperties = {
  settings: DialogueServerSettings;
  instance: ModuleScript;
  speechBubble: BillboardGui?;
  proximityPrompt: ProximityPrompt?;
  clickDetector: ClickDetector?;
};

export type DialogueServerMethods = {
  toggleTriggers: (self: DialogueServer, enabled: boolean) -> ();
};

export type DialogueServer = DialogueServerProperties & DialogueServerMethods;

return {}