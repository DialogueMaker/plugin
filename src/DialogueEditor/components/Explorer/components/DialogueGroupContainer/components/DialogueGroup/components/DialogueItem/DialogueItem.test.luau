--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local DialogueItem = require(script.Parent);
local VirtualService = require(root.VirtualService);
local React = require(root.roblox_packages.react);
local ReactErrorBoundary = require(root.roblox_packages.ReactErrorBoundary);
local ErrorBoundary = ReactErrorBoundary.ErrorBoundary;
local ReactRoblox = require(root.roblox_packages["react-roblox"]);
local IJW = require(root.roblox_packages.ijw);
local expect = IJW.expect;
local describe = IJW.describe;
local it = IJW.it;

local screenGui: ScreenGui?;
local reactRoot: ReactRoblox.RootType?;

return {
  describe("DialogueItem", function()

    local function MockComponent(properties: any)

      local dialogueType = properties.type or "Message";
      local onRendered = properties.onRendered;
      local dialogueScript = properties.dialogueScript or Instance.new("ModuleScript");
      local layoutOrder = properties.layoutOrder or 1;
      local onErrored = properties.onErrored or function() end;

      React.useEffect(function()
      
        if onRendered then

          onRendered();

        end;

      end, {});

      return React.createElement(ErrorBoundary, {
        FallbackComponent = React.Fragment;
        onError = onErrored;
      }, {
        React.createElement(DialogueItem, {
          type = dialogueType;
          dialogueScript = dialogueScript;
          dialogueScriptCount = if dialogueScript.Parent then #dialogueScript.Parent:GetChildren() else 1;
          layoutOrder = layoutOrder;
          setSettingsTarget = function() end;
        })
      });

    end;

    local function generateDialogueContainer()

      local dialogueContainer = Instance.new("Folder");
      local dialogueScript = Instance.new("ModuleScript");
      dialogueScript.Name = "1";
      dialogueScript:AddTag("DialogueMakerDialogueScript");
      dialogueScript.Parent = dialogueContainer;

      local secondDialogueScript = Instance.new("ModuleScript");
      secondDialogueScript.Name = "2";
      secondDialogueScript:AddTag("DialogueMakerDialogueScript");
      secondDialogueScript.Parent = dialogueContainer;

      return dialogueContainer;

    end;

    return {

      it("can set selection on click", function()

        expect(function()

          -- Render the component and wait for it to finish rendering.
          assert(screenGui, "ScreenGui should be initialized before running tests.");
          assert(reactRoot, "React root should be initialized before running tests.");

          local didRender = false;
          local propagatedErrorMessage;
          local element = React.createElement(MockComponent, {
            onErrored = function(errorMessage)
              
              propagatedErrorMessage = errorMessage;

            end;
            onRendered = function()
              
              didRender = true;

            end;
          });

          reactRoot:render(element);
          repeat task.wait() until didRender or propagatedErrorMessage;

          if propagatedErrorMessage then

            error(propagatedErrorMessage);
          
          end;

          -- Simulate a click on the component.
          local dialogueItem = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueItem, "DialogueItem should be rendered in the ScreenGui.");

          local viewButton = dialogueItem:FindFirstChild("ViewButton");
          assert(viewButton and viewButton:IsA("GuiButton"), "ViewButton should be present in the DialogueItem.");

          local didSelectionChange = false;
          VirtualService.mocks.services.Selection.SelectionChanged:Once(function()
          
            didSelectionChange = true;

          end);

          VirtualService.events.GuiButton.Activated:fireEvent(viewButton);

          while not didSelectionChange do task.wait() end;

        end).toFinishBeforeSeconds(1);

      end);

      it("can reduce dialogue priority", function()

        expect(function()
          
          -- Render the component and wait for it to finish rendering.
          assert(screenGui, "ScreenGui should be initialized before running tests.");
          assert(reactRoot, "React root should be initialized before running tests.");

          local renderedEvent = Instance.new("BindableEvent");
          local dialogueContainer = generateDialogueContainer();
          local dialogueScript = dialogueContainer:FindFirstChild("1");
          assert(dialogueScript, "Dialogue script should be present in the dialogue container.");

          local element = React.createElement(MockComponent, {
            dialogueScript = dialogueScript;
            layoutOrder = 1;
            onRendered = function()
              
              renderedEvent:Fire();

            end;
          });

          reactRoot:render(element);
          renderedEvent.Event:Wait();

          -- Simulate a click on the component.
          local dialogueItem = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueItem, "DialogueItem should be rendered in the ScreenGui.");

          local decreasePriorityButton = dialogueItem:FindFirstChild("DecreasePriorityButton");
          assert(decreasePriorityButton and decreasePriorityButton:IsA("GuiButton"), "DecreasePriorityButton should be present in the DialogueItem.");

          local didPriorityChange = false;
          dialogueScript:GetPropertyChangedSignal("Name"):Once(function()
          
            expect(dialogueScript.Name).toBe("2");
            didPriorityChange = true;

          end);

          VirtualService.events.GuiButton.Activated:fireEvent(decreasePriorityButton);

          while not didPriorityChange do task.wait() end;

        end).toFinishBeforeSeconds(1);

      end);

      it("can increase dialogue priority", function()

        expect(function()
          
          -- Render the component and wait for it to finish rendering.
          assert(screenGui, "ScreenGui should be initialized before running tests.");
          assert(reactRoot, "React root should be initialized before running tests.");

          local renderedEvent = Instance.new("BindableEvent");
          local dialogueContainer = generateDialogueContainer();
          local dialogueScript = dialogueContainer:FindFirstChild("2");
          assert(dialogueScript, "Dialogue script should be present in the dialogue container.");

          local element = React.createElement(MockComponent, {
            dialogueScript = dialogueScript;
            layoutOrder = 2;
            onRendered = function()
              
              renderedEvent:Fire();

            end;
          });

          reactRoot:render(element);
          renderedEvent.Event:Wait();

          -- Simulate a click on the component.
          local dialogueItem = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueItem, "DialogueItem should be rendered in the ScreenGui.");

          local increasePriorityButton = dialogueItem:FindFirstChild("IncreasePriorityButton");
          assert(increasePriorityButton and increasePriorityButton:IsA("GuiButton"), "IncreasePriorityButton should be present in the DialogueItem.");

          local didPriorityChange = false;
          dialogueScript:GetPropertyChangedSignal("Name"):Once(function()
          
            expect(dialogueScript.Name).toBe("1");
            didPriorityChange = true;

          end);

          VirtualService.events.GuiButton.Activated:fireEvent(increasePriorityButton);

          while not didPriorityChange do task.wait() end;

        end).toFinishBeforeSeconds(1);

      end);

      it("cannot modify priority of conversations", function()

        expect(function()

          -- Render the component and wait for it to finish rendering.
          assert(screenGui, "ScreenGui should be initialized before running tests.");
          assert(reactRoot, "React root should be initialized before running tests.");

          local renderedEvent = Instance.new("BindableEvent");
          local element = React.createElement(MockComponent, {
            type = "Conversation";
            onRendered = function()
              
              renderedEvent:Fire();

            end;
          });

          reactRoot:render(element);
          renderedEvent.Event:Wait();

          -- Verify that the increase and decrease priority buttons are not present.
          local dialogueItem = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueItem, "DialogueItem should be rendered in the ScreenGui.");

          local increasePriorityButton = dialogueItem:FindFirstChild("IncreasePriorityButton");
          expect(increasePriorityButton).toBeNil();

          local decreasePriorityButton = dialogueItem:FindFirstChild("DecreasePriorityButton");
          expect(decreasePriorityButton).toBeNil();

        end).toFinishBeforeSeconds(1);

      end);

      it("can preview static dialogue content string", function()

        expect(function()

          -- Render the component and wait for it to finish rendering.
          assert(screenGui, "ScreenGui should be initialized before running tests.");
          assert(reactRoot, "React root should be initialized before running tests.");

          local expectedMessage = "This is a static dialogue content string.";
          local renderedEvent = Instance.new("BindableEvent");
          local dialogueScript = Instance.new("ModuleScript");
          dialogueScript.Name = "1";
          dialogueScript:SetAttribute("DialogueContent", expectedMessage);

          local element = React.createElement(MockComponent, {
            dialogueScript = dialogueScript;
            onRendered = function()
              
              renderedEvent:Fire();

            end;
          });

          reactRoot:render(element);
          renderedEvent.Event:Wait();

          -- Simulate a click on the component.
          local dialogueItem = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueItem, "DialogueItem should be rendered in the ScreenGui.");

          local viewButton = dialogueItem:FindFirstChild("ViewButton");
          assert(viewButton and viewButton:IsA("GuiButton"), "ViewButton should be present in the DialogueItem.");

          local informationFrame = viewButton:FindFirstChild("InformationFrame");
          assert(informationFrame, "Information should be present in the ViewButton.");

          local descriptionLabel = informationFrame:FindFirstChild("DescriptionLabel");
          assert(descriptionLabel and descriptionLabel:IsA("TextLabel"), "DescriptionLabel should be present in the InformationFrame.");
          expect(descriptionLabel.Text).toBe(expectedMessage);

        end).toFinishBeforeSeconds(1);

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