--!strict
local function useViewingPriority(dialogueParent: ModuleScript | Folder): string

  local viewingPriority = "";

  local possibleDialogueContainer = dialogueParent;
  while not possibleDialogueContainer:IsA("Folder") do

    viewingPriority = `{dialogueParent.Name}{if viewingPriority ~= "" then `.{viewingPriority}` else ""}`;

    local possibleParent = possibleDialogueContainer.Parent;
    assert(possibleParent and (possibleParent:IsA("ModuleScript") or possibleParent:IsA("Folder")));
    possibleDialogueContainer = possibleParent :: ModuleScript | Folder;

  end;

  return viewingPriority;

end;

return useViewingPriority;