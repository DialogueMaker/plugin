--!strict

local CollectionService = game:GetService("CollectionService");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local useStudioColors = require(root.DialogueEditor.hooks.useStudioColors);

export type SettingTypeSelectorProperties = {
  settingsTarget: ModuleScript;
};

local function SettingTypeSelector(properties: SettingTypeSelectorProperties)

  local settingsTarget = properties.settingsTarget;

  local colors = useStudioColors();
  local settingsTargetType = (
    if settingsTarget:HasTag("DialogueMakerLoader") then "Client"
    elseif settingsTarget:HasTag("DialogueMakerConversationScript") then "Conversation"
    elseif settingsTarget:HasTag("DialogueMakerDialogueScript") then "Dialogue"
    else error(`Invalid settings target provided: {settingsTarget.Name}. Expected a DialogueMaker script.`)
  );

  local loaderScripts = CollectionService:GetTagged("DialogueMakerLoader");
  local loaderScript = nil;
  for _, possibleLoaderScript in loaderScripts do
    
    if not possibleLoaderScript:IsDescendantOf(root) then
      
      loaderScript = possibleLoaderScript;
      break;
    
    end

  end

  local settingTypeComponents = {};
  local settingTypes = {"Client", "Conversation", "Dialogue"};
  for index, settingType in settingTypes do

    local settingTypeComponent = React.createElement("TextButton", {
      AutomaticSize = Enum.AutomaticSize.XY;
      BackgroundColor3 = if settingType == settingsTargetType then colors.primaryButton else colors.toolbar;
      Text = settingType;
      TextColor3 = colors.text;
      TextTransparency = if settingType == "Client" and not loaderScript then 0.5 else 0;
      AutoButtonColor = if settingType == "Client" and not loaderScript then false else true;
      TextSize = 12;
      FontFace = Font.fromName("BuilderSans", Enum.FontWeight.Regular);
      LayoutOrder = index;
      [React.Event.Activated] = function()

      end;
    }, {
      UIPadding = React.createElement("UIPadding", {
        PaddingLeft = UDim.new(0, 10);
        PaddingRight = UDim.new(0, 10);
        PaddingTop = UDim.new(0, 5);
        PaddingBottom = UDim.new(0, 5);
      });
      UICorner = React.createElement("UICorner", {
        CornerRadius = UDim.new(1, 0);
      });
    });

    table.insert(settingTypeComponents, settingTypeComponent);

  end;

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.XY;
    BackgroundTransparency = 1;
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 10);
      FillDirection = Enum.FillDirection.Horizontal;
    });
    SettingTypeList = React.createElement(React.Fragment, {}, settingTypeComponents);
  });

end;

return React.memo(SettingTypeSelector);