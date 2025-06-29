--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local DynamicContentCheckbox = require(script.Parent);
local VirtualService = require(root.VirtualService);
local React = require(root.roblox_packages.react);
local ReactErrorBoundary = require(root.roblox_packages.ReactErrorBoundary);
local ErrorBoundary = ReactErrorBoundary.ErrorBoundary;
local ReactRoblox = require(root.roblox_packages["react-roblox"]);
local IJW = require(root.roblox_packages.ijw);
local expect = IJW.expect;
local describe = IJW.describe;
local it = IJW.it;
local VirtualSelection = require(root.DialogueEditor.mocks.Selection);
local VirtualChangeHistoryService = require(root.DialogueEditor.mocks.ChangeHistoryService);

local screenGui: ScreenGui?;
local reactRoot: ReactRoblox.RootType?;
local propagatedErrorMessage;
local eventConnection: RBXScriptConnection?;

return {

  describe("DynamicContentCheckbox", function()

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
        React.createElement(DynamicContentCheckbox, {
          selectedScript = selectedScript;
          layoutOrder = 1;
        })
      });

    end;

    local function verifyReactStatus()

      if propagatedErrorMessage then

        error(propagatedErrorMessage);

      end;

    end;

    local function createDialogueScript(type: "Conversation" | "Message" | "Redirect")

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

      local selectedScript = createDialogueScript(type);
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

      it("can create ContentScript if it doesn't exist", function()

        expect(function()

          local selectedScript = render("Message");

          assert(screenGui, "ScreenGui should be initialized before running tests.");
          local dynamicContentCheckbox = screenGui:FindFirstChildOfClass("Frame");
          assert(dynamicContentCheckbox, "DynamicContentCheckbox should be rendered.");

          local checkbox = dynamicContentCheckbox:FindFirstChild("Checkbox");
          assert(checkbox and checkbox:IsA("TextButton"), "Checkbox should be rendered inside DynamicContentCheckbox.");

          VirtualService.events.GuiButton.Activated:fireEvent(checkbox);
          selectedScript:WaitForChild("ContentScript");

        end).toFinishBeforeSeconds(1);

      end);

      it(`can toggle "IsDisabled" attribute on ContentScript`, function()

        expect(function()

          local selectedScript = render("Message");

          assert(screenGui, "ScreenGui should be initialized before running tests.");
          local dynamicContentCheckbox = screenGui:FindFirstChildOfClass("Frame");
          assert(dynamicContentCheckbox, "DynamicContentCheckbox should be rendered.");

          local checkbox = dynamicContentCheckbox:FindFirstChild("Checkbox");
          assert(checkbox and checkbox:IsA("TextButton"), "Checkbox should be rendered inside DynamicContentCheckbox.");

          VirtualService.events.GuiButton.Activated:fireEvent(checkbox);
          local contentScript = selectedScript:WaitForChild("ContentScript");
          verifyReactStatus();
          checkbox:GetAttributeChangedSignal("IsChecked"):Wait();
          expect(contentScript:GetAttribute("IsDisabled")).toBe(false);

          VirtualService.events.GuiButton.Activated:fireEvent(checkbox);
          checkbox:GetAttributeChangedSignal("IsChecked"):Wait();
          verifyReactStatus();
          expect(contentScript:GetAttribute("IsDisabled")).toBe(true);

          VirtualService.events.GuiButton.Activated:fireEvent(checkbox);
          checkbox:GetAttributeChangedSignal("IsChecked"):Wait();
          verifyReactStatus();
          expect(contentScript:GetAttribute("IsDisabled")).toBe(false);

        end).toFinishBeforeSeconds(1);

      end);
      
    }

  end, {
    beforeEach = function()

      local newScreenGui = Instance.new("ScreenGui");
      screenGui = newScreenGui;
      reactRoot = ReactRoblox.createRoot(newScreenGui);

      local virtualSelection = VirtualSelection.new();
      local virtualChangeHistoryService = VirtualChangeHistoryService.new();
      VirtualService.globals.game = {
        GetService = function(self, serviceName: string): unknown

          if serviceName == "Selection" then

            return virtualSelection;

          elseif serviceName == "ChangeHistoryService" then

            return virtualChangeHistoryService;

          end;

          return game:GetService(serviceName);

        end;
      };

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
      VirtualService.globals.game = game;

    end;
  })
};