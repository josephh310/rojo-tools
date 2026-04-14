local net = require("@lune/net")
local process = require("@lune/process")
local serde = require("@lune/serde")
local fetchSecret = require("./fetchSecret")

export type VersionInfo = {
	versionNumber: number,
	createTime: string,
}

return function(assetId: number, maxResults: number?): { VersionInfo }
	print(`Fetching versions for asset {assetId}`)

	local versions: { VersionInfo } = {}
	local pageToken: string? = nil
	local limit = maxResults or 50

	repeat
		local url = `https://apis.roblox.com/assets/v1/assets/{assetId}/versions?maxPageSize=50`
		if pageToken then
			url ..= `&pageToken={pageToken}`
		end

		local response = net.request({
			url = url,
			headers = {
				["x-api-key"] = fetchSecret("OPEN_CLOUD_KEY"),
			},
		})

		if not response.ok then
			warn(`\tFailed to fetch versions [{response.statusCode}]\n\t{response.statusMessage}`)
			process.exit(1)
		end

		local data = serde.decode("json", response.body)

		for _, version in data.assetVersions do
			table.insert(versions, {
				versionNumber = tonumber(string.match(version.path, "versions/(%d+)$")) :: number,
				createTime = version.createTime,
			})

			if #versions >= limit then
				break
			end
		end

		pageToken = data.nextPageToken
	until not pageToken or pageToken == "" or #versions >= limit

	return versions
end
