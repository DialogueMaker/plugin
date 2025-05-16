--!strict
local DialogueClientScript = script.Parent.Parent.Parent.Parent;
local React = require(DialogueClientScript.Packages.react);

export type ResponseProperties = {
  onClick: () -> ();
  text: string;
  layoutOrder: number;
}

local function ResponseButton(props: ResponseProperties)

  return React.createElement("TextButton", {
    [React.Event.Activated] = props.onClick;
    Text = props.text;
    LayoutOrder = props.layoutOrder;
  });

end;

return ResponseButton;