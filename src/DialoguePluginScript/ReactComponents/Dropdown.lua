--!strict
local React = require(script.Parent.Parent.Packages.react);

export type DropdownProps = {
  isOpen: boolean;
  selectedIndex: number;
  onSelect: () -> ();
  children: any;
}

local function Dropdown(props: DropdownProps)

  return React.createElement("TextButton", {}, {
    OptionsFrame = React.createElement("Frame", {
      Visible = props.isOpen;
    }, {
      React.createElement("UIListLayout", {
        Name = "UIListLayout";
      });
      props.children;
    });
  });

end;

return Dropdown;