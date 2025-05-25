--!strict

local DialogueClientScript = script.Parent.Parent;
local IDialogue = require(DialogueClientScript.Interfaces.Dialogue);
local IEffect = require(DialogueClientScript.Interfaces.Effect);

type Dialogue = IDialogue.Dialogue;
type DialogueSettings = IDialogue.DialogueSettings;
type Effect = IEffect.Effect;
type Page = IEffect.Page;
type OptionalDialogueSettings = IDialogue.OptionalDialogueSettings;

export type ConstructorProperties = {
  getContent: (self: Dialogue) -> {Page};
  runAction: (self: Dialogue, actionID: number) -> ();
  verifyCondition: (self: Dialogue) -> boolean;
  settings: OptionalDialogueSettings?;
}

local Dialogue = {
  defaultSettings = {
    typewriter = {
      characterDelaySeconds = 0.025; 
      canPlayerSkipDelay = true;
      shouldShowResponseWhileTyping = false;
    };
    timeout = {	
      seconds = nil; 
      shouldWaitForResponse = true; 
    };
  } :: DialogueSettings;
};

--[[
  Creates a new dialogue object.
]]
function Dialogue.new(properties: ConstructorProperties, moduleScript: ModuleScript): Dialogue
  
  local settings: DialogueSettings = {
    typewriter = {
      characterDelaySeconds = if properties.settings and properties.settings.typewriter and properties.settings.typewriter.characterDelaySeconds ~= nil then properties.settings.typewriter.characterDelaySeconds else Dialogue.defaultSettings.typewriter.characterDelaySeconds; 
      canPlayerSkipDelay = if properties.settings and properties.settings.typewriter and properties.settings.typewriter.canPlayerSkipDelay ~= nil then properties.settings.typewriter.canPlayerSkipDelay else Dialogue.defaultSettings.typewriter.canPlayerSkipDelay; 
      shouldShowResponseWhileTyping = if properties.settings and properties.settings.typewriter and properties.settings.typewriter.shouldShowResponseWhileTyping ~= nil then properties.settings.typewriter.shouldShowResponseWhileTyping else Dialogue.defaultSettings.typewriter.shouldShowResponseWhileTyping;
    };
    timeout = {	
      seconds = if properties.settings and properties.settings.timeout and properties.settings.timeout.seconds ~= nil then properties.settings.timeout.seconds else Dialogue.defaultSettings.timeout.seconds; 
      shouldWaitForResponse = if properties.settings and properties.settings.timeout and properties.settings.timeout.shouldWaitForResponse ~= nil then properties.settings.timeout.shouldWaitForResponse else Dialogue.defaultSettings.timeout.shouldWaitForResponse; 
    };
  };

  local settingsChangedEvent = Instance.new("BindableEvent");

  local function getChildren(self: Dialogue): {Dialogue}

    local children: {Dialogue} = {};
    for _, possibleDialogue in moduleScript:GetChildren() do

      if possibleDialogue:IsA("ModuleScript") and tonumber(possibleDialogue.Name) then

        local response = require(possibleDialogue) :: Dialogue;
        table.insert(children, response);

      end

    end

    -- Sort responses because :GetChildren() doesn't guarantee it
    table.sort(children, function(dialogue1, dialogue2)

      return dialogue1.moduleScript.Name < dialogue2.moduleScript.Name;

    end);

    return children;

  end;

  local function getSettings(self: Dialogue): DialogueSettings

    return table.clone(settings);

  end;

  local function setSettings(self: Dialogue, newSettings: DialogueSettings): ()

    settings = newSettings;
    settingsChangedEvent:Fire();

  end;

  local type = moduleScript:GetAttribute("DialogueType");
  assert(type == "Message" or type == "Response" or type == "Redirect", "[Dialogue Maker] ModuleScript must have a DialogueType attribute set to either Message, Response, or Redirect.");

  local dialogue: Dialogue = {
    type = type;
    moduleScript = moduleScript;
    getContent = properties.getContent;
    getChildren = getChildren;
    getSettings = getSettings;
    runAction = properties.runAction;
    setSettings = setSettings;
    verifyCondition = properties.verifyCondition;
    SettingsChanged = settingsChangedEvent.Event;
  };

  if dialogue.type == "Redirect" then

    local redirectObjectValue = moduleScript:FindFirstChild("Redirect");
    assert(redirectObjectValue and redirectObjectValue:IsA("ObjectValue"), "[Dialogue Maker] Redirect object value not found.");

    local redirectModuleScript = redirectObjectValue.Value;
    assert(redirectModuleScript and redirectModuleScript:IsA("ModuleScript"), "[Dialogue Maker] Redirect object value is not a ModuleScript.");

    dialogue.redirectModuleScript = redirectModuleScript;

  end;

  return dialogue;

end;

return Dialogue;
