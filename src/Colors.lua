--!strict

export type ColorDictionary = {
  backgroundResponse: Color3;
  backgroundRedirect: Color3;
  backgroundWarning: Color3;
  backgroundDeletionFrame: Color3;
  backgroundTableHeader: Color3;
  backgroundTableRow: Color3;
  text: Color3;
  textDisabled: Color3;
  textPlaceholder: Color3;
  buttonText: Color3;
  toolbar: Color3;
  toolbarButton: Color3;
  primaryButton: Color3;
  border: Color3;
  input: Color3;
};

local colors: {[string]: ColorDictionary} = {
  Dark = {
    backgroundResponse = Color3.fromRGB(30, 103, 19);
    backgroundRedirect = Color3.fromRGB(21, 44, 126);
    backgroundWarning = Color3.fromRGB(207, 57, 51);
    backgroundDeletionFrame = Color3.new(0, 0, 0);
    backgroundTableHeader = Color3.fromRGB(72, 72, 72);
    backgroundTableRow = Color3.fromRGB(50, 50, 50);
    text = Color3.new(1, 1, 1);
    textDisabled = Color3.fromRGB(182, 182, 182);
    textPlaceholder = Color3.fromRGB(175, 175, 175);
    toolbar = Color3.fromRGB(74, 74, 74);
    primaryButton = Color3.fromRGB(79, 161, 255);
    toolbarButton = Color3.fromRGB(74, 74, 74);
    buttonText = Color3.fromRGB(255, 255, 255);
    border = Color3.fromRGB(34, 34, 34);
    dropdownButton = Color3.fromRGB(201, 201, 201);
    input = Color3.fromRGB(50, 50, 50);
  };
  Light = {
    backgroundResponse = Color3.fromRGB(30, 103, 19);
    backgroundRedirect = Color3.fromRGB(21, 44, 126);
    backgroundWarning = Color3.fromRGB(207, 57, 51);
    backgroundDeletionFrame = Color3.new(0, 0, 0);
    backgroundTableHeader = Color3.fromRGB(242, 242, 242);
    backgroundTableRow = Color3.fromRGB(255, 255, 255);
    text = Color3.new(0, 0, 0);
    textDisabled = Color3.fromRGB(145, 145, 145);
    textPlaceholder = Color3.fromRGB(85, 85, 85);
    toolbar = Color3.fromRGB(227, 227, 227);
    buttonText = Color3.fromRGB(255, 255, 255);
    toolbarButton = Color3.fromRGB(201, 201, 201);
    border = Color3.fromRGB(201, 201, 201);
    dropdownButton = Color3.fromRGB(201, 201, 201);
    primaryButton = Color3.fromRGB(79, 161, 255);
    input = Color3.fromRGB(255, 255, 255);
  };
};

return colors;