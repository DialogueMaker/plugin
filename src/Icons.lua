--!strict

export type IconDictionary = {
  createDialogueButton: string;
};

local icons: {[string]: IconDictionary} = {
  Dark = {
    createDialogueButton = "rbxassetid://96115609800319";
  };
  Light = {
    createDialogueButton = "rbxassetid://105482129208897";
  };
};

return icons;