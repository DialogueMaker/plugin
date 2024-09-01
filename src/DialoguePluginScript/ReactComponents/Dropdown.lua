--!strict
local React = require(script.Parent.Parent.Packages.react);
local Colors = require(script.Parent.Parent.Colors);

export type DropdownProps = {
  text: string?;
  children: any;
  size: UDim2?;
  layoutOrder: number?;
  automaticSize: Enum.AutomaticSize?;
  toggleButtonChildren: any;
  isOpen: boolean;
  setIsOpen: (boolean) -> ();
}

local function Dropdown(props: DropdownProps)

  return React.createElement("Frame", {
    Size = props.size;
    LayoutOrder = props.layoutOrder;
    AutomaticSize = props.automaticSize;
  }, {
    Children = React.createElement(React.Fragment, {}, {props.toggleButtonChildren});
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    ToggleButton = React.createElement("TextButton", {
      LayoutOrder = 1;
      Size = UDim2.new(1, 0, 1, 0);
      BackgroundColor3 = Color3.fromRGB(70, 70, 70);
      [React.Event.Activated] = function()

        props.setIsOpen(not props.isOpen);

      end;
      Text = "";
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween;
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
        VerticalAlignment = Enum.VerticalAlignment.Center;
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 5);
        PaddingRight = UDim.new(0, 5);
      });
      TextLabel = if props.text == "" then nil else React.createElement("TextLabel", {
        LayoutOrder = 1;
        Text = props.text;
        TextXAlignment = if props.text == "" then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left;
        TextColor3 = Colors.text;
        FontFace = Font.fromId(11702779517);
        TextSize = 14;
      });
      DropdownIconLabel = React.createElement("ImageLabel", {
        LayoutOrder = 2;
        Image = "rbxassetid://14098646461";
        Size = UDim2.new(0, 20, 0, 20);
        BackgroundTransparency = 1;
      });
    });
    OptionsFrame = if props.isOpen then React.createElement("Frame", {
      LayoutOrder = 2;
      Size = UDim2.new(1, 0, 1, 0);
      [React.Event.InputEnded] = function(self, input)

        if input == Enum.UserInputType.MouseButton1 then

          props.setIsOpen(not props.isOpen);

        end;

      end;
    }, {
      UIStroke = React.createElement("UIStroke", {
        Transparency = 0.53;
      });
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      Children = React.createElement(React.Fragment, {}, {
        props.children;
      });
    }) else nil;
  });

end;

return Dropdown;