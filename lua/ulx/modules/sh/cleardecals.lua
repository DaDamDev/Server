function ulx.cleardecals(ply)
	for k, v in pairs(player.GetAll()) do
		v:ConCommand("r_cleardecals")
	end
	ulx.fancyLogAdmin(ply, "#A has cleared all the decals.")
end

local cmd = ulx.command("Utility", "ulx cleardecals", ulx.cleardecals, "!cleardecals")
cmd:defaultAccess(ULib.ACCESS_ADMIN)
cmd:help("Clears decals.")