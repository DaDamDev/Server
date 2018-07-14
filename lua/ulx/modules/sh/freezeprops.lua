function ulx.freezeprops(calling_ply, target_plys)
	for _, ply in ipairs(target_plys) do
		for k, ent in pairs(ents.FindByClass("prop_*")) do
			if (CPPI and ent:CPPIGetOwner() or ent) == ply then
				local phys = ent:GetPhysicsObject()

				if IsValid(phys) then
					phys:EnableMotion(false)
				end
			end
		end
	end
	
	ulx.fancyLogAdmin(calling_ply, "#A has frozen the props off #T!", target_plys)
end

local cmd = ulx.command("Utility", "ulx freezeprops", ulx.freezeprops, "!freezeprops")
cmd:addParam{type = ULib.cmds.PlayersArg, ULib.cmds.optional}
cmd:defaultAccess(ULib.ACCESS_ADMIN)
cmd:help("Freezes props of chosen player(s).")