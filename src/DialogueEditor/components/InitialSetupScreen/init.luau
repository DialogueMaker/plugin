--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local Paragraph = require(root.DialogueEditor.components.Paragraph);
local Button = require(root.DialogueEditor.components.Button);
local InstanceInput = require(root.DialogueEditor.components.InstanceInput);
local useChangeHistory = require(root.DialogueEditor.hooks.useChangeHistory);

local function InitialSetupScreen()

  local beginHistoryRecording, finishHistoryRecording = useChangeHistory();

  return React.createElement("Frame", {
    Size = UDim2.new(1, 0, 1, 0);
    BackgroundTransparency = 1;
  }, {
    UIPadding = React.createElement("UIPadding", {
      PaddingTop = UDim.new(0, 15);
      PaddingBottom = UDim.new(0, 15);
      PaddingLeft = UDim.new(0, 15);
      PaddingRight = UDim.new(0, 15);
    });
    UIListLayout = React.createElement("UIListLayout", {
      SortOrder = Enum.SortOrder.LayoutOrder;
      Padding = UDim.new(0, 15);
      VerticalAlignment = Enum.VerticalAlignment.Center;
      HorizontalAlignment = Enum.HorizontalAlignment.Center;
    });
    Heading = React.createElement(Paragraph, {
      text = "Welcome to the Dialogue Maker plugin!";
      layoutOrder = 1;
      textSize = 24;
    });
    Description = React.createElement(Paragraph, {
      text = "This is a tool to help you create and manage dialogue in your Roblox games.";
      layoutOrder = 2;
    });
    Instructions = React.createElement(Paragraph, {
      text = "To get started, please add the Dialogue Maker Kit to your game, or select your existing packages folder that was created by your package manager (Wally, pesde, etc.).";
      layoutOrder = 3;
    });
    Options = React.createElement("Frame", {
      BackgroundTransparency = 1;
      LayoutOrder = 4;
      AutomaticSize = Enum.AutomaticSize.Y;
    }, {
      UIListLayout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        FillDirection = Enum.FillDirection.Vertical;
        Padding = UDim.new(0, 15);
        VerticalAlignment = Enum.VerticalAlignment.Center;
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
      });
      AddDialogueMakerKitButton = React.createElement(Button, {
        text = "Add Dialogue Maker Kit";
        layoutOrder = 1;
        onClick = function()
          
          local historyIdentifier = beginHistoryRecording("Add Dialogue Maker Kit");

          local dialogueMakerKit = root.DialogueMakerKit:Clone();
          dialogueMakerKit:AddTag("DialogueMakerKit");
          dialogueMakerKit.Parent = ReplicatedStorage;
          
          finishHistoryRecording(historyIdentifier);

          print(`[Dialogue Maker] Added Dialogue Maker Kit to ReplicatedStorage. Feel free to move it if it doesn't work there. If you use Rojo, you may need to add the folder to your project using "Save to File".`);


        end;
      });
      SelectPackagesFolderButton = React.createElement(InstanceInput, {
        className = "Folder";
        layoutOrder = 2;
        onChanged = function(folder)

          local historyIdentifier = beginHistoryRecording("Select Dialogue Maker plugin packages folder");

          if not folder then

            return;

          end;

          folder:AddTag("DialogueMakerPackages");

          finishHistoryRecording(historyIdentifier);
          
        end;
      });
    });
  });

end;

return React.memo(InitialSetupScreen);