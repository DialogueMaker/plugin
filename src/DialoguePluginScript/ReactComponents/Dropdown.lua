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
      [React.Event.InputEnded] = function(self, input)

        if input == Enum.UserInputType.MouseButton1 then

          setIsOpen(not isOpen)

        end;

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