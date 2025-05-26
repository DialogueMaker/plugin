--!strict

local StarterPlayer = game:GetService("StarterPlayer");
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts;

local DialogueClientScript = StarterPlayerScripts.DialogueClientScript;
local React = require(DialogueClientScript.Packages.react);

export type ResponseProperties = {
  onClick: () -> ();
  text: string;
  layoutOrder: number;
}

local function ResponseButton(props: ResponseProperties)

  return React.createElement("TextButton", {
    Size = UDim2.new(0.5, -3, 0, 0);
    AutomaticSize = Enum.AutomaticSize.Y;
    BackgroundColor3 = Color3.fromHex("#202020");
    TextColor3 = Color3.new(1, 1, 1);
    Text = props.text;
    LayoutOrder = props.layoutOrder;
    FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
    TextSize = 14;
    [React.Event.Activated] = props.onClick;
  }, {
    UIFlexItem = React.createElement("UIFlexItem", {
      FlexMode = Enum.UIFlexMode.Fill;
    });
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 8);
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
    });
  });

end;

return ResponseButton;