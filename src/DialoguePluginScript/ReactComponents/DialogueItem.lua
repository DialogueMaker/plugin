--!strict
local React = require(script.Parent.Parent.Packages.react);
local Dropdown = require(script.Parent.Dropdown);
local StarterPlayerScripts = game:GetService("StarterPlayerScripts");

export type DialogueItemProperties = {
  type: "Response" | "Message" | "Redirect";
  contentScript: ModuleScript;
  setDialogueParent: (ModuleScript | Folder) -> ();
  isDeleteModeEnabled: boolean;
  layoutOrder: number;
  zIndex: number;
  priority: string;
}

local function DialogueItem(props: DialogueItemProperties)

  local showDeletionConfirmation, setShowDeletionConfirmation = React.useState(false);
  local isDeleteModeEnabled = props.isDeleteModeEnabled;
  local contentScript = props.contentScript;

  local function openSpecialScript(Folder: Folder, Template: ModuleScript): ()

    -- Search through the script list
    local specialScript;
    for _, possibleSpecialScript in Folder:GetChildren() do

      if possibleSpecialScript:IsA("ModuleScript") and (possibleSpecialScript:FindFirstChild("ContentScript") :: ObjectValue).Value == contentScript then

        specialScript = possibleSpecialScript;
        break;

      end;

    end;

    if not specialScript then

      local TempSpecialScript = Template:Clone();
      TempSpecialScript.Name = table.concat(splitPriority, ".");
      (TempSpecialScript:FindFirstChild("ContentScript") :: ObjectValue).Value = contentScript;
      TempSpecialScript.Parent = Folder;
      specialScript = TempSpecialScript;

    end;

    -- Open the condition script
    plugin:OpenScript(specialScript);

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

            openSpecialScript(StarterPlayerScripts.DialogueClientScript.Actions, script.ActionTemplate);

          end;
        }, {});
        ConditionButton = React.createElement("TextButton", {
          LayoutOrder = 2;
          [React.Event.Activated] = function()

            openSpecialScript(StarterPlayerScripts.DialogueClientScript.Conditions, script.ConditionTemplate);

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

          local CurrentDirectory = CurrentDialogueContainer;
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
              local TargetDirectory = CurrentDirectory:FindFirstChild(priority);
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
                  ContentScript.Parent = CurrentDirectory;

                end;
                break;

              end;

              CurrentDirectory = CurrentDirectory:FindFirstChild(priority) :: ModuleScript;

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