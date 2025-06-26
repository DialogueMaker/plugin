--!strict

local EventProvider = {};

export type EventProvider<InstanceType, T> = {
  getSignal: (self: EventProvider<InstanceType, T>, instance: InstanceType) -> RBXScriptSignal<T>;
  fireEvent: (self: EventProvider<InstanceType, T>, instance: InstanceType, ...T) -> ();
};

function EventProvider.new<InstanceType, T>(instanceType: InstanceType, eventName: string, ...: T)

  local events = {};
  local connections = {};
  local eventProvider: EventProvider<InstanceType, T> = {} :: EventProvider<InstanceType, T>;

  local function getBindableEvent(instance: InstanceType): BindableEvent

    if events[instance] then

      return events[instance];

    end;

    local bindableEvent = Instance.new("BindableEvent");
    events[instance] = bindableEvent;

    if not connections[instance] then

      connections[instance] = ((instance :: any)[eventName] :: RBXScriptSignal):Connect(function(...)
      
        eventProvider:fireEvent(instance, ...);

      end);

    end;

    return bindableEvent;

  end;

  local function getSignal(self, instance: InstanceType): RBXScriptSignal<T>

    return getBindableEvent(instance).Event;

  end;

  local function fireEvent(self, instance: InstanceType, ...): ()

    getBindableEvent(instance):Fire(...);

  end;

  eventProvider = {
    getSignal = getSignal;
    fireEvent = fireEvent;
  }

  return eventProvider;

end;

return EventProvider;