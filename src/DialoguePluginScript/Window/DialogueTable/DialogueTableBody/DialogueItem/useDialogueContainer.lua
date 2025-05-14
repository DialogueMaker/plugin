--!strict
local function useDialogueContainer(dialogueParent: ModuleScript | Folder): Folder

  local possibleDialogueContainer = dialogueParent;

  while not possibleDialogueContainer:IsA("Folder") do

    local possibleParent = possibleDialogueContainer.Parent;
    assert(possibleParent and (possibleParent:IsA("ModuleScript") or possibleParent:IsA("Folder")));
    possibleDialogueContainer = dialogueParent.Parent :: ModuleScript | Folder;

  end;

  return possibleDialogueContainer :: Folder;

end;

return useDialogueContainer;