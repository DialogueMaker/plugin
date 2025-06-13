--!strict

local schema = {
  loader = {
    useDefault = {
      name = "Use default loader";
      description = "If enabled, the Dialogue Maker Kit will use the default loader to load conversations.";
      defaultValue = true;
      type = "boolean";
    };
  };
  packages = {
    location = {
      name = "Package location";
      description = "The folder where Dialogue Maker Kit packages are located.";
      defaultValue = nil;
      className = "Folder";
    }
  };
};

return schema;