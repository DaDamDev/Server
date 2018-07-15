function ulx.revive(caller, plys)
	for k, ply in pairs(plys) do
		if not ply:InPVP() then
			local pos = ply:GetPos()
			
			if not ply:Alive() then
				ply:Spawn()
				ply:SetPos(pos)
			end
		end
	end
	
	ulx.fancyLogAdmin(caller, "#A has brought #T back from the dead!", plys)
end

local cmd = ulx.command("Fun", "ulx revive", ulx.revive, "!revive", true)
cmd:addParam{type = ULib.cmds.PlayersArg, ULib.cmds.optional}
cmd:defaultAccess(ULib.ACCESS_ALL)
cmd:help("Brings the player back from the dead.")