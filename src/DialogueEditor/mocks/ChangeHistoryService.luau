--!strict

local HttpService = game:GetService("HttpService");

local VirtualChangeHistoryService = {};

function VirtualChangeHistoryService.new()

  local virtualChangeHistoryService = {
    currentHistory = {};
    currentIdentifier = nil;
  };

  function virtualChangeHistoryService:TryBeginRecording()

    if self.currentIdentifier then

      return;

    end

    self.currentIdentifier = HttpService:GenerateGUID(false);
    self.currentHistory[self.currentIdentifier] = true; -- Simulate a successful start
    return self.currentIdentifier;

  end;

  function virtualChangeHistoryService:IsRecordingInProgress()

    return self.currentIdentifier ~= nil;

  end;

  function virtualChangeHistoryService:FinishRecording(identifier, operation)

    if not self.currentHistory[identifier] then

      return;

    end

    if operation == Enum.FinishRecordingOperation.Cancel then
      self.currentHistory[identifier] = nil;
    end

    self.currentIdentifier = nil; 

  end;

  return virtualChangeHistoryService;

end;

return VirtualChangeHistoryService;