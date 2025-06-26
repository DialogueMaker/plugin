--!strict

local selectionChangedEvent = Instance.new("BindableEvent");
local VirtualSelection = {
  currentSelection = {};
  SelectionChanged = selectionChangedEvent.Event;
};

function VirtualSelection:Set(selection: {Instance}): ()
  
  local oldSelection = self.currentSelection;
  self.currentSelection = selection;

  if not oldSelection[1] and #selection > 0 then

    selectionChangedEvent:Fire();
    return;

  end;

  local checkedInstances = {};
  for _, instance in oldSelection do

    if not table.find(selection, instance) then

      selectionChangedEvent:Fire();
      return;

    end;

    table.insert(checkedInstances, instance);

  end;

  for _, instance in selection do

    if not table.find(checkedInstances, instance) then

      selectionChangedEvent:Fire();
      return;

    end;

  end;

end;

function VirtualSelection:Get(): {Instance}

  return self.currentSelection;

end;

function VirtualSelection:Add(instances: {Instance}): ()

  local shouldFire = false;

  for _, instance in instances do

    if not table.find(self.currentSelection, instance) then

      table.insert(self.currentSelection, instance);
      shouldFire = true;

    end;

  end;

  if shouldFire then

    selectionChangedEvent:Fire();

  end;

end;

function VirtualSelection:Remove(instances: {Instance}): ()

  local shouldFire = false;

  for _, instance in instances do

    local index = table.find(self.currentSelection, instance);

    if index then

      table.remove(self.currentSelection, index);
      shouldFire = true;

    end;

  end;

  if shouldFire then

    selectionChangedEvent:Fire();

  end;

end;

return (VirtualSelection :: unknown) :: Selection;