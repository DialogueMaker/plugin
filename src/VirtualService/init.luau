--!strict

local EventProvider = require(script.EventProvider);

local VirtualService = {
  globals = {
    plugin = plugin;
    game = game;
    script = script;
  };
  events = {
    GuiButton = {
      Activated = EventProvider.new((nil :: unknown) :: GuiButton, "Activated");
    }
  }
};

return VirtualService;