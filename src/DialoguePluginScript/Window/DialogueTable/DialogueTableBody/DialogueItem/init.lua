--!strict
local root = script.Parent.Parent.Parent.Parent;
local React = require(root.Packages.react);
local Dropdown = require(script.Dropdown);
local useDialogueContainer = require(script.useDialogueContainer);
local DropdownOption = require(script.DropdownOption);
local useStudioColors = require(root.useStudioColors);

export type DialogueItemProperties = {
  type: "Response" | "Message" | "Redirect";
  contentScript: ModuleScript;
  setDialogueParent: (ModuleScript | Folder) -> ();
  isDeleteModeEnabled: boolean;
  layoutOrder: number;
  zIndex: number;
  priority: string;
  dialogueParent: ModuleScript | Folder;
  plugin: Plugin;
}

local function DialogueItem(props: DialogueItemProperties)

  local colors = useStudioColors();

  local showDeletionConfirmation, setShowDeletionConfirmation = React.useState(false);
  local isDialogueTypeDropdownOpen, setIsDialogueTypeDropdownOpen = React.useState(false);
  local isConnectionsDropdownOpen, setIsConnectionsDropdownOpen = React.useState(false);
  local isDeleteModeEnabled = props.isDeleteModeEnabled;
  local dialogueContainer = useDialogueContainer(props.dialogueParent);
  local contentScript = props.contentScript;

  local function openSpecialScript(scriptType: "Action" | "Condition"): ()

    -- Create a special script if necessary.
    local specialScript = contentScript:FindFirstChild(scriptType) :: ModuleScript?;

    if not specialScript then

      local newSpecialScript = script.Parent.Parent.Templates[`{scriptType}Template`]:Clone();
      newSpecialScript.Name = scriptType;
      newSpecialScript.Parent = contentScript;
      specialScript = newSpecialScript;

    end;

    -- Open the condition script
    props.plugin:OpenScript(specialScript :: ModuleScript);

  end;

  local isResponse = props.type == "Response";
  local isRedirect = props.type == "Redirect";

  return React.createElement("Frame", {
    [React.Event.InputEnded] = function(self: Frame, input: InputObject)

      if input.UserInputType == Enum.UserInputType.MouseButton1 then

        setShowDeletionConfirmation(true);

      end

    end;
    BackgroundColor3 = if isResponse then colors.backgroundResponse else colors.backgroundRedirect;
    BackgroundTransparency = if isResponse or isRedirect then 0.4 else 1;
    BorderSizePixel = 0;
    ZIndex = props.zIndex;
    LayoutOrder = props.layoutOrder;
    Size = UDim2.new(1, 0, 0, 22);
  }, {
    DeletionConfirmationFrame = if showDeletionConfirmation then React.createElement("Frame", {
      ZIndex = 2;
      Size = UDim2.new(1, 0, 1, 0);
      BackgroundTransparency = 0.5;
      BackgroundColor3 = colors.backgroundDeletionFrame;
      BorderSizePixel = 0;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        Padding = UDim.new(0, 5);
      });
      QuestionTextLabel = React.createElement("TextLabel", {
        BackgroundTransparency = 1;
        LayoutOrder = 1;
        Text = "Delete?";
        TextColor3 = colors.text;
        FontFace = Font.fromId(11702779517, Enum.FontWeight.Bold);
        AutomaticSize = Enum.AutomaticSize.XY;
        TextSize = 16;
      });
      ConfirmButton = React.createElement("TextButton", {
        LayoutOrder = 2;
        BackgroundColor3 = colors.backgroundWarning;
        Text = "Yes";
        TextSize = 16;
        TextColor3 = colors.text;
        FontFace = Font.fromId(11702779517, Enum.FontWeight.Regular);
        BorderSizePixel = 0;
        AutomaticSize = Enum.AutomaticSize.XY;
        [React.Event.Activated] = function()

          contentScript:Destroy();
          setShowDeletionConfirmation(false);

        end;
      }, {
        UIPadding = React.createElement("UIPadding", {
          PaddingLeft = UDim.new(0, 5);
          PaddingRight = UDim.new(0, 5);
        });
      });
      CancelButton = React.createElement("TextButton", {
        BackgroundTransparency = 1;
        LayoutOrder = 3;
        Text = "No";
        TextColor3 = colors.text;
        TextSize = 16;
        FontFace = Font.fromId(11702779517, Enum.FontWeight.Regular);
        AutomaticSize = Enum.AutomaticSize.XY;
        BorderSizePixel = 0;
        [React.Event.Activated] = function()

          setShowDeletionConfirmation(false);

        end;
      }, {
        UIPadding = React.createElement("UIPadding", {
          PaddingLeft = UDim.new(0, 5);
          PaddingRight = UDim.new(0, 5);
        });
      });
    }) else nil;
    Content = React.createElement("Frame", {
      ZIndex = 1;
      BackgroundTransparency = 1;
      Size = UDim2.new(1, 0, 1, 0);
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        Padding = UDim.new(0, 3);
      });
      PriorityTextBox = React.createElement(if showDeletionConfirmation then "TextLabel" else "TextBox", {
        Text = props.priority;
        PlaceholderText = if showDeletionConfirmation then nil else props.priority;
        TextColor3 = colors.text;
        PlaceholderColor3 = if showDeletionConfirmation then nil else colors.textPlaceholder;
        LayoutOrder = 1;
        Size = UDim2.new(0, 60, 1, 0);
        BackgroundTransparency = 1;
        [React.Event.FocusLost] = if showDeletionConfirmation then nil else function(self)

          -- Make sure the priority is valid
          local isUserTextInvalid = false;
          local userText = self.Text :: string;
          if userText:sub(1, 1) == "." or userText:sub(userText:len()) == "." then

            isUserTextInvalid = true;

          end;

          local currentDirectory: Folder | ModuleScript = dialogueContainer;
          local splitPriority = userText:split(".");
          if not isUserTextInvalid then

            for index, priority in splitPriority do

              -- Make sure everyone's a number
              if not tonumber(priority) then

                warn("[Dialogue Maker] " .. userText .. " is not a valid priority. Make sure you're not using any characters other than numbers and periods.");
                isUserTextInvalid = true;
                break;

              end;

              -- Make sure the folder exists
              local TargetDirectory = currentDirectory:FindFirstChild(priority);
              if not TargetDirectory and index ~= #splitPriority then

                warn("[Dialogue Maker] " .. userText .. " is not a valid priority. Make sure all parent directories exist.");
                isUserTextInvalid = true;
                break;

              elseif index == #splitPriority then

                if TargetDirectory then

                  warn("[Dialogue Maker] " .. userText .. " is not a valid priority. Make sure that " .. userText .. " isn't already being used.");
                  isUserTextInvalid = true;

                else
                  
                  local UserSplitPriority = userText:split(".");
                  props.contentScript.Name = UserSplitPriority[#UserSplitPriority];
                  contentScript.Parent = currentDirectory;

                end;
                break;

              end;

              currentDirectory = currentDirectory:FindFirstChild(priority) :: ModuleScript;

            end;

          end;

          if isUserTextInvalid then

            -- Reset the text.
            self.Text = props.priority;

          end;

        end;
      });
      DialogueTypeDropdown = React.createElement(Dropdown, {
        layoutOrder = 2;
        size = UDim2.new(0, 0, 1, 0);
        text = props.type;
        isDisabled = isDeleteModeEnabled;
        toggleButtonChildren = {
          UIFlexItem = React.createElement("UIFlexItem", {
            FlexMode = Enum.UIFlexMode.Fill;
          });
        };
        isOpen = isDialogueTypeDropdownOpen;
        setIsOpen = setIsDialogueTypeDropdownOpen;
      }, {
        MessageButton = React.createElement(DropdownOption, {
          onClick = function()

            props.contentScript:SetAttribute("DialogueType", "Message");
            setIsDialogueTypeDropdownOpen(false);

          end;
          layoutOrder = 1;
          text = "Message";
          iconImage = "rbxassetid://14099768265";
        });
        RedirectButton = React.createElement(DropdownOption, {
          onClick = function()

            props.contentScript:SetAttribute("DialogueType", "Redirect");
            setIsDialogueTypeDropdownOpen(false);

          end;
          layoutOrder = 2;
          text = "Redirect";
          iconImage = "rbxassetid://14099768484";
        });
        ResponseButton = React.createElement(DropdownOption, {
          onClick = function()

            props.contentScript:SetAttribute("DialogueType", "Response");
            setIsDialogueTypeDropdownOpen(false);

          end;
          layoutOrder = 1;
          text = "Response";
          iconImage = "rbxassetid://14099769224";
        });
      });
      ConnectionsDropDown = React.createElement(Dropdown, {
        text = "View";
        layoutOrder = 3;
        size = UDim2.new(0, 90, 1, 0);
        isDisabled = isDeleteModeEnabled;
        isOpen = isConnectionsDropdownOpen;
        setIsOpen = setIsConnectionsDropdownOpen;
      }, {
        ViewContentButton = React.createElement(DropdownOption, {
          layoutOrder = 1;
          text = "Content";
          onClick = function()
  
            props.plugin:OpenScript(props.contentScript);
            setIsConnectionsDropdownOpen(false);
  
          end;
        });
        ViewChildrenButton = if isRedirect then nil else React.createElement(DropdownOption, {
          layoutOrder = 2;
          text = "Children";
          onClick = function()
  
            props.setDialogueParent(props.contentScript);
            setIsConnectionsDropdownOpen(false);
  
          end;
        });
        ConditionButton = React.createElement(DropdownOption, {
          layoutOrder = 3;
          text = "Condition";
          onClick = function()

            openSpecialScript("Condition");
            setIsConnectionsDropdownOpen(false);

          end;
        }, {});
        ActionButton = if isRedirect or isResponse then nil else React.createElement(DropdownOption, {
          layoutOrder = 4;
          text = "Action";
          onClick = function()

            openSpecialScript("Action");
            setIsConnectionsDropdownOpen(false);

          end;
        }, {});
      });
    });
  })

end;

return DialogueItem;