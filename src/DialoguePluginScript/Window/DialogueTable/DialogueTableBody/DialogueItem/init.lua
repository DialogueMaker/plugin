--!strict
local ChangeHistoryService = game:GetService("ChangeHistoryService");
local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent.Parent;
local React = require(root.Packages.react);
local Dropdown = require(script.Dropdown);
local useDialogueContainer = require(script.useDialogueContainer);
local DropdownOption = require(script.DropdownOption);
local useStudioColors = require(root.useStudioColors);

export type DialogueItemProperties = {
  type: "Response" | "Message" | "Redirect";
  contentScript: ModuleScript;
  layoutOrder: number;
  zIndex: number;
  dialogueParent: ModuleScript | Folder;
  plugin: Plugin;
}

local function DialogueItem(props: DialogueItemProperties)

  local colors = useStudioColors();

  local isDialogueTypeDropdownOpen, setIsDialogueTypeDropdownOpen = React.useState(false);
  local isConnectionsDropdownOpen, setIsConnectionsDropdownOpen = React.useState(false);
  local dialogueContainer = useDialogueContainer(props.dialogueParent);
  local contentScript = props.contentScript;

  local isResponse = props.type == "Response";
  local isRedirect = props.type == "Redirect";

  local labelName, setLabelName = React.useState(contentScript:GetAttribute("Label") or "");
  React.useEffect(function()

    local changedSignal = contentScript:GetAttributeChangedSignal("Label"):Connect(function()

      setLabelName(contentScript:GetAttribute("Label") or "");

    end);

    return function()

      changedSignal:Disconnect();

    end;

  end, {contentScript});

  return React.createElement("Frame", {
    BackgroundColor3 = if isResponse then colors.backgroundResponse else colors.backgroundRedirect;
    BackgroundTransparency = if isResponse or isRedirect then 0.4 else 1;
    BorderSizePixel = 0;
    ZIndex = props.zIndex;
    LayoutOrder = props.layoutOrder;
    Size = UDim2.new(1, 0, 0, 25);
  }, {
    UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        Padding = UDim.new(0, 3);
    });
    PriorityTextBox = React.createElement("TextBox", {
      Text = props.contentScript.Name;
      PlaceholderText = props.contentScript.Name;
      TextColor3 = colors.text;
      PlaceholderColor3 = colors.textPlaceholder;
      LayoutOrder = 1;
      Size = UDim2.new(0, 60, 1, 0);
      FontFace = Font.fromId(11702779517);
      BackgroundTransparency = 1;
      TextSize = 14;
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
          self.Text = props.contentScript.Name;

        end;

      end;
    });
    LabelTextBox = React.createElement("TextBox", {
      Text = labelName;
      PlaceholderText = "Unlabeled";
      TextColor3 = colors.text;
      PlaceholderColor3 = colors.textPlaceholder;
      LayoutOrder = 2;
      Size = UDim2.new(0, 100, 1, 0);
      FontFace = Font.fromId(11702779517);
      BackgroundTransparency = 1;
      TextSize = 14;
      TextXAlignment = Enum.TextXAlignment.Left;
      ClearTextOnFocus = false;
      [React.Change.Text] = function(self)
        
        contentScript:SetAttribute("Label", if self.Text == "" then nil else self.Text);

      end;
    });
    DialogueTypeDropdown = React.createElement(Dropdown, {
      layoutOrder = 3;
      size = UDim2.new(0, 0, 1, 0);
      text = props.type;
      toggleButtonChildren = {
        UIFlexItem = React.createElement("UIFlexItem", {
          FlexMode = Enum.UIFlexMode.Fill;
        });
      };
      isOpen = isDialogueTypeDropdownOpen;
      setIsOpen = setIsDialogueTypeDropdownOpen;
    }, {
      RedirectButton = React.createElement(DropdownOption, {
        onClick = function()

          local identifier = ChangeHistoryService:TryBeginRecording("Convert dialogue item to redirect");
          if ChangeHistoryService:IsRecordingInProgress(identifier) then

            ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);
            identifier = ChangeHistoryService:TryBeginRecording("Convert dialogue item to redirect");
            assert(identifier, "[Dialogue Maker] ChangeHistoryService failed to begin recording.");

          end;

          contentScript:SetAttribute("DialogueType", "Redirect");

          if not contentScript:FindFirstChild("Redirect") then

            local redirect = Instance.new("ObjectValue");
            redirect.Name = "Redirect";
            redirect.Parent = contentScript;

          end;

          ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit);

          setIsDialogueTypeDropdownOpen(false);

        end;
        layoutOrder = 1;
        text = "Redirect";
        iconImage = "rbxassetid://14099768484";
      });
      ResponseButton = React.createElement(DropdownOption, {
        onClick = function()

          local identifier = ChangeHistoryService:TryBeginRecording("Convert dialogue item to response");
          if ChangeHistoryService:IsRecordingInProgress(identifier) then

            ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);
            identifier = ChangeHistoryService:TryBeginRecording("Convert dialogue item to response");
            assert(identifier, "[Dialogue Maker] ChangeHistoryService failed to begin recording.");

          end;

          local redirect = contentScript:FindFirstChild("Redirect");
          if redirect then

            redirect.Parent = nil;

          end;

          contentScript:SetAttribute("DialogueType", "Response");
          ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit);
          setIsDialogueTypeDropdownOpen(false);

        end;
        layoutOrder = 2;
        text = "Response";
        iconImage = "rbxassetid://14099769224";
      });
      MessageButton = React.createElement(DropdownOption, {
        onClick = function()

          local identifier = ChangeHistoryService:TryBeginRecording("Convert dialogue item to message");
          if ChangeHistoryService:IsRecordingInProgress(identifier) then

            ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);
            identifier = ChangeHistoryService:TryBeginRecording("Convert dialogue item to message");
            assert(identifier, "[Dialogue Maker] ChangeHistoryService failed to begin recording.");

          end;

          local redirect = contentScript:FindFirstChild("Redirect");
          if redirect then

            redirect.Parent = nil;

          end;

          contentScript:SetAttribute("DialogueType", "Message");
          ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit);
          setIsDialogueTypeDropdownOpen(false);

        end;
        layoutOrder = 3;
        text = "Message";
        iconImage = "rbxassetid://14099768265";
      });
    });
    OptionsDropDown = React.createElement(Dropdown, {
      text = "Options";
      layoutOrder = 4;
      size = UDim2.new(0, 120, 1, 0);
      isOpen = isConnectionsDropdownOpen;
      setIsOpen = setIsConnectionsDropdownOpen;
    }, {
      ConfigureButton = React.createElement(DropdownOption, {
        layoutOrder = 1;
        text = "Configure";
        onClick = function()

          props.plugin:OpenScript(props.contentScript);
          setIsConnectionsDropdownOpen(false);

        end;
      });
      ViewChildrenButton = if isRedirect then nil else React.createElement(DropdownOption, {
        layoutOrder = 2;
        text = "View children";
        onClick = function()

          Selection:Set({props.contentScript});
          setIsConnectionsDropdownOpen(false);

        end;
      });
      DeleteButton = React.createElement(DropdownOption, {
        layoutOrder = 3;
        text = "Delete";
        onClick = function()

          local identifier = ChangeHistoryService:TryBeginRecording("Delete dialogue item");
          if ChangeHistoryService:IsRecordingInProgress(identifier) then

            ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);
            identifier = ChangeHistoryService:TryBeginRecording("Delete dialogue item");
            assert(identifier, "[Dialogue Maker] ChangeHistoryService failed to begin recording.");

          end;

          props.contentScript.Parent = nil;

          ChangeHistoryService:FinishRecording(identifier, Enum.FinishRecordingOperation.Commit);

        end;
      });
    });
  })

end;

return DialogueItem;