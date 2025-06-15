--!strict

local root = script.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Dialogue = require(script.Dialogue);

export type DialogueItemType = Dialogue.DialogueItemType;

export type DialogueGroupProperties = {
  name: DialogueItemType;
  plugin: Plugin;
  scriptList: {ModuleScript};
  layoutOrder: number;
  setSettingsTarget: (target: ModuleScript?) -> ();
}

local function SettingGroup(properties: DialogueGroupProperties)

  local groupName = properties.name;
  local scriptList = properties.scriptList;
  local layoutOrder = properties.layoutOrder;
  local setSettingsTarget = properties.setSettingsTarget;

  local scriptComponents = {};
  for index, dialogueScript in scriptList do

    local settingComponent = React.createElement(Dialogue, {
      key = dialogueScript:GetFullName();
      plugin = properties.plugin;
      dialogueScript = dialogueScript;
      layoutOrder = index;
      type = groupName :: DialogueItemType;
      setSettingsTarget = setSettingsTarget;
    });

    table.insert(scriptComponents, settingComponent);

  end;

  return React.createElement("Frame", {
    AutomaticSize = Enum.AutomaticSize.Y;
    BackgroundTransparency = 1;
    LayoutOrder = layoutOrder;
    Size = UDim2.fromScale(1, 0);
  }, {
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 10);
    });
    ScriptList = React.createElement(React.Fragment, {}, scriptComponents);
  });

end;

return React.memo(SettingGroup);