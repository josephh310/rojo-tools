local net = require("@lune/net")
local process = require("@lune/process")
local serde = require("@lune/serde")
local fetchSecret = require("./fetchSecret")

return function(assetId: number, versionNumber: number): number
	print(`Rolling back asset {assetId} to version {versionNumber}`)

	local response = net.request({
		url = `https://apis.roblox.com/assets/v1/assets/{assetId}/versions:rollback`,
		method = "POST",
		headers = {
			["x-api-key"] = fetchSecret("OPEN_CLOUD_KEY"),
			["Content-Type"] = "application/json",
		},
		body = serde.encode("json", {
			assetVersion = `assets/{assetId}/versions/{versionNumber}`,
		}),
	})

	if not response.ok then
		warn(`\tFailed to rollback [{response.statusCode}]\n\t{response.statusMessage}`)
		process.exit(1)
	end

	local data = serde.decode("json", response.body)
	local newVersion = tonumber(string.match(data.path, "versions/(%d+)$")) :: number

	print(`\tRolled back successfully. New version: {newVersion}`)
	return newVersion
end
