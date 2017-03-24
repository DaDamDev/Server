hook.Add("ForceDermaSkin", "dadam_skin", function()
    if dadam.skin and dadam.skin != "default" then return dadam.skin end
end)

local skins = {
	["white"] = "default",
	["default"] = "default",
	["black"] = "CISKIN",
	["dark"] = "CISKIN"
}

concommand.Add("ddd_skin", function(ply, cmd, args)
	if table.Count(args) == 1 and skins[args[1]] then
		dadam.skin = skins[args[1]]
		
		dadam.saveSettings()
	end
end)