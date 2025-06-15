--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Dropdown = require(root.DialogueEditor.components.Dropdown);
local DropdownOption = require(root.DialogueEditor.components.Dropdown.DropdownOption);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useStudioIcons = require(root.DialogueEditor.hooks.useStudioIcons);

export type PreviewProperties = {
  selectedScript: ModuleScript;
  layoutOrder: number;
}

local function Preview(properties: PreviewProperties)

  local selectedScript = properties.selectedScript;
  local layoutOrder = properties.layoutOrder;
  local colors = useStudioColors();
  local icons = useStudioIcons();

  local dropdownOptions = {};

  local selectedDialogueType: string?, setSelectedDialogueType = React.useState(if selectedScript then selectedScript:GetAttribute("DialogueType") else nil);
  React.useEffect(function(): ()
  
    local function refreshDialogueType()

      setSelectedDialogueType(selectedScript and (selectedScript:GetAttribute("DialogueType") :: string?) or nil);

    end;

    refreshDialogueType();

    local dialogueTypeChangedConnection = selectedScript:GetAttributeChangedSignal("DialogueType"):Connect(refreshDialogueType);

    return function()

      dialogueTypeChangedConnection:Disconnect();

    end;

  end, {selectedScript});

  local isDialogueTypeDropdownOpen, setIsDialogueTypeDropdownOpen = React.useState(false);
  if not selectedScript:HasTag("DialogueMakerConversationScript") then

    local dialogueTypes = {"Message", "Response", "Redirect"};
    for index, dialogueType in dialogueTypes do

      local option = React.createElement(DropdownOption, {
        key = dialogueType;
        text = dialogueType;
        layoutOrder = index;
        iconImage = icons[`{dialogueType:sub(1, 1):upper()}{dialogueType:sub(2)}`];
        onClick = function()

          selectedScript:SetAttribute("DialogueType", dialogueType);
          setIsDialogueTypeDropdownOpen(false);

        end;
      });

      table.insert(dropdownOptions, option);

    end;

  end;

  return React.createElement("Frame", {
    BackgroundColor3 = colors.toolbar;
    LayoutOrder = layoutOrder;
    AutomaticSize = Enum.AutomaticSize.Y;
    Size = UDim2.fromScale(1, 0);
    ZIndex = 2;
  }, {
    UICorner = React.createElement("UICorner", {
      CornerRadius = UDim.new(0, 5);
    });
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
    });
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      FillDirection = Enum.FillDirection.Vertical;
      Padding = UDim.new(0, 15);
    });
    DialogueTypeDropdown = React.createElement(Dropdown, {
      iconImage = if selectedDialogueType then icons[`{selectedDialogueType:sub(1, 1)}{selectedDialogueType:sub(2)}`] else icons.conversation;
      text = selectedDialogueType or "Conversation";
      isDisabled = not selectedDialogueType;
      size = UDim2.fromOffset(150, 30);
      zIndex = 2;
      isOpen = isDialogueTypeDropdownOpen;
      setIsOpen = setIsDialogueTypeDropdownOpen;
    }, dropdownOptions);
    DialogueContentBox = if selectedDialogueType == "Message" or selectedDialogueType == "Response" then
      React.createElement("TextBox", {
        Text = selectedScript:GetAttribute("DialogueContent") or "";
        TextColor3 = colors.text;
        AutomaticSize = Enum.AutomaticSize.Y;
        TextSize = 14;
        LayoutOrder = 2;
        Size = UDim2.fromScale(1, 0);
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
        [React.Change.Text] = function(rbx: TextBox)

          selectedScript:SetAttribute("DialogueContent", rbx.Text);

        end;
      }, {
        UIPadding = React.createElement("UIPadding", {
          PaddingTop = UDim.new(0, 15);
          PaddingBottom = UDim.new(0, 15);
          PaddingLeft = UDim.new(0, 15);
          PaddingRight = UDim.new(0, 15);
        });
        UISizeConstraint = React.createElement("UISizeConstraint", {
          MinSize = Vector2.new(0, 30);
        });
        UICorner = React.createElement("UICorner", {
          CornerRadius = UDim.new(0, 5);
        });
      })
    else nil;
  });

end;

return React.memo(Preview);