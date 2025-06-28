--!strict

local StarterPlayer = game:GetService("StarterPlayer");

local root = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent;
local AutoTriggerCheckbox = require(script.Parent);
local VirtualService = require(root.VirtualService);
local VirtualChangeHistoryService = require(root.DialogueEditor.mocks.ChangeHistoryService);
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
local originalLoaderScript;
local childAddedConnection: RBXScriptConnection?;

return {

  describe("AutoTriggerCheckbox", function()

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
        React.createElement(AutoTriggerCheckbox, {
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

    local function createDialogueScript(name: string)

      local dialogueScript = Instance.new("ModuleScript");
      dialogueScript:AddTag("DialogueMakerConversationScript");
      return dialogueScript;

    end;

    local function render(initialValue: boolean?): ModuleScript

      assert(reactRoot, "React root should be initialized before running tests.");

      local selectedScript = createDialogueScript("TestDialogueScript");
      selectedScript:SetAttribute("ShouldAutoTriggerConversation", initialValue);

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

      return selectedScript;

    end;

    local function getCheckbox()

      assert(screenGui, "ScreenGui should be initialized before running tests.");

      local checkboxFrame = screenGui:FindFirstChildOfClass("Frame");
      assert(checkboxFrame, "Frame should be present in the ScreenGui.");

      local checkbox = checkboxFrame:FindFirstChild("Checkbox");
      assert(checkbox and checkbox:IsA("TextButton"), "Checkbox should be present in the frame.");

      return checkbox;

    end;

    local function verifyCheckboxFeature(goalValue: boolean)

      local selectedScript = render(not goalValue);
      verifyReactStatus();

      local checkbox = getCheckbox();

      VirtualService.events.GuiButton.Activated:fireEvent(checkbox);
      expect(selectedScript:GetAttribute("ShouldAutoTriggerConversation")).toBe(goalValue);

    end;

    return {

      it(`can add "ShouldAutoTriggerConversation" tag to selected script`, function()

        expect(function()

          verifyCheckboxFeature(true);

        end).toFinishBeforeSeconds(1);

      end);

      it(`can remove "ShouldAutoTriggerConversation" tag from selected script`, function()

        expect(function()

          verifyCheckboxFeature(false);

        end).toFinishBeforeSeconds(1);

      end);

      it(`automatically refreshes if ShouldAutoTriggerConversation attribute is toggled`, function()

        expect(function()

          local selectedScript = render();
          verifyReactStatus();

          local checkbox = getCheckbox();
          selectedScript:SetAttribute("ShouldAutoTriggerConversation", true);
          checkbox:GetPropertyChangedSignal("BackgroundColor3"):Wait();

          selectedScript:SetAttribute("ShouldAutoTriggerConversation", false);
          checkbox:GetPropertyChangedSignal("BackgroundColor3"):Wait();

        end).toFinishBeforeSeconds(1);

      end);

      it("can automatically create loader script from template", function()

        expect(function()

          verifyCheckboxFeature(true);

          local createdLoaderScript = StarterPlayer.StarterPlayerScripts:FindFirstChild("DialogueLoader");

          expect(createdLoaderScript).toNotBe(nil);

          createdLoaderScript:Destroy();

        end).toFinishBeforeSeconds(1);

      end);
      
    }

  end, {
    beforeAll = function()

      local loaderScript = StarterPlayer.StarterPlayerScripts:FindFirstChild("DialogueMakerLoader");
      if loaderScript then

        originalLoaderScript = loaderScript;
        loaderScript.Parent = nil;

      end;

    end,
    beforeEach = function()

      local newScreenGui = Instance.new("ScreenGui");
      screenGui = newScreenGui;
      reactRoot = ReactRoblox.createRoot(newScreenGui);

      local virtualChangeHistoryService = VirtualChangeHistoryService.new();
      VirtualService.globals.game = {
        GetService = function(self, serviceName: string): unknown

          if serviceName == "ChangeHistoryService" then

            return virtualChangeHistoryService;

          end;

          return game:GetService(serviceName);

        end;
      };

    end;
    afterEach = function()

      if reactRoot then

        reactRoot:unmount();

      end;

      if screenGui then

        screenGui:Destroy();

      end;

      propagatedErrorMessage = nil;

    end;
    afterAll = function()

      if originalLoaderScript then

        originalLoaderScript.Parent = StarterPlayer.StarterPlayerScripts;

      end;

      if childAddedConnection then

        childAddedConnection:Disconnect();
        childAddedConnection = nil;

      end;

    end;
  })
};