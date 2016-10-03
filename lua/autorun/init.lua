-- TODO: Improve me.
local base = "modules/"
local _, folders = file.Find(base .. "*", "LUA")

for _, folder in pairs(folders) do
	local files = file.Find(base .. folder .. "/*", "LUA")

	for _, file in pairs(files) do
		local pre = file:sub(1, 2)
		local fullPath = base .. folder .. "/" .. file

		if pre == "sv" then
			if SERVER then
				include(fullPath)
			end
		elseif pre == "cl" then
			AddCSLuaFile(fullPath)
			if CLIENT then
				include(fullPath)
			end
		elseif pre == "sh" then
			AddCSLuaFile(fullPath)
			include(fullPath)
		end
	end
end