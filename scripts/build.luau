--[[
    Author: Josephh310
    Description: Builds a place file from the local filetree and publishes to a selected Roblox place
    Requirements: OPEN_CLOUD_KEY in .env with universe-places:write permissions
]]

local fs = require("@lune/fs")
local stdio = require("@lune/stdio")
local runCommands = require("../modules/commandRunner")
local listPlaces = require("../functions/listPlaces")
local uploadPlace = require("../functions/uploadPlace")
local config = require("../config")

local UNIVERSE_ID = config.UNIVERSE_ID
local OUTPUT_FILE = "build.rbxl"

local places = listPlaces(UNIVERSE_ID)

local placeNames = {}
for _, place in places do
	table.insert(placeNames, place.name)
end

local selectedIndex = stdio.prompt("select", "Select a place to publish to:", placeNames)
local selectedPlace = places[selectedIndex]

print(`Selected: {selectedPlace.name} ({selectedPlace.id})`)

runCommands.runBatch({
	[1] = {
		name = "rojo build",
		command = "rojo",
		args = { "build", "-o", OUTPUT_FILE },
		mode = runCommands.runModes.sync,
	},
})

print(`Built project to {OUTPUT_FILE}`)

local placeData = fs.readFile(OUTPUT_FILE)
uploadPlace(UNIVERSE_ID, selectedPlace.id, placeData)

fs.removeFile(OUTPUT_FILE)
print("Cleaned up build file")
