local type = true

hook.Add("PlayerLoadout", "dadam_pvploadout", function(ply)
	if team.GetName(ply:Team()) == "PvP" || team.GetName(ply:Team()) == "PvP 2" then
		if type then
			ply:Give("fas2_dv2")
		elseif not type then
			ply:Give("weapon_cs_knife")
		end
		
		ply:Give("none")
		
		return true
	end
end)

concommand.Add("pvploadout_type", function()
	type = not type
	
	local name = "fas2"
	
	if not type then
		name = "css"
	end
	
	
	dadam.Message("PvP weaponloadout has been set to "..name)
end)