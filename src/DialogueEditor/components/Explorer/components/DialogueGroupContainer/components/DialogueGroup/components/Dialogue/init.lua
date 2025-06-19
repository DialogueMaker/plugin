--!strict

local Selection = game:GetService("Selection");

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);
local useStudioIcons = require(root.DialogueEditor.hooks.useStudioIcons);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);

export type DialogueItemType = "Conversation" | "Response" | "Message" | "Redirect";

export type DialogueItemProperties = {
  type: DialogueItemType;
  dialogueScript: ModuleScript;
  dialogueScriptCount: number;
  layoutOrder: number;
  plugin: Plugin;
  setSettingsTarget: (target: ModuleScript?) -> ();
}

local function DialogueItem(props: DialogueItemProperties)

  local dialogueType = props.type;
  local dialogueScript = props.dialogueScript;
  local dialogueScriptCount = props.dialogueScriptCount;
  local layoutOrder = props.layoutOrder;

  local icons = useStudioIcons();
  local colors = useStudioColors();
  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();

  local dialogueContent = dialogueScript:GetAttribute("DialogueContent");

  local incrementPriority = React.useCallback(function(increment: number)
    
    if not dialogueScript.Parent then
          
      return;

    end;

    local children = dialogueScript.Parent:GetChildren();

    table.sort(children, function(dialogueScriptA, dialogueScriptB)
    
      local messageAPriority = tonumber(dialogueScriptA.Name) or math.huge;
      local messageBPriority = tonumber(dialogueScriptB.Name) or math.huge;
      
      return messageAPriority < messageBPriority;

    end);

    local index = table.find(children, dialogueScript);

    if not index or index + increment < 1 or index + increment > dialogueScriptCount then
      
      return;

    end;

    local historyIdentifier = beginHistoryRecording("Change dialogue script priority");

    table.remove(children, index);
    table.insert(children, index + increment, dialogueScript);

    for newIndex, child in children do

      if not child:IsA("ModuleScript") or not child:HasTag("DialogueMakerDialogueScript") then

        continue;

      end;
      
      child.Name = tostring(newIndex);

    end;

    finishHistoryRecording(historyIdentifier);

  end, {dialogueType :: unknown, dialogueScript, dialogueScriptCount});

  local isDeprioritized = (dialogueType == "Message" or dialogueType == "Redirect") and layoutOrder > 1;

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.Y;
    BackgroundTransparency = 1;
    Size = UDim2.fromScale(1, 0);
    LayoutOrder = layoutOrder;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 5);
      FillDirection = Enum.FillDirection.Horizontal;
      VerticalAlignment = Enum.VerticalAlignment.Center;
    });
    IncreasePriorityButton = if dialogueType ~= "Conversation" then
      React.createElement("ImageButton", {
        BackgroundTransparency = 1;
        Size = UDim2.fromOffset(20, 20);
        Image = icons.increasePriority;
        ImageTransparency = if layoutOrder <= 1 then 0.5 else 0;
        LayoutOrder = 1;
        [React.Event.Activated] = function()
          
          if layoutOrder <= 1 then
            
            return;

          end;

          incrementPriority(-1);

        end;
      })
    else nil;
    DecreasePriorityButton = if dialogueType ~= "Conversation" then
      React.createElement("ImageButton", {
        BackgroundTransparency = 1;
        Size = UDim2.fromOffset(20, 20);
        Image = icons.decreasePriority;
        ImageTransparency = if layoutOrder >= dialogueScriptCount then 0.5 else 0;
        LayoutOrder = 2;
        [React.Event.Activated] = function()
          
          if layoutOrder >= dialogueScriptCount then
            
            return;

          end;

          incrementPriority(1);

        end;
      })
    else nil;
    ViewButton = React.createElement("TextButton", {
      BackgroundColor3 = colors.toolbar;
      BorderSizePixel = 0;
      AutomaticSize = Enum.AutomaticSize.Y;
      Text = "";
      LayoutOrder = 3;
      [React.Event.Activated] = function()
        
        Selection:Set({dialogueScript});

      end;
    }, {
      UIFlexItem = React.createElement("UIFlexItem", {
        FlexMode = Enum.UIFlexMode.Fill;
      });
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Horizontal;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween;
        Padding = UDim.new(0, 5);
      });
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(0, 5);
      });
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 15);
        PaddingRight = UDim.new(0, 15);
        PaddingTop = UDim.new(0, 15);
        PaddingBottom = UDim.new(0, 15);
      });
      Information = React.createElement("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY;
        LayoutOrder = 1;
        BackgroundTransparency = 1;
      }, {
        UIListLayout = React.createElement("UIListLayout", {
          SortOrder = Enum.SortOrder.LayoutOrder;
          FillDirection = Enum.FillDirection.Horizontal;
          Padding = UDim.new(0, 10);
          VerticalAlignment = Enum.VerticalAlignment.Center;
        });
        UIFlexItem = React.createElement("UIFlexItem", {
          FlexMode = Enum.UIFlexMode.Fill;
        });
        Icon = React.createElement("ImageLabel", {
          LayoutOrder = 1;
          Image = icons[`{dialogueType:sub(1, 1):lower()}{dialogueType:sub(2)}`];
          Size = UDim2.fromOffset(20, 20);
          BackgroundTransparency = 1;
          ImageColor3 = colors.text;
          ImageTransparency = if isDeprioritized then 0.5 else 0;
        });
        Description = React.createElement("TextLabel", {
          Text = if dialogueType == "Conversation" then dialogueScript.Name else (dialogueContent or "Nothing yet...");
          TextColor3 = colors.text;
          TextTransparency = if not isDeprioritized and (dialogueType == "Conversation" or dialogueContent) then 0 else 0.5;
          LayoutOrder = 2;
          AutomaticSize = Enum.AutomaticSize.XY;
          FontFace = Font.fromId(11702779517);
          BackgroundTransparency = 1;
          TextSize = 14;
          TextXAlignment = Enum.TextXAlignment.Left;
          TextTruncate = Enum.TextTruncate.AtEnd;
        });
      });
      Indicator = React.createElement("ImageLabel", {
        LayoutOrder = 2;
        Image = "rbxassetid://136533602473973";
        Size = UDim2.fromOffset(20, 20);
        BackgroundTransparency = 1;
      }, {
        UIFlexItem = React.createElement("UIFlexItem", {
          FlexMode = Enum.UIFlexMode.Shrink;
        });
      })
    })
  });

end;

return React.memo(DialogueItem);