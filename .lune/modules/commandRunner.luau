--[[
    Author: Josephh310
    Description: Run commands synchronously or asynchronously with batch support.
]]

local process = require("@lune/process")
local task = require("@lune/task")

local runCommands = {}

runCommands.runModes  = {
    sync = "synchronous",
    async = "asynchronous"
}

export type CommandInterface = {
    name: string,
    command: string,
    args: { string },
    mode: typeof(runCommands.runModes.sync) | typeof(runCommands.runModes.async)
}

function runCommands.runSynchronous(name, command, args)
    local synced_process = process.exec(command, args)
    assert(synced_process.ok, synced_process.stderr)
    print(`Ran synchronous command {name} with code {synced_process.code}`)
end

function runCommands.runAsynchronous(name, command, args)
    print(`Running asynchronous command {name}`)
    task.spawn(process.exec, command, args)
end

function runCommands.runBatch(commands: {CommandInterface})
    for command_index, data in commands do
        if data.mode == runCommands.runModes.sync then
            runCommands.runSynchronous(data.name, data.command, data.args)
        elseif data.mode == runCommands.runModes.async then
            runCommands.runAsynchronous(data.name, data.command, data.args)
        end
    end
end

return runCommands
