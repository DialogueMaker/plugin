--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent;
local DialogueGroupContainer = require(script.Parent);
local VirtualService = require(root.VirtualService);
local React = require(root.roblox_packages.react);
local ReactRoblox = require(root.roblox_packages["react-roblox"]);
local IJW = require(root.roblox_packages.ijw);
local expect = IJW.expect;
local describe = IJW.describe;
local it = IJW.it;

local screenGui: ScreenGui?;
local reactRoot: ReactRoblox.RootType?;

return {
  describe("DialogueGroupContainer", function()

    local function MockComponent(properties: any)

      local dialogueType = properties.type or "Message";
      local onRendered = properties.onRendered;
      local selectedScript = properties.selectedScript;

      React.useEffect(function()
      
        if onRendered then

          onRendered();

        end;

      end, {});

      return React.createElement(DialogueGroupContainer, {
        name = dialogueType;
        plugin = VirtualService.mocks.globals.plugin;
        selectedScript = selectedScript;
        layoutOrder = 1;
      });

    end;

    return {

      it("refreshes the selected dialogue group if a dialogue script is added to a dialogue folder", function()

        expect(function()

          -- Render the component and wait for it to finish rendering.
          assert(screenGui, "ScreenGui should be initialized before running tests.");
          assert(reactRoot, "React root should be initialized before running tests.");

          local renderedEvent = Instance.new("BindableEvent");
          local messageCount = 4;
          local dialogueFolder = Instance.new("Folder");
          dialogueFolder.Name = "Messages";

          for i = 1, messageCount do

            local dialogueScript = Instance.new("ModuleScript");
            dialogueScript.Name = tostring(i);
            dialogueScript:SetAttribute("DialogueType", "Message");
            dialogueScript:AddTag("DialogueMakerDialogueScript");
            dialogueScript.Parent = dialogueFolder;

          end;

          local selectedScript = Instance.new("ModuleScript");
          selectedScript:SetAttribute("DialogueType", "Message");
          selectedScript:AddTag("DialogueMakerDialogueScript");
          dialogueFolder.Parent = selectedScript;

          local element = React.createElement(MockComponent, {
            selectedScript = selectedScript;
            onRendered = function()
              
              renderedEvent:Fire();

            end;
          });

          reactRoot:render(element);
          renderedEvent.Event:Wait();

          -- Verify that there are four dialogue items rendered.
          local dialogueGroupContainer = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueGroupContainer, "DialogueGroupContainer should be rendered in the ScreenGui.");

          local dialogueGroup = dialogueGroupContainer:FindFirstChild("DialogueGroup");
          assert(dialogueGroup, "DialogueGroup should be rendered in the DialogueGroupContainer.");

          local function getDialogueItems()  

            local dialogueItems = {};
            for _, child in dialogueGroup:GetChildren() do

              if child:IsA("Frame") then
                
                table.insert(dialogueItems, child);
              
              end;

            end;

            return dialogueItems;

          end;

          expect(#getDialogueItems()).toBe(4);

          -- Add a new dialogue script to the folder and verify that the component refreshes.
          local newDialogueScript = Instance.new("ModuleScript");
          newDialogueScript.Name = tostring(messageCount + 1);
          newDialogueScript:SetAttribute("DialogueType", "Message");
          newDialogueScript:AddTag("DialogueMakerDialogueScript");
          newDialogueScript.Parent = dialogueFolder;
          dialogueGroup.ChildAdded:Wait();
          expect(#getDialogueItems()).toBe(5);

        end).toFinishBeforeSeconds(3);

      end);
      
    }

  end, {
    beforeEach = function()
      
      VirtualService.mocks.isEnabled = true;

      local newScreenGui = Instance.new("ScreenGui");
      screenGui = newScreenGui;
      reactRoot = ReactRoblox.createRoot(newScreenGui);

    end;
    afterEach = function()

      VirtualService.mocks.isEnabled = false;

      if reactRoot then

        reactRoot:unmount();

      end;

      if screenGui then

        screenGui:Destroy();

      end;

    end;
  })
};