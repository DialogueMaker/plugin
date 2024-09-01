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
  isDisabled: boolean?;
  isOpen: boolean;
  setIsOpen: (boolean) -> ();
}

local function Dropdown(props: DropdownProps)

  return React.createElement("Frame", {
    BackgroundTransparency = 1;
    Size = props.size;
    LayoutOrder = props.layoutOrder;
    AutomaticSize = props.automaticSize;
  }, {
    Children = React.createElement(React.Fragment, {}, {props.toggleButtonChildren});
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 5);
    });
    ToggleButton = React.createElement(if props.isDisabled then "TextLabel" else "TextButton", {
      LayoutOrder = 1;
      Size = UDim2.new(1, 0, 1, 0);
      BackgroundColor3 = Color3.fromRGB(70, 70, 70);
      [React.Event.Activated] = if props.isDisabled then nil else function()

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
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 15);
      });
    });
    OptionsFrame = if props.isOpen and not props.isDisabled then React.createElement("ScrollingFrame", {
      LayoutOrder = 2;
      Size = UDim2.new(1, 0, 0, 0);
      AutomaticCanvasSize = Enum.AutomaticSize.Y;
      AutomaticSize = Enum.AutomaticSize.Y;
      CanvasSize = UDim2.new(1, 0, 1, 0);
      [React.Event.InputEnded] = function(self, input)

        if input == Enum.UserInputType.MouseButton1 then

          props.setIsOpen(not props.isOpen);

        end;

      end;
    }, {
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 15);
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