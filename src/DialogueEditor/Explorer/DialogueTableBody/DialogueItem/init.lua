--!strict

local ChangeHistoryService = game:GetService("ChangeHistoryService");
local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Dropdown = require(script.Dropdown);
local DropdownOption = require(script.DropdownOption);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type DialogueItemType = "Conversation" | "Response" | "Message" | "Redirect";

export type DialogueItemProperties = {
  type: DialogueItemType;
  contentScript: ModuleScript;
  layoutOrder: number;
  zIndex: number;
  dialogueParent: ModuleScript;
  plugin: Plugin;
  setSettingsTarget: (target: ModuleScript?) -> ();
}

local function DialogueItem(props: DialogueItemProperties)

  local contentScript = props.contentScript;
  local setSettingsTarget = props.setSettingsTarget;

  local colors = useStudioColors();

  local isDialogueTypeDropdownOpen, setIsDialogueTypeDropdownOpen = React.useState(false);
  local isConnectionsDropdownOpen, setIsConnectionsDropdownOpen = React.useState(false);

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
      Text = if props.type == "Conversation" then "" else props.contentScript.Name;
      PlaceholderText = if props.type == "Conversation" then "--" else props.contentScript.Name;
      TextColor3 = colors.text;
      PlaceholderColor3 = colors.textPlaceholder;
      LayoutOrder = 1;
      Size = UDim2.new(0, 60, 1, 0);
      FontFace = Font.fromId(11702779517);
      BackgroundTransparency = 1;
      TextSize = 14;
      Interactable = props.type ~= "Conversation";
      [React.Event.FocusLost] = function(self)

        local newPriority = tonumber(self.Text);
        assert(newPriority, "[Dialogue Maker] Invalid priority. Must be a number.");
        
        props.contentScript.Name = self.Text;

      end;
    });
    LabelTextBox = React.createElement("TextBox", {
      Text = contentScript:GetAttribute("DialogueContent") or "";
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
        
        contentScript:SetAttribute("DialogueContent", self.Text);

      end;
    });
    DialogueTypeDropdown = React.createElement(Dropdown, {
      layoutOrder = 3;
      size = UDim2.new(0, 0, 1, 0);
      text = props.type :: string;
      iconImage = `rbxassetid://{if props.type == "Message" or props.type == "Conversation" then "14099768265" elseif props.type == "Response" then "14099769224" else "14099768484"}`;
      toggleButtonChildren = {
        UIFlexItem = React.createElement("UIFlexItem", {
          FlexMode = Enum.UIFlexMode.Fill;
        });
      };
      isOpen = isDialogueTypeDropdownOpen;
      setIsOpen = setIsDialogueTypeDropdownOpen;
      isDisabled = props.type == "Conversation";
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
      ViewChildrenButton = if props.type == "Redirect" then nil else React.createElement(DropdownOption, {
        layoutOrder = 1;
        text = "View children";
        onClick = function()

          Selection:Set({props.contentScript});
          setIsConnectionsDropdownOpen(false);

        end;
      });
      SettingsButton = React.createElement(DropdownOption, {
        layoutOrder = 2;
        text = "Settings";
        onClick = function()

          setSettingsTarget(contentScript);

        end;
      });
      EditScriptButton = React.createElement(DropdownOption, {
        layoutOrder = 3;
        text = `{if props.contentScript:HasTag("ManuallyManaged") then "Enable" else "Disable"} automatic management`;
        onClick = function()

          if props.contentScript:HasTag("ManuallyManaged") then

            props.contentScript:RemoveTag("ManuallyManaged");

          else

            props.contentScript:AddTag("ManuallyManaged");

          end;

        end;
      });
      DeleteButton = React.createElement(DropdownOption, {
        layoutOrder = 4;
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

return React.memo(DialogueItem);