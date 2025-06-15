--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Button = require(root.DialogueEditor.components.Button);
local Checkbox = require(root.DialogueEditor.components.Checkbox);
local Dropdown = require(root.DialogueEditor.components.Dropdown);
local DropdownOption = require(root.DialogueEditor.components.DropdownOption);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useStudioIcons = require(root.DialogueEditor.hooks.useStudioIcons);
local useDialogueContentScript = require(script.hooks.useDialogueContentScript);

export type PreviewProperties = {
  selectedScript: ModuleScript;
  layoutOrder: number;
  plugin: Plugin;
}

local function Preview(properties: PreviewProperties)

  local selectedScript = properties.selectedScript;
  local layoutOrder = properties.layoutOrder;
  local plugin = properties.plugin;
  local colors = useStudioColors();
  local icons = useStudioIcons();
  local dialogueContentScript, isDialogueContentScriptEnabled = useDialogueContentScript(selectedScript);

  local selectedDialogueType: string?, setSelectedDialogueType = React.useState(
    if selectedScript then 
      (selectedScript:GetAttribute("DialogueType") :: string?) or (
        if selectedScript:HasTag("DialogueMakerConversationScript") then "Conversation" else nil
      )
    else nil
  );
  React.useEffect(function(): ()
  
    local function refreshDialogueType()

      setSelectedDialogueType(
        if selectedScript then 
          (selectedScript:GetAttribute("DialogueType") :: string?) or (
            if selectedScript:HasTag("DialogueMakerConversationScript") then "Conversation" else nil
          )
        else nil
      );

    end;

    refreshDialogueType();

    local dialogueTypeChangedConnection = selectedScript:GetAttributeChangedSignal("DialogueType"):Connect(refreshDialogueType);

    return function()

      dialogueTypeChangedConnection:Disconnect();

    end;

  end, {selectedScript});

  local dropdownOptions = {};
  local isDialogueTypeDropdownOpen, setIsDialogueTypeDropdownOpen = React.useState(false);
  if selectedDialogueType ~= "Conversation" then

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

  local dialogueOptions: {React.ReactNode} = {};
  local isActionsDropdownOpen, setIsActionsDropdownOpen = React.useState(false);
  if selectedDialogueType ~= "Conversation" then

    local conditionButton = React.createElement(Button, {
      key = "ConditionButton";
      text = "Edit condition";
      layoutOrder = #dialogueOptions + 1;
      onClick = function()

        local conditionScript = selectedScript:FindFirstChild("ConditionScript");
        if not conditionScript then

          local newConditionScript = root.Templates.DialogueConditionScriptTemplate:Clone();
          newConditionScript.Name = "ConditionScript";
          newConditionScript.Parent = selectedScript;
          conditionScript = newConditionScript;

        end;

        assert(conditionScript and conditionScript:IsA("ModuleScript"), `Condition script not found for {selectedScript:GetFullName()}.`);

        plugin:OpenScript(conditionScript);

      end;
    });

    table.insert(dialogueOptions, conditionButton);

    local actionsDropdownOptions = {};
    local actionTypes = {"Initialization", "Completion", "Cleanup"};
    for index, actionType in actionTypes do

      -- Redirects only have initialization actions.
      if selectedDialogueType == "Redirect" and actionType ~= "Initialization" then

        continue; 
      
      end;

      local option = React.createElement(DropdownOption, {
        key = actionType :: string;
        text = actionType :: string;
        layoutOrder = index;
        onClick = function()

          -- Make sure the script is there.
          local actionScript = selectedScript:FindFirstChild(`{actionType}ActionScript`);
          if not actionScript then

            local newActionScript = root.Templates:FindFirstChild(`Dialogue{actionType}ActionScriptTemplate`):Clone();
            newActionScript.Name = `{actionType}ActionScript`;
            newActionScript.Parent = selectedScript;
            actionScript = newActionScript;

          end;

          assert(actionScript and actionScript:IsA("ModuleScript"), `{actionType} action script not found for {selectedScript:GetFullName()}.`);

          plugin:OpenScript(actionScript);

        end;
      });

      table.insert(actionsDropdownOptions, option);

    end;

    local actionsDropdown = React.createElement(Dropdown, {
      layoutOrder = #dialogueOptions + 1;
      key = "ActionsDropdown";
      text = "Edit actions";
      size = UDim2.fromOffset(125, 30);
      isOpen = isActionsDropdownOpen;
      setIsOpen = setIsActionsDropdownOpen;
    }, actionsDropdownOptions);

    table.insert(dialogueOptions, actionsDropdown);

  end;

  local deleteButton = React.createElement(Button, {
    key = "DeleteButton";
    text = "Delete";
    backgroundColor = colors.backgroundWarning;
    layoutOrder = #dialogueOptions + 1;
    onClick = function()

      Selection:Set({selectedScript.Parent});
      selectedScript:Destroy();

    end;
  });

  table.insert(dialogueOptions, deleteButton);

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
    DialogueMetadata = React.createElement("Frame", {
      BackgroundTransparency = 1;
      LayoutOrder = 1;
      Size = UDim2.fromScale(1, 0);
      AutomaticSize = Enum.AutomaticSize.Y;
      ZIndex = 2;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        Padding = UDim.new(0, 15);
        Wraps = true;
      });
      DialogueTypeDropdown = React.createElement(Dropdown, {
        iconImage = if selectedDialogueType then icons[`{selectedDialogueType:sub(1, 1):lower()}{selectedDialogueType:sub(2)}`] else icons.conversation;
        text = selectedDialogueType or "Conversation";
        isDisabled = not selectedDialogueType or selectedDialogueType == "Conversation";
        size = UDim2.fromOffset(150, 30);
        layoutOrder = 1;
        isOpen = isDialogueTypeDropdownOpen;
        setIsOpen = setIsDialogueTypeDropdownOpen;
      }, dropdownOptions);
      ShouldAutoTriggerCheckbox = if selectedDialogueType == "Conversation" then
        React.createElement(Checkbox, {
          text = "Auto-trigger";
          isChecked = selectedScript:GetAttribute("ShouldAutoTrigger") == true;
          layoutOrder = 2;
          onChanged = function(isChecked: boolean)

            selectedScript:SetAttribute("ShouldAutoTrigger", isChecked);

          end;
        })
      else nil;
      ShouldUseDynamicContent = if selectedDialogueType == "Message" or selectedDialogueType == "Response" then
        React.createElement(Checkbox, {
          text = "Dynamic content";
          isChecked = isDialogueContentScriptEnabled;
          layoutOrder = 3;
          onChanged = function(isChecked: boolean)

            if not dialogueContentScript then

              local newDialogueContentScript = root.Templates.DialogueContentScriptTemplate:Clone();
              newDialogueContentScript.Name = "DialogueContentScript";
              newDialogueContentScript.Parent = selectedScript;
              dialogueContentScript = newDialogueContentScript;

            end;

            assert(dialogueContentScript and dialogueContentScript:IsA("ModuleScript"), `Dialogue content script not found for {selectedScript:GetFullName()}.`);

            dialogueContentScript:SetAttribute("IsDisabled", not isChecked);

          end;
        })
      else nil;
    });
    DialogueContentBox = if not isDialogueContentScriptEnabled and selectedDialogueType == "Message" or selectedDialogueType == "Response" then
      React.createElement("TextBox", {
        Text = selectedScript:GetAttribute("DialogueContent") or "";
        PlaceholderText = "Enter dialogue content here. For variables and effects, use a content script instead.";
        TextColor3 = colors.text;
        ClearTextOnFocus = false;
        TextSize = 14;
        LayoutOrder = 2;
        Size = UDim2.new(1, 0, 0, 100);
        BackgroundColor3 = colors.input;
        FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
        [React.Change.Text] = function(self: TextBox)

          selectedScript:SetAttribute("DialogueContent", self.Text);

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
    DynamicContentNotification = if (selectedDialogueType == "Message" or selectedDialogueType == "Response") and dialogueContentScript and isDialogueContentScriptEnabled then
      React.createElement("Frame", {
        BackgroundTransparency = 1;
        LayoutOrder = 3;
        Size = UDim2.new(1, 0, 0, 100);
      }, {
        UICorner = React.createElement("UICorner", {
          CornerRadius = UDim.new(0, 5);
        });
        UIStroke = React.createElement("UIStroke", {
          Color = colors.border;
          Thickness = 1;
          ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        });
        UIListLayout = React.createElement("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder;
          VerticalAlignment = Enum.VerticalAlignment.Center;
          HorizontalAlignment = Enum.HorizontalAlignment.Center;
          Padding = UDim.new(0, 10);
        });
        UIPadding = React.createElement("UIPadding", {
          PaddingTop = UDim.new(0, 15);
          PaddingBottom = UDim.new(0, 15);
          PaddingLeft = UDim.new(0, 15);
          PaddingRight = UDim.new(0, 15);
        });
        NotificationLabel = React.createElement("TextLabel", {
          AutomaticSize = Enum.AutomaticSize.XY;
          Text = "For your safety, dynamic content cannot be previewed in the Dialogue Editor.";
          TextColor3 = colors.text;
          TextWrapped = true;
          FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
          TextSize = 14;
          BackgroundTransparency = 1;
          LayoutOrder = 1;
        });
        NotificationButton = React.createElement(Button, {
          AutomaticSize = Enum.AutomaticSize.XY;
          text = "Open script editor";
          layoutOrder = 2;
          onClick = function()

            plugin:OpenScript(dialogueContentScript);

          end;
        });
      })
    else nil;
    Options = if #dialogueOptions > 0 then
      React.createElement("Frame", {
        BackgroundTransparency = 1;
        LayoutOrder = 4;
        Size = UDim2.fromScale(1, 0);
        AutomaticSize = Enum.AutomaticSize.Y;
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder;
          FillDirection = Enum.FillDirection.Horizontal;
          Padding = UDim.new(0, 10);
          Wraps = true;
        });
        DialogueOptions = React.createElement(React.Fragment, {}, dialogueOptions);
      })
    else nil;
  });

end;

return React.memo(Preview);