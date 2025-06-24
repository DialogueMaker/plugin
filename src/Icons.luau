--!strict

export type IconDictionary = {
  conversation: string;
  message: string;
  response: string;
  redirect: string;
  logo: string;
  increasePriority: string;
  decreasePriority: string;
  check: string;
  link: string;
  close: string;
  settings: string;
};

local icons: {[string]: IconDictionary} = {
  Dark = {
    logo = "rbxassetid://77494276227199";
    conversation = "rbxassetid://77494276227199";
    message = "rbxassetid://14099768265";
    response = "rbxassetid://14099769224";
    redirect = "rbxassetid://14099768484";
    increasePriority = "rbxassetid://87824103459111";
    decreasePriority = "rbxassetid://94586875773370";
    check = "rbxassetid://124828915127251";
    link = "rbxassetid://139085883308962";
    close = "rbxassetid://129602911342076";
    settings = "rbxassetid://14099277263";
  };
  Light = {
    logo = "rbxassetid://98624626622893";
    conversation = "rbxassetid://98624626622893";
    message = "rbxassetid://14099768265";
    response = "rbxassetid://14099769224";
    redirect = "rbxassetid://14099768484";
    increasePriority = "rbxassetid://87824103459111";
    decreasePriority = "rbxassetid://94586875773370";
    check = "rbxassetid://124828915127251";
    link = "rbxassetid://139085883308962";
    close = "rbxassetid://75787427205555";
    settings = "rbxassetid://14099277263";
  };
};

return icons;