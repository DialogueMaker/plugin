--!strict
local React = require(script.Parent.Parent.Packages.react);

export type ToolbarButtonProps = {
  iconImage: string;
  text: string;
  layoutOrder: number;
  isDisabled: boolean?;
  onClick: () -> ();
};

local function ToolbarButton(props: ToolbarButtonProps)

  return React.createElement("TextButton", {
    LayoutOrder = props.layoutOrder;
    BackgroundTransparency = 0;
    BackgroundColor3 = Color3.fromRGB(74, 74, 74);
    AutomaticButtonColor = not props.isDisabled;
    Text = "";
    Size = UDim2.new(0, 0, 0, 0);
    [React.Event.Activated] = function()
      
      if (not props.isDisabled) then

        props.onClick();

      end;

    end;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Horizontal;
    });
    IconImageLabel = React.createElement("ImageLabel", {
      LayoutOrder = 1;
      BackgroundTransparency = 1;
      Image = props.iconImage;
      Size = UDim2.new(0, 24, 0, 24);
    });
    TextLabel = React.createElement("TextLabel", {
      LayoutOrder = 2;
      BackgroundTransparency = 1;
      Text = props.text;
      TextSize = 12;
      Size = UDim2.new(0, 0, 1, 0);
      AutomaticSize = Enum.AutomaticSize.X;
    });
  });

end;

return ToolbarButton;