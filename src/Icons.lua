--!strict

export type IconDictionary = {
  createDialogueButton: string;
  editDialogueButton: string;
  initializeClientButton: string;
  resetClientPackagesButton: string;
  adjustClientSettingsButton: string;
};

local icons: {[string]: IconDictionary} = {
  Dark = {
    createDialogueButton = "rbxassetid://96115609800319";
    editDialogueButton = "rbxassetid://127299128199963";
    initializeClientButton = "rbxassetid://132607891158489";
    resetClientPackagesButton = "rbxassetid://79508672220984";
    adjustClientSettingsButton = "rbxassetid://97729919485963";
  };
  Light = {
    createDialogueButton = "rbxassetid://105482129208897";
    editDialogueButton = "rbxassetid://90245206529823";
    initializeClientButton = "rbxassetid://1309120878585096";
    resetClientPackagesButton = "rbxassetid://124128740725936";
    adjustClientSettingsButton = "rbxassetid://132037029914710";
  };
};

return icons;