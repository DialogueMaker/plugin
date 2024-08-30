--!strict
local React = require(script.Parent.Parent.Parent.Packages.react);

export type ResponseProperties = {
  onClick: () -> ();
  text: string;
}

local function ResponseButton(props: ResponseProperties)

  return React.createElement("TextButton", {
    [React.Event.Activated] = props.onClick;
    Text = props.text;
  });

end;

return ResponseButton;