local net = require("@lune/net")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local fetchSecret = require("./fetchSecret")

return function(place_id: number): roblox.DataModel
	print(`Retrieving place {place_id}`)

	local response = net.request({
		url = `https://apis.roblox.com/asset-delivery-api/v1/assetId/{place_id}`,
		headers = {
			["x-api-key"] = fetchSecret("OPEN_CLOUD_KEY"),
		},
	})

	if not response.ok then
		warn(`\tFailed to fetch map place [{response.statusCode}]\n\t{response.statusMessage}`)
		process.exit(1)
	end

	local response_table = serde.decode("json", response.body)

	local place = net.request({
		url = response_table.location,
	})

	if not place.ok then
		warn(`\tFailed to fetch map place [{place.statusCode}]`)
		print("\t" .. place.statusMessage)
		process.exit(1)
	end

	return roblox.deserializePlace(place.body)
end
