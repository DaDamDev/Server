----- Module Loader -----
local function loadFolder(path)
	local files, dirs = file.Find(path .. "*", "LUA")
	
	for k, file in pairs(files) do
		local pre = string.sub(file, 1, 2)
		local fullPath = path .. file
		
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
	
	for k, dir in pairs(dirs) do
		loadFolder(path .. dir .. "/")
	end
end

loadFolder("modules/")