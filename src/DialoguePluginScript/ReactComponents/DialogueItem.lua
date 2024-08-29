--!strict
local React = require(script.Parent.Parent.Packages.react);
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
    BackgroundColor3 = if isResponse then Color3.fromRGB(30, 103, 19) else Color3.fromRGB(21, 44, 126);
    BackgroundTransparency = if isResponse or isRedirect then 0.4 else 1;
    BorderSizePixel = 0;
    ZIndex = props.zIndex;
    LayoutOrder = props.layoutOrder;
  }, {
    UIListLayout = React.createElement("UIListLayout");
    DeletionConfirmationFrame = if showDeletionConfirmation then React.createElement("Frame", {

    }, {
      UIListLayout = React.createElement("UIListLayout", {});
      QuestionTextLabel = React.createElement("TextLabel", {
        Text = "Delete?";
      });
      ConfirmButton = React.createElement("TextButton", {
        [React.Event.Activated] = function()

          contentScript:Destroy();
          setShowDeletionConfirmation(false);

        end;
      });
      CancelButton = React.createElement("TextButton", {
        [React.Event.Activated] = function()

          setShowDeletionConfirmation(false);

        end;
      });
    }) else nil;
    Content = React.createElement("Frame", {

    }, {
      UIListLayout = React.createElement("UIListLayout", {});
      DialogueTypeDropdown = React.createElement(Dropdown, {

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
      PriorityTextBox = React.createElement("TextBox", {
        Text = props.priority;
        PlaceholderText = props.priority;
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

        end;
      });
      ViewChildrenButton = if isRedirect then nil else React.createElement("TextButton", {
        [React.Event.Activated] = function()

          if isDeleteModeEnabled then

            setShowDeletionConfirmation(true);

          else

            props.setDialogueParent(props.contentScript);

          end;

        end;
      }, {});
      ViewContentButton = React.createElement("TextButton", {

        plugin:OpenScript(props.contentScript);

      });
    });
  })

end;

return DialogueItem;