--!strict

local root = script.Parent.Parent.Parent.Parent.Parent.Parent;
local DialogueGroupContainer = require(script.Parent);
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
local dialogueGroupContainer;
local dialogueGroup;

return {

  describe("DialogueGroupContainer", function()

    local function MockComponent(properties: any)

      local dialogueType = properties.type or "Message";
      local onRendered = properties.onRendered;
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
        React.createElement(DialogueGroupContainer, {
          name = dialogueType;
          plugin = VirtualService.mocks.globals.plugin;
          layoutOrder = 1;
        })
      });

    end;

    local function verifyReactStatus()

      if propagatedErrorMessage then

        error(propagatedErrorMessage);

      end;

    end;

    local function getDialogueItems(screenGui: ScreenGui): {Frame} 

      dialogueGroupContainer = screenGui:FindFirstChildOfClass("Frame");
      assert(dialogueGroupContainer, "DialogueGroupContainer should be rendered in the ScreenGui.");

      dialogueGroup = dialogueGroupContainer:FindFirstChild("DialogueGroup");
      if not dialogueGroup then

        return {};

      end;

      local dialogueItems = {};
      for _, child in dialogueGroup:GetChildren() do

        if child:IsA("Frame") then
          
          table.insert(dialogueItems, child);
        
        end;

      end;

      return dialogueItems;

    end;

    local function createDialogueScript(name: string)

      local dialogueScript = Instance.new("ModuleScript");
      dialogueScript.Name = name;
      dialogueScript:SetAttribute("DialogueType", "Message");
      dialogueScript:AddTag("DialogueMakerDialogueScript");
      return dialogueScript;

    end;

    local function initializeDialogueFolder(messageCount: number)

      local dialogueFolder = Instance.new("Folder");
      dialogueFolder.Name = "Messages";

      for i = 1, messageCount do

        local dialogueScript = createDialogueScript(tostring(i));
        dialogueScript.Parent = dialogueFolder;

      end;

      local selectedScript = Instance.new("ModuleScript");
      selectedScript:SetAttribute("DialogueType", "Message");
      selectedScript:AddTag("DialogueMakerDialogueScript");
      dialogueFolder.Parent = selectedScript;

      return dialogueFolder, selectedScript;

    end;

    local function render()

      assert(reactRoot, "React root should be initialized before running tests.");

      local didRender = false;
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

    end;

    return {

      it("refreshes the selected dialogue group if a dialogue script is added to a dialogue folder", function()

        expect(function()

          -- Render the component and wait for it to finish rendering.
          assert(screenGui, "ScreenGui should be initialized before running tests.");
          render();
          verifyReactStatus();

          -- Verify that there are no dialogue items rendered.
          expect(#getDialogueItems(screenGui)).toBe(0);
          assert(dialogueGroupContainer);

          local dialogueFolder, selectedScript = initializeDialogueFolder(4);
          VirtualService.mocks.services.Selection:Set({selectedScript});
          dialogueGroupContainer.ChildAdded:Wait();
          verifyReactStatus();
          expect(#getDialogueItems(screenGui)).toBe(#dialogueFolder:GetChildren());

          -- Create a new dialogue script, but verify that it is not rendered yet.
          assert(dialogueGroup);

          local newDialogueScript = createDialogueScript(tostring(#dialogueFolder:GetChildren() + 1));
          verifyReactStatus();
          expect(#getDialogueItems(screenGui)).toBe(#dialogueFolder:GetChildren());

          -- Add the new dialogue script to the folder and verify that it is rendered.
          newDialogueScript.Parent = dialogueFolder;
          dialogueGroup.ChildAdded:Wait();
          verifyReactStatus();
          expect(#getDialogueItems(screenGui)).toBe(#dialogueFolder:GetChildren());

        end).toFinishBeforeSeconds(1);

      end);

      it("refreshes the selected dialogue group if a dialogue script is removed from a dialogue folder", function()

        expect(function()

          -- Render the component and wait for it to finish rendering.
          assert(screenGui, "ScreenGui should be initialized before running tests.");
          render();
          verifyReactStatus();

          -- Verify that there are no dialogue items rendered.
          expect(#getDialogueItems(screenGui)).toBe(0);
          assert(dialogueGroupContainer);

          local dialogueFolder, selectedScript = initializeDialogueFolder(4);
          VirtualService.mocks.services.Selection:Set({selectedScript});
          dialogueGroupContainer.ChildAdded:Wait();
          verifyReactStatus();
          expect(#getDialogueItems(screenGui)).toBe(#dialogueFolder:GetChildren());

          -- Delete a new dialogue script and verify that it is not rendered.
          assert(dialogueGroup);

          dialogueFolder:GetChildren()[1]:Destroy();
          dialogueGroup.ChildRemoved:Wait();
          verifyReactStatus();
          expect(#getDialogueItems(screenGui)).toBe(#dialogueFolder:GetChildren());

        end).toFinishBeforeSeconds(1);

      end);

      it("refreshes the conversation group if a conversation is added", function()

        expect(function()

          -- Render the component and wait for it to finish rendering.
          assert(screenGui, "ScreenGui should be initialized before running tests.");
          render();
          verifyReactStatus();

          -- Select the conversations folder parent and verify that there are no conversations rendered.
          local conversationsFolderParent = Instance.new("Folder");
          local conversationsFolder = Instance.new("Folder");
          conversationsFolder.Name = "Conversations";
          conversationsFolder.Parent = conversationsFolderParent;

          VirtualService.mocks.services.Selection:Set({conversationsFolderParent});
          verifyReactStatus();
          expect(#getDialogueItems(screenGui)).toBe(#conversationsFolder:GetChildren());

          -- Create a new conversation script, but verify that it is not rendered yet.
          local conversationScript = Instance.new("ModuleScript");
          conversationScript:AddTag("DialogueMakerConversationScript");
          verifyReactStatus();
          expect(#getDialogueItems(screenGui)).toBe(#conversationsFolder:GetChildren());

          -- Add the conversation script to the conversations folder and verify that it is rendered.
          conversationScript.Parent = conversationsFolder;
          verifyReactStatus();
          assert(dialogueGroup);
          dialogueGroup.ChildAdded:Wait();
          expect(#getDialogueItems(screenGui)).toBe(#conversationsFolder:GetChildren());

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

      VirtualService.mocks.services.Selection:Set({});

      propagatedErrorMessage = nil;
      dialogueGroupContainer = nil;
      dialogueGroup = nil;

    end;
  })
};