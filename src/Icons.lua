--!strict

export type IconDictionary = {
  conversation: string;
  message: string;
  response: string;
  redirect: string;
  createDialogueButton: string;
  increasePriority: string;
  decreasePriority: string;
  check: string;
  link: string;
  close: string;
};

local icons: {[string]: IconDictionary} = {
  Dark = {
    createDialogueButton = "rbxassetid://96115609800319";
    conversation = "rbxassetid://14099768265";
    message = "rbxassetid://14099768265";
    response = "rbxassetid://14099769224";
    redirect = "rbxassetid://14099768484";
    increasePriority = "rbxassetid://87824103459111";
    decreasePriority = "rbxassetid://94586875773370";
    check = "rbxassetid://124828915127251";
    link = "rbxassetid://139085883308962";
    close = "rbxassetid://129602911342076";
  };
  Light = {
    createDialogueButton = "rbxassetid://105482129208897";
    conversation = "rbxassetid://14099768265";
    message = "rbxassetid://14099768265";
    response = "rbxassetid://14099769224";
    redirect = "rbxassetid://14099768484";
    increasePriority = "rbxassetid://87824103459111";
    decreasePriority = "rbxassetid://94586875773370";
    check = "rbxassetid://124828915127251";
    link = "rbxassetid://139085883308962";
    close = "rbxassetid://75787427205555";
  };
};

return icons;