--!strict
local React = require(script.Parent.Parent.Packages.react);

export type DropdownProps = {
  selectedIndex: number;
  children: any;
}

local function Dropdown(props: DropdownProps)

  local isOpen, setIsOpen = React.useState(false);

  return React.createElement("TextButton", {}, {
    OptionsFrame = React.createElement("Frame", {
      [React.Event.MouseButton1Click] = function()

        setIsOpen(not isOpen)

      end;
      Visible = isOpen;
    }, {
      React.createElement("UIStroke", {
        Name = "UIStroke";
        Transparency = 0.53;
      });
      React.createElement("UIListLayout", {
        Name = "UIListLayout";
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      props.children;
    });
  });

end;

return Dropdown;