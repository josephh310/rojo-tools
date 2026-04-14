--[[
    Author: Josephh310
    Description: Fetches a selected place's file from the Roblox and syncs it back to the filesystem using rojo
    Requirements: OPEN_CLOUD_KEY in .env with legacy-asset:manage permissions
]]

local fs = require("@lune/fs")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local stdio = require("@lune/stdio")
local runCommands = require("./modules/commandRunner")
local downloadPlace = require("./functions/downloadPlace")
local listPlaces = require("./functions/listPlaces")
local config = require("../rtools")

local isServing
if process.os == "windows" then
    local result = process.exec("cmd", { "/c", "tasklist /FI \"IMAGENAME eq rojo.exe\" /FO CSV /NH" })
    isServing = result.ok and string.find(result.stdout, "rojo.exe") ~= nil
else
    local result = process.exec("pgrep", { "-f", "rojo serve" })
    isServing = result.ok
end

if isServing then
    print("Error: rojo serve is currently running. Stop the serve script before running syncback or files may duplicate.")
    process.exit(1)
end

local UNIVERSE_ID = config.UNIVERSE_ID
local OUTPUT_FILE = "place.rbxl"

local places = listPlaces(UNIVERSE_ID)

local placeNames = {}
for _, place in places do
    table.insert(placeNames, place.name)
end

local selectedIndex = stdio.prompt("select", "Select a place to syncback:", placeNames)
local selectedPlace = places[selectedIndex]

print(`Selected: {selectedPlace.name} ({selectedPlace.id})`)

local placeData = downloadPlace(selectedPlace.id)
fs.writeFile(OUTPUT_FILE, roblox.serializePlace(placeData))
print("Saved place to " .. OUTPUT_FILE)

runCommands.runBatch({
    [1] = {
        name = "rojo syncback",
        command = "rojo",
        args = { "syncback", "--input", OUTPUT_FILE, "--non-interactive" },
        mode = runCommands.runModes.sync
    },
})

fs.removeFile(OUTPUT_FILE)
print("Cleaned up place file")
