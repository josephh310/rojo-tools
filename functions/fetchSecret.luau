local fs = require("@lune/fs")

return function(key: string): string
	local contents = fs.readFile(".env")

	for line in string.gmatch(contents, "[^\r\n]+") do
		local k, v = string.match(line, "^([%w_]+)%s*=%s*(.+)$")
		if v and k == key then
			return (string.gsub(v, "%s+$", ""))
		end
	end

	error(`Could not find key "{key}" in .env`)
end
