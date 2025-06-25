--!strict

local EventProvider = require(script.EventProvider);

local VirtualService = {
  mocks = {
    isEnabled = false;
    services = {
      ChangeHistoryService = require(script.mocks.services.ChangeHistoryService);
      Selection = require(script.mocks.services.Selection);
    };
    globals = {
      plugin = require(script.mocks.globals.plugin);
    };
  };
  events = {
    GuiButton = {
      Activated = EventProvider.new((nil :: unknown) :: GuiButton, "Activated");
    }
  }
};

return VirtualService;