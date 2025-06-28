--!strict

local root = script.Parent.Parent.Parent;
local React = require(root.roblox_packages.react);
local VirtualService = require(root.VirtualService);

local function useChangeHistory()

  local game = VirtualService.globals.game;
  local ChangeHistoryService = game:GetService("ChangeHistoryService");

  local startRecording = React.useCallback(function(label: string)

    if ChangeHistoryService:IsRecordingInProgress() then
      
      ChangeHistoryService:FinishRecording("", Enum.FinishRecordingOperation.Cancel);

    end

    local identifier = ChangeHistoryService:TryBeginRecording(label);

    return identifier;

  end, {});

  local finishRecording = React.useCallback(function(identifier: string, operation: Enum.FinishRecordingOperation?)

    ChangeHistoryService:FinishRecording(identifier, operation or Enum.FinishRecordingOperation.Commit);

  end, {});

  return startRecording, finishRecording;

end;

return useChangeHistory;