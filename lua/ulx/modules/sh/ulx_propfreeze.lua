local function GetOwner(ent)
	if CPPI then
		return ent:CPPIGetOwner()
	end
	
	return ent
end

local function PropFreeze(calling_ply, target_plys)
	for _, ply in ipairs(target_plys) do
		for k, v in pairs(ents.FindByClass("prop_*")) do
			if GetOwner(v) == ply then
				local phys = v:GetPhysicsObject()
				if IsValid(phys) then
					phys:EnableMotion(false)
				end
			end
		end
	end
	
	ulx.fancyLogAdmin(calling_ply, "#A has frozen the props off #T!", target_plys)
end

local cmd = ulx.command("Utility", "ulx freezeprops", PropFreeze, "!freezeprops")
cmd:addParam{type = ULib.cmds.PlayersArg}
cmd:defaultAccess(ULib.ACCESS_ADMIN)
cmd:help("Freezes props of chosen player(s).")