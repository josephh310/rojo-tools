--[[
    Author: Josephh310
    Description: Allows you to revert a selected place to a previous recent version
    Requirements: OPEN_CLOUD_KEY in .env with asset:read and asset:write permissions
]]

local stdio = require("@lune/stdio")
local listPlaces = require("../functions/listPlaces")
local listVersions = require("../functions/listVersions")
local rollbackVersion = require("../functions/rollbackVersion")
local config = require("../config")

local UNIVERSE_ID = config.UNIVERSE_ID

local places = listPlaces(UNIVERSE_ID)

local placeNames = {}
for _, place in places do
	table.insert(placeNames, place.name)
end

local selectedIndex = stdio.prompt("select", "Select a place to revert:", placeNames)
local selectedPlace = places[selectedIndex]

print(`Selected: {selectedPlace.name} ({selectedPlace.id})`)

local versions = listVersions(selectedPlace.id)

if #versions == 0 then
	warn("No versions found for this place.")
	return
end

local versionLabels = {}
for _, version in versions do
	local date = string.gsub(version.createTime, "T", " ")
	date = string.gsub(date, "Z$", "")
	table.insert(versionLabels, `v{version.versionNumber} — {date}`)
end

local versionIndex = stdio.prompt("select", "Select a version to revert to:", versionLabels)
local selectedVersion = versions[versionIndex]

local confirm = stdio.prompt(
	"confirm",
	`Revert {selectedPlace.name} to version {selectedVersion.versionNumber}?`
)

if not confirm then
	print("Cancelled.")
	return
end

rollbackVersion(selectedPlace.id, selectedVersion.versionNumber)
