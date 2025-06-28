--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local DialogueOptions = require(script.Parent);
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
local propagatedErrorMessage;
local eventConnection: RBXScriptConnection?;

return {

  describe("DialogueOptions", function()

    local function MockComponent(properties: any)

      local selectedScript = properties.selectedScript;
      local onErrored = properties.onErrored or function() end;
      local onRendered = properties.onRendered or function() end;

      React.useEffect(function()

        onRendered();

      end, {onRendered});

      return React.createElement(ErrorBoundary, {
        FallbackComponent = React.Fragment;
        onError = onErrored;
      }, {
        React.createElement(DialogueOptions, {
          selectedScript = selectedScript;
          plugin = VirtualService.mocks.globals.plugin;
          selectedDialogueType = selectedScript:GetAttribute("DialogueType") or "Conversation";
          layoutOrder = 1;
        })
      });

    end;

    local function verifyReactStatus()

      if propagatedErrorMessage then

        error(propagatedErrorMessage);

      end;

    end;

    local function createDialogueScript(name: string, type: "Conversation" | "Message" | "Redirect")

      local dialogueScript = Instance.new("ModuleScript");

      if type == "Conversation" then
        
        dialogueScript:AddTag("DialogueMakerConversationScript");

      else

        dialogueScript:AddTag("DialogueMakerDialogueScript");
        dialogueScript:SetAttribute("DialogueType", type);

      end;

      return dialogueScript;

    end;

    local function render(type: "Conversation" | "Message" | "Redirect"): ModuleScript

      assert(reactRoot, "React root should be initialized before running tests.");

      local selectedScript = createDialogueScript("TestDialogueScript", type);
      local didRender = false;
      local element = React.createElement(MockComponent, {
        selectedScript = selectedScript;
        onErrored = function(errorMessage)

          propagatedErrorMessage = errorMessage;

        end;
        onRendered = function()
          
          didRender = true;

        end;
      });

      reactRoot:render(element);
      repeat task.wait() until didRender or propagatedErrorMessage;
      verifyReactStatus();

      return selectedScript;

    end;

    return {

      it("can delete selected script", function()

        expect(function()

          local selectedScript = render("Conversation");
          local testFolder = Instance.new("Folder");
          selectedScript.Parent = testFolder;

          assert(screenGui, "ScreenGui should be initialized before running tests.");
          local dialogueOptions = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueOptions, "DialogueOptions should be rendered.");

          local deleteButton = dialogueOptions:FindFirstChild("DeleteButton");
          assert(deleteButton and deleteButton:IsA("TextButton"), "Delete button should be present in the DialogueOptions.");

          local didChangeParent = false;
          eventConnection = selectedScript:GetPropertyChangedSignal("Parent"):Once(function()

            didChangeParent = true;

          end);
          VirtualService.events.GuiButton.Activated:fireEvent(deleteButton);
          repeat task.wait() until didChangeParent or propagatedErrorMessage;
          verifyReactStatus();
          expect(selectedScript.Parent).toBe(nil);

        end).toFinishBeforeSeconds(1);

      end);

      it("hides condition and action buttons for conversations", function()

        expect(function()

          render("Conversation");

          assert(screenGui, "ScreenGui should be initialized before running tests.");
          local dialogueOptions = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueOptions, "DialogueOptions should be rendered.");

          local conditionButton = dialogueOptions:FindFirstChild("ConditionButton");
          expect(conditionButton).toBe(nil);

          local actionsDropdown = dialogueOptions:FindFirstChild("ActionsDropdown");
          expect(actionsDropdown).toBe(nil);

        end).toFinishBeforeSeconds(1);

      end);

      it("shows condition and action buttons for dialogue", function()

        expect(function()

          render("Message");

          assert(screenGui, "ScreenGui should be initialized before running tests.");
          local dialogueOptions = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueOptions, "DialogueOptions should be rendered.");

          local conditionButton = dialogueOptions:FindFirstChild("ConditionButton");
          expect(conditionButton).toNotBe(nil);

          local actionsDropdown = dialogueOptions:FindFirstChild("ActionsDropdown");
          expect(actionsDropdown).toNotBe(nil);

        end).toFinishBeforeSeconds(1);

      end);

      it(`hides non-initialization actions for "Redirect"-type dialogue scripts`, function()

        expect(function()

          render("Redirect");

          assert(screenGui, "ScreenGui should be initialized before running tests.");
          local dialogueOptions = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueOptions, "DialogueOptions should be rendered.");

          local actionsDropdown = dialogueOptions:FindFirstChild("ActionsDropdown");
          assert(actionsDropdown, "Actions dropdown should be present in the DialogueOptions.");

          local toggleButton = actionsDropdown:FindFirstChild("ToggleButton");
          assert(toggleButton and toggleButton:IsA("TextButton"), "Toggle button should be present in the ActionsDropdown.");

          VirtualService.events.GuiButton.Activated:fireEvent(toggleButton);
          
          local optionsFrame = actionsDropdown:WaitForChild("OptionsFrame");
          expect(optionsFrame:FindFirstChild("InitializationButton")).toNotBe(nil);
          expect(optionsFrame:FindFirstChild("CompletionButton")).toBe(nil);
          expect(optionsFrame:FindFirstChild("CleanupButton")).toBe(nil);

        end).toFinishBeforeSeconds(1);

      end);

      it("can initialize a condition script", function()

        expect(function()

          local selectedScript = render("Message");

          assert(screenGui, "ScreenGui should be initialized before running tests.");
          local dialogueOptions = screenGui:FindFirstChildOfClass("Frame");
          assert(dialogueOptions, "DialogueOptions should be rendered.");

          local conditionButton = dialogueOptions:FindFirstChild("ConditionButton");
          assert(conditionButton and conditionButton:IsA("TextButton"), "Condition button should be present in the DialogueOptions.");
          VirtualService.events.GuiButton.Activated:fireEvent(conditionButton);
          selectedScript:WaitForChild("ConditionScript");

        end).toFinishBeforeSeconds(1);

      end);
      
    }

  end, {
    beforeEach = function()

      local newScreenGui = Instance.new("ScreenGui");
      screenGui = newScreenGui;
      reactRoot = ReactRoblox.createRoot(newScreenGui);
      VirtualService.mocks.isEnabled = true;

    end;
    afterEach = function()

      if reactRoot then

        reactRoot:unmount();
        reactRoot = nil;

      end;

      if screenGui then

        screenGui:Destroy();
        screenGui = nil;

      end;

      if eventConnection then

        eventConnection:Disconnect();
        eventConnection = nil;

      end;

      propagatedErrorMessage = nil;
      VirtualService.mocks.isEnabled = false;

    end;
  })
};