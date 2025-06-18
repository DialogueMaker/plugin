--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type TextInputProperties = {
  value: string?;
  placeholder: string?;
  onChanged: (value: string) -> ();
  layoutOrder: number;
}

local function TextInput(properties: TextInputProperties)

  local colors = useStudioColors();
  local placeholderText = properties.placeholder or "";
  local layoutOrder = properties.layoutOrder or 1;
  local onChanged = properties.onChanged;
  local text, setText = React.useState(properties.value or "");

  React.useEffect(function()
  
    setText(properties.value or "");

  end, { properties.value });

  return React.createElement("TextBox", {
    Text = text;
    TextColor3 = colors.text;
    PlaceholderText = placeholderText;
    TextSize = 14;
    BackgroundTransparency = 0;
    LayoutOrder = layoutOrder;
    FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
    Size = UDim2.new(1, 0, 0, 30);
    ClearTextOnFocus = false;
    BackgroundColor3 = colors.input;
    [React.Change.Text] = function(self: TextBox)
    
      local newText = self.Text;
      setText(newText);

    end,
    [React.Event.FocusLost] = function(self: TextBox)
    
      setText(properties.value or "");
      onChanged(self.Text);

    end;
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingLeft = UDim.new(0, 10);
      PaddingRight = UDim.new(0, 10);
    });
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
    UISizeConstraint = React.createElement("UISizeConstraint", {
      MaxSize = Vector2.new(100, math.huge);
    });
  });

end;

return React.memo(TextInput);