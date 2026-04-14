local net = require("@lune/net")
local process = require("@lune/process")
local serde = require("@lune/serde")
local fetchSecret = require("./fetchSecret")

return function(universeId: number, placeId: number, placeData: buffer | string)
	print(`Publishing place {placeId} to universe {universeId}`)

	local response = net.request({
		url = `https://apis.roblox.com/universes/v1/{universeId}/places/{placeId}/versions?versionType=Published`,
		method = "POST",
		headers = {
			["x-api-key"] = fetchSecret("OPEN_CLOUD_KEY"),
			["Content-Type"] = "application/octet-stream",
		},
		body = placeData,
	})

	if not response.ok then
		if response.statusCode == 409 then
			warn("\tFailed to publish: please exit your Team Create session before publishing.")
		else
			warn(`\tFailed to publish place [{response.statusCode}]\n\t{response.statusMessage}`)
		end
		process.exit(1)
	end

	local data = serde.decode("json", response.body)
	print(`\tPublished as version {data.versionNumber}`)

	return data.versionNumber
end
