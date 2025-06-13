--!strict

local root = script.Parent.Parent.Parent.Parent.Parent;
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
  isOpen: boolean;
  setIsOpen: (boolean) -> ();
  iconImage: string?;
}

local function Dropdown(props: DropdownProps)

  local colors = useStudioColors();

  return React.createElement("Frame", {
    BackgroundTransparency = 1;
    Size = props.size;
    LayoutOrder = props.layoutOrder;
    AutomaticSize = props.automaticSize;
  }, {
    Children = React.createElement(React.Fragment, {}, {props.toggleButtonChildren});
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
    });
    ToggleButton = React.createElement(if props.isDisabled then "TextLabel" else "TextButton", {
      LayoutOrder = 1;
      Size = UDim2.new(1, 0, 1, 0);
      BackgroundTransparency = 1;
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
            Size = UDim2.new(0, 20, 0, 20);
            BackgroundTransparency = 1;
            ImageColor3 = colors.text;
          })
        else nil;
        TextLabel = if props.text == "" then nil else React.createElement("TextLabel", {
          LayoutOrder = 2;
          Text = props.text;
          TextXAlignment = if props.text == "" then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left;
          TextColor3 = colors.text;
          FontFace = Font.fromId(11702779517);
          TextSize = 14;
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
          Size = UDim2.new(0, 20, 0, 20);
          BackgroundTransparency = 1;
          Rotation = if props.isOpen then 180 else 0;
          ImageColor3 = colors.text;
        });
      });
      UIStroke = React.createElement("UIStroke", {
        Color = colors.border;
        Thickness = 1;
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        Transparency = if props.isDisabled then 0.5 else 0;
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
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      UIStroke = React.createElement("UIStroke", {
        Color = colors.border;
        Thickness = 1;
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
      });
      Children = React.createElement(React.Fragment, {}, {
        props.children;
      });
    }) else nil;
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 1);
      PaddingBottom = UDim.new(0, 1);
      PaddingLeft = UDim.new(0, 1);
      PaddingRight = UDim.new(0, 1);
    });
  });

end;

return React.memo(Dropdown);