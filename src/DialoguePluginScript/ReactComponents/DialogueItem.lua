--!strict
local React = require(script.Parent.Parent.Packages.react);
local Colors = require(script.Parent.Parent.Colors);
local Dropdown = require(script.Parent.Dropdown);

export type DialogueItemProperties = {
  type: "Response" | "Message" | "Redirect";
  contentScript: ModuleScript;
  setDialogueParent: (ModuleScript | Folder) -> ();
  isDeleteModeEnabled: boolean;
  layoutOrder: number;
  zIndex: number;
  priority: string;
  dialogueContainer: Folder;
}

local function DialogueItem(props: DialogueItemProperties)

  local showDeletionConfirmation, setShowDeletionConfirmation = React.useState(false);
  local isDeleteModeEnabled = props.isDeleteModeEnabled;
  local dialogueContainer = props.dialogueContainer;
  local contentScript = props.contentScript;

  local function openSpecialScript(scriptType: "Action" | "Condition"): ()

    -- Create a special script if necessary.
    local specialScript = contentScript:FindFirstChild(scriptType) :: ModuleScript?;

    if not specialScript then

      local newSpecialScript = script.Parent.Parent.Templates[`{scriptType}Template`]:Clone();
      newSpecialScript.Parent = contentScript;
      specialScript = newSpecialScript;

    end;

    -- Open the condition script
    plugin:OpenScript(specialScript :: ModuleScript);

  end;

  local isResponse = props.type == "Response";
  local isRedirect = props.type == "Redirect";
  
  return React.createElement("Frame", {
    BackgroundColor3 = if isResponse then Colors.backgroundResponse else Colors.backgroundRedirect;
    BackgroundTransparency = if isResponse or isRedirect then 0.4 else 1;
    BorderSizePixel = 0;
    ZIndex = props.zIndex;
    LayoutOrder = props.layoutOrder;
    Size = UDim2.new(1, 0, 0, 22);
  }, {
    DeletionConfirmationFrame = if showDeletionConfirmation then React.createElement("Frame", {
      ZIndex = 2;
      Visible = showDeletionConfirmation;
      Size = UDim2.new(1, 0, 1, 0);
      BackgroundTransparency = 0.5;
      BackgroundColor3 = Colors.backgroundDeletionFrame;
      BorderSizePixel = 0;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      QuestionTextLabel = React.createElement("TextLabel", {
        BackgroundTransparency = 1;
        LayoutOrder = 1;
        Text = "Delete?";
        TextColor3 = Colors.text;
        FontFace = Font.fromId(0, Enum.FontWeight.Bold);
      });
      ConfirmButton = React.createElement("TextButton", {
        LayoutOrder = 2;
        BackgroundColor3 = Colors.backgroundWarning;
        Text = "Yes";
        BorderSizePixel = 0;
        [React.Event.Activated] = function()

          contentScript:Destroy();
          setShowDeletionConfirmation(false);

        end;
      });
      CancelButton = React.createElement("TextButton", {
        BackgroundTransparency = 1;
        LayoutOrder = 3;
        Text = "No";
        BorderSizePixel = 0;
        [React.Event.Activated] = function()

          setShowDeletionConfirmation(false);

        end;
      });
    }) else nil;
    Content = React.createElement("Frame", {
      ZIndex = 1;
      BackgroundTransparency = 1;
      Size = UDim2.new(1, 0, 1, 0);
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
      });
      PriorityTextBox = React.createElement("TextBox", {
        Text = props.priority;
        PlaceholderText = props.priority;
        TextColor3 = Colors.text;
        PlaceholderColor3 = Colors.textPlaceholder;
        LayoutOrder = 1;
        BackgroundTransparency = 1;
        [React.Event.FocusLost] = function(self)

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
      }, {
        MessageButton = React.createElement("TextButton", {
          LayoutOrder = 1;
          [React.Event.Activated] = function()

            props.contentScript:SetAttribute("DialogueType", "Message");

          end;
        }, {});
        RedirectButton = React.createElement("TextButton", {
          LayoutOrder = 2;
          [React.Event.Activated] = function()

            props.contentScript:SetAttribute("DialogueType", "Redirect");

          end;
        }, {});
        ResponseButton = React.createElement("TextButton", {
          LayoutOrder = 3;
          [React.Event.Activated] = function()

            props.contentScript:SetAttribute("DialogueType", "Response");

          end;
        }, {});
      });
      OpenScriptsDropdown = React.createElement(Dropdown, {
        layoutOrder = 3;
      }, {
        ActionButton = if isRedirect or isResponse then nil else React.createElement("TextButton", {
          LayoutOrder = 1;
          [React.Event.Activated] = function()

            openSpecialScript("Action");

          end;
        }, {});
        ConditionButton = React.createElement("TextButton", {
          LayoutOrder = 2;
          [React.Event.Activated] = function()

            openSpecialScript("Condition");

          end;
        }, {});
      });
      ViewChildrenButton = if isRedirect then nil else React.createElement("TextButton", {
        LayoutOrder = 4;
        Text = "View";
        BackgroundTransparency = 1;
        FontFace = Font.fromId(11702779517, Enum.FontWeight.Regular);
        TextColor3 = Colors.text;
        [React.Event.Activated] = function()

          if isDeleteModeEnabled then

            setShowDeletionConfirmation(true);

          else

            props.setDialogueParent(props.contentScript);

          end;

        end;
      });
      ViewContentButton = React.createElement("TextButton", {
        LayoutOrder = 5;
        Text = "View";
        TextColor3 = Colors.text;
        FontFace = Font.fromId(11702779517, Enum.FontWeight.Regular);
        [React.Event.Activated] = function()

          plugin:OpenScript(props.contentScript);

        end;
      });
    });
  })

end;

return DialogueItem;