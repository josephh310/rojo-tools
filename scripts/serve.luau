--[[
    Author: Josephh310
    Description: Serves the place using rojo, ensuring the plugin is installed first
]]

local runCommands = require("../modules/commandRunner")

runCommands.runBatch({
    [1] = {
        name = "install plugin",
        command = "rojo",
        args = { "plugin", "install" },
        mode = runCommands.runModes.sync
    },
    [2] = {
        name = "sourcemap watch",
        command = "rojo",
        args = { "sourcemap", "--watch", "default.project.json", "--output", "sourcemap.json", "--include-non-scripts"},
        mode = runCommands.runModes.async
    },
    [3] = {
        name = "rojo serve",
        command = "rojo",
        args = { "serve" },
        mode = runCommands.runModes.async
    },
})
