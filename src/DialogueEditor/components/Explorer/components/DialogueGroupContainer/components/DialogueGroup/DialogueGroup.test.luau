--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local DialogueGroup = require(script.Parent);
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
  describe("DialogueGroup", function()

    local function MockComponent(properties: any)

      local dialogueType = properties.type or "Message";
      local onRendered = properties.onRendered;
      local dialogueScripts = properties.dialogueScripts or {};
      local layoutOrder = properties.layoutOrder or 1;

      React.useEffect(function()
      
        if onRendered then

          onRendered();

        end;

      end, {});

      return React.createElement(DialogueGroup, {
        name = dialogueType;
        plugin = VirtualService.globals.plugin;
        dialogueScripts = dialogueScripts;
        layoutOrder = layoutOrder;
      });

    end;

    return {

      it("creates a DialogueItem component for each child dialogue of the selected script", function()

        expect(function()

          -- Render the component and wait for it to finish rendering.
          assert(screenGui, "ScreenGui should be initialized before running tests.");
          assert(reactRoot, "React root should be initialized before running tests.");

          local renderedEvent = Instance.new("BindableEvent");
          local messages = {"This should be a message", "This should be another message", "This should be a third message", "This should be a fourth message"};
          local dialogueScripts = {};
          for _, message in messages do

            local dialogueScript = Instance.new("ModuleScript");
            dialogueScript.Name = tostring(#dialogueScripts + 1);
            dialogueScript:SetAttribute("DialogueContent", message);
            table.insert(dialogueScripts, dialogueScript);

          end;

          local element = React.createElement(MockComponent, {
            dialogueScripts = dialogueScripts;
            onRendered = function()
              
              renderedEvent:Fire();

            end;
          });

          reactRoot:render(element);
          renderedEvent.Event:Wait();

          -- Simulate a click on the component.
          local dialogueGroup = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueGroup, "DialogueGroup should be rendered in the ScreenGui.");

          local dialogueItems = {};
          for _, child in dialogueGroup:GetChildren() do

            if child:IsA("Frame") then
            
              table.insert(dialogueItems, child);

              local viewButton = child:FindFirstChild("ViewButton");
              assert(viewButton and viewButton:IsA("GuiButton"), "ViewButton should be present in the DialogueItem.");

              local informationFrame = viewButton:FindFirstChild("InformationFrame");
              assert(informationFrame, "Information should be present in the ViewButton.");

              local descriptionLabel = informationFrame:FindFirstChild("DescriptionLabel");
              assert(descriptionLabel and descriptionLabel:IsA("TextLabel"), "DescriptionLabel should be present in the InformationFrame.");

              local expectedMessage = messages[child.LayoutOrder];
              expect(descriptionLabel.Text).toBe(expectedMessage);
            
            end;

          end;

          expect(#dialogueItems).toBe(4);

        end).toFinishBeforeSeconds(1);

      end);
      
    }

  end, {
    beforeEach = function()

      local newScreenGui = Instance.new("ScreenGui");
      screenGui = newScreenGui;
      reactRoot = ReactRoblox.createRoot(newScreenGui);

    end;
    afterEach = function()

      if reactRoot then

        reactRoot:unmount();

      end;

      if screenGui then

        screenGui:Destroy();

      end;

    end;
  })
};