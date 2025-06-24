--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type DropdownProps = {
  text: string;
  children: any;
  size: UDim2?;
  layoutOrder: number?;
  automaticSize: Enum.AutomaticSize?;
  toggleButtonChildren: any;
  isDisabled: boolean?;
  iconImage: string?;
  zIndex: number?;
  isOpen: boolean;
  setIsOpen: ((boolean) -> ());
}

local function Dropdown(props: DropdownProps)

  local colors = useStudioColors();

  local isOpen = props.isOpen;
  local setIsOpen = props.setIsOpen;
  local layoutOrder = props.layoutOrder or 0;

  return React.createElement("Frame", {
    BackgroundTransparency = 1;
    Size = props.size;
    LayoutOrder = layoutOrder;
    AutomaticSize = props.automaticSize;
    ZIndex = props.zIndex or 1;
  }, {
    Children = React.createElement(React.Fragment, {}, {props.toggleButtonChildren});
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 5);
    });
    ToggleButton = React.createElement(if props.isDisabled then "TextLabel" else "TextButton", {
      LayoutOrder = 1;
      Size = UDim2.fromScale(1, 1);
      BackgroundColor3 = if props.isDisabled then Color3.new(0.501961, 0.501961, 0.501961) else colors.input;
      BackgroundTransparency = if props.isDisabled then 0.75 else 0;
      [React.Event.Activated] = if props.isDisabled then nil else function()

        setIsOpen(not isOpen);

      end;
      Text = "";
    }, {
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 5);
      });
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
      SelectionFrame = React.createElement("Frame", {
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 0, 25);
        AutomaticSize = Enum.AutomaticSize.XY;
        LayoutOrder = 1;
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder;
          FillDirection = Enum.FillDirection.Horizontal;
          VerticalAlignment = Enum.VerticalAlignment.Center;
          Padding = UDim.new(0, 5);
        });
        Icon = if props.iconImage then
          React.createElement("ImageLabel", {
            LayoutOrder = 1;
            Image = props.iconImage;
            Size = UDim2.fromOffset(20, 20);
            BackgroundTransparency = 1;
            ImageTransparency = if props.isDisabled then 0.5 else 0;
            ImageColor3 = colors.text;
          })
        else nil;
        TextLabel = if props.text == "" then nil else React.createElement("TextLabel", {
          LayoutOrder = 2;
          Text = props.text;
          TextXAlignment = Enum.TextXAlignment.Left;
          TextColor3 = colors.text;
          TextTransparency = if props.isDisabled then 0.5 else 0;
          FontFace = Font.fromId(11702779517);
          TextSize = 14;
          BackgroundTransparency = 1;
        });
      });
      DropdownArrowIconContainer = React.createElement("Frame", {
        BackgroundTransparency = 1;
        Size = UDim2.new();
        AutomaticSize = Enum.AutomaticSize.XY;
        LayoutOrder = 2;
      }, {
        DropdownArrowIconLabel = React.createElement("ImageLabel", {
          LayoutOrder = 2;
          Image = "rbxassetid://14098646461";
          Size = UDim2.fromOffset(20, 20);
          BackgroundTransparency = 1;
          ImageTransparency = if props.isDisabled then 0.5 else 0;
          Rotation = if isOpen then 180 else 0;
          ImageColor3 = colors.text;
        });
      });
    });
    OptionsFrame = if isOpen and not props.isDisabled then React.createElement("ScrollingFrame", {
      BackgroundColor3 = colors.input;
      LayoutOrder = 2;
      Size = UDim2.fromScale(1, 0);
      AutomaticCanvasSize = Enum.AutomaticSize.Y;
      AutomaticSize = Enum.AutomaticSize.Y;
      CanvasSize = UDim2.fromScale(1, 1);
      [React.Event.InputEnded] = function(self, input)

        if input == Enum.UserInputType.MouseButton1 then

          setIsOpen(not isOpen);

        end;

      end;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 5);
      });
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 5);
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingTop = UDim.new(0, 5);
        PaddingBottom = UDim.new(0, 5);
        PaddingLeft = UDim.new(0, 5);
        PaddingRight = UDim.new(0, 5);
      });
      Children = React.createElement(React.Fragment, {}, {
        props.children;
      });
    }) else nil;
  });

end;

return React.memo(Dropdown);