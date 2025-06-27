--!strict

local root = script.Parent;
local Button = require(root.DialogueEditor.components.Button);
local Paragraph = require(root.DialogueEditor.components.Paragraph);
local React = require(root.roblox_packages.react);
local ReactErrorBoundary = require(root.roblox_packages.ReactErrorBoundary);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

type FallbackProps = ReactErrorBoundary.FallbackProps;

local function ErrorComponent(props: FallbackProps)

  local colors = useStudioColors();

  return React.createElement("Frame", {
    BackgroundColor3 = colors.toolbar;
    Size = UDim2.fromScale(1, 1);
  }, {
    Content = React.createElement("Frame", {
      Size = UDim2.fromScale(1, 1);
      BackgroundTransparency = 1;
      AnchorPoint = Vector2.new(0.5, 0.5);
      Position = UDim2.fromScale(0.5, 0.5);
    }, {
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 15);
        PaddingRight = UDim.new(0, 15);
        PaddingTop = UDim.new(0, 15);
        PaddingBottom = UDim.new(0, 15);
      });
      UIListLayout = React.createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10);
      });
      WarningIcon = React.createElement("ImageLabel", {
        Image = "rbxassetid://126149752885425";
        Size = UDim2.fromOffset(50, 50);
        BackgroundTransparency = 1;
        LayoutOrder = 1;
      });
      TextLabel = React.createElement(Paragraph, {
        text = "A critical error occurred. Dialogue Maker Plugin cannot continue.";
        layoutOrder = 2;
        fontWeight = Enum.FontWeight.Bold;
        fontSize = Enum.FontSize.Size24;
      });
      TextBox = React.createElement("TextBox", {
        Text = tostring(props.error),
        TextColor3 = colors.text,
        AutomaticSize = Enum.AutomaticSize.Y;
        Size = UDim2.fromScale(1, 0);
        TextSize = 14;
        FontFace = Font.fromName("Inconsolata", Enum.FontWeight.Regular);
        BackgroundColor3 = colors.input;
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left;
        TextEditable = false;
        ClearTextOnFocus = false;
        LayoutOrder = 3;
      }, {
        UICorner = React.createElement("UICorner", {
          CornerRadius = UDim.new(0, 5);
        });
        UIPadding = React.createElement("UIPadding", {
          PaddingLeft = UDim.new(0, 10);
          PaddingRight = UDim.new(0, 10);
          PaddingTop = UDim.new(0, 10);
          PaddingBottom = UDim.new(0, 10);
        });
      });
      TextButton = React.createElement(Button, {
        text = "Restart plugin",
        BorderSizePixel = 0;
        layoutOrder = 4;
        onClick = function()
          
          props.resetErrorBoundary();
          
        end;
      });
      UISizeConstraint = React.createElement("UISizeConstraint", {
        MaxSize = Vector2.new(750, math.huge);
      });
    });
  });

end;

return React.memo(ErrorComponent);