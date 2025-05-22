export type IconDictionary = {
  editDialogueButton: string;
  resetScriptsButton: string;
  removeUnusedInstancesButton: string;
};

local icons: {[string]: IconDictionary} = {
  Dark = {
    editDialogueButton = "rbxassetid://14109181603";
    resetScriptsButton = "rbxassetid://79508672220984";
    removeUnusedInstancesButton = "rbxassetid://84394323866794";
  };
  Light = {
    editDialogueButton = "rbxassetid://71795784446490";
    resetScriptsButton = "rbxassetid://124128740725936";
    removeUnusedInstancesButton = "rbxassetid://123847425613619";
  };
};

return icons;