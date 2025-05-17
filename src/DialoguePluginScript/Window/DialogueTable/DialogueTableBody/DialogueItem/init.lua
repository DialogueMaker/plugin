--!strict
local ChangeHistoryService = game:GetService("ChangeHistoryService");
local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent.Parent;
local React = require(root.Packages.react);
local Dropdown = require(script.Dropdown);
local DropdownOption = require(script.DropdownOption);
local useStudioColors = require(root.useStudioColors);

export type DialogueItemProperties = {
  type: "Response" | "Message" | "Redirect";
  contentScript: ModuleScript;
  layoutOrder: number;
  zIndex: number;
  dialogueParent: ModuleScript;
  plugin: Plugin;
}

local function DialogueItem(props: DialogueItemProperties)

  local colors = useStudioColors();

  local isDialogueTypeDropdownOpen, setIsDialogueTypeDropdownOpen = React.useState(false);
  local isConnectionsDropdownOpen, setIsConnectionsDropdownOpen = React.useState(false);
  local contentScript = props.contentScript;

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
    BackgroundTransparency = 1;
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

        local newPriority = tonumber(self.Text);
        assert(newPriority, "[Dialogue Maker] Invalid priority. Must be a number.");
        
        props.contentScript.Name = self.Text;

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
      text = props.type :: string;
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
      ViewChildrenButton = if props.type == "Redirect" then nil else React.createElement(DropdownOption, {
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