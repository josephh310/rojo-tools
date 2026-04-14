local net = require("@lune/net")
local process = require("@lune/process")
local serde = require("@lune/serde")

export type PlaceInfo = {
	name: string,
	id: number,
}

return function(universeId: number): { PlaceInfo }
	print(`Fetching places for universe {universeId}`)

	local places: { PlaceInfo } = {}
	local cursor: string? = nil

	repeat
		local url = `https://develop.roblox.com/v1/universes/{universeId}/places?limit=100&sortOrder=Asc`
		if cursor then
			url ..= `&cursor={cursor}`
		end

		local response = net.request({
			url = url,
		})

		if not response.ok then
			warn(`\tFailed to fetch places [{response.statusCode}]\n\t{response.statusMessage}`)
			process.exit(1)
		end

		local data = serde.decode("json", response.body)

		for _, place in data.data do
			table.insert(places, {
				name = place.name,
				id = place.id,
			})
		end

		cursor = data.nextPageCursor
	until not cursor or cursor == ""

	return places
end
