hook.Add("PlayerSpawn", "sbv_customspawn", function(ply)
	if ply.customspawn then
		ply:SetPos(ply.customspawn.pos)
		ply:SetAngles(ply.customspawn.ang)
	end
end)

function ulx.setspawn(caller, ply)
	ply.customspawn = {
		pos = ply:GetPos(),
		ang = ply:GetAngles()
	}
	
	ulx.fancyLogAdmin(caller, "#A has set the spawn of #T!", plys)
end

function ulx.resetspawn(caller, ply)
	ply.customspawn = nil
	
	ulx.fancyLogAdmin(caller, "#A has reset the spawn of #T!", plys)
end

local cmd = ulx.command("Fun", "ulx setspawn", ulx.setspawn, "!setspawn", true)
cmd:addParam{type = ULib.cmds.PlayerArg, ULib.cmds.optional}
cmd:defaultAccess(ULib.ACCESS_ALL)
cmd:help("Sets a custom spawn.")

local cmd = ulx.command("Fun", "ulx resetspawn", ulx.resetspawn, "!resetspawn", true)
cmd:addParam{type = ULib.cmds.PlayerArg, ULib.cmds.optional}
cmd:defaultAccess(ULib.ACCESS_ALL)
cmd:help("Resets the custom spawn.")