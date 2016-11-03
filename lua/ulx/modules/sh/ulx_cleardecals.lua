local function ClearDecals(ply)
	for k, v in pairs(player.GetAll()) do
		v:ConCommand("r_cleardecals")
	end
	ulx.fancyLogAdmin(ply, "#A has cleared all the decals.")
end

local cmd_ClearDecals = ulx.command("Utility", "ulx cleardecals", ClearDecals, "!cleardecals")
cmd_ClearDecals:defaultAccess(ULib.ACCESS_ADMIN)
cmd_ClearDecals:help("Clears decals.")
