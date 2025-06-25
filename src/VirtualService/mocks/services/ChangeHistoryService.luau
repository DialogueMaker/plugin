--!strict

local HttpService = game:GetService("HttpService");

local VirtualChangeHistoryService = {
  currentHistory = {};
  currentIdentifier = nil;
};

function VirtualChangeHistoryService:TryBeginRecording()

  if self.currentIdentifier then

    return;

  end

  self.currentIdentifier = HttpService:GenerateGUID(false);
  self.currentHistory[self.currentIdentifier] = true; -- Simulate a successful start
  return self.currentIdentifier;

end;

function VirtualChangeHistoryService:IsRecordingInProgress()

  return self.currentIdentifier ~= nil;

end;

function VirtualChangeHistoryService:FinishRecording(identifier, operation)

  if not self.currentHistory[identifier] then

    return;

  end

  if operation == Enum.FinishRecordingOperation.Cancel then
    self.currentHistory[identifier] = nil;
  end

  self.currentIdentifier = nil; 

end;

return (VirtualChangeHistoryService :: unknown) :: ChangeHistoryService;