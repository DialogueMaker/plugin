--!strict

local ServerStorage = game:GetService("ServerStorage");

local IJW = require(ServerStorage.DialogueMakerPlugin.roblox_packages.ijw);
local TestRunner = IJW.TestRunner;

local tests = TestRunner:findTestsFromAncestors({ServerStorage.DialogueMakerPlugin:Clone()}, ".test");
local results = TestRunner:runTests(tests);

TestRunner:displayResults(results);

return results;