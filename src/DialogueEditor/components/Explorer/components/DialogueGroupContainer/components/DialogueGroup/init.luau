--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local DialogueItem = require(script.components.DialogueItem);

export type DialogueItemType = DialogueItem.DialogueItemType;

export type DialogueGroupProperties = {
  name: DialogueItemType;
  plugin: Plugin;
  dialogueScripts: {ModuleScript};
  layoutOrder: number;
}

local function DialogueGroup(properties: DialogueGroupProperties)

  local groupName = properties.name;
  local dialogueScripts = properties.dialogueScripts;
  local layoutOrder = properties.layoutOrder;
  local plugin = properties.plugin;

  local scriptComponents = {};
  for index, dialogueScript in dialogueScripts do

    local settingComponent = React.createElement(DialogueItem, {
      key = dialogueScript:GetFullName();
      plugin = plugin;
      dialogueScript = dialogueScript;
      dialogueScriptCount = #dialogueScripts;
      layoutOrder = index;
      type = groupName :: DialogueItemType;
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

return React.memo(DialogueGroup);