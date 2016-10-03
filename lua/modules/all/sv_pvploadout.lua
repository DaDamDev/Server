hook.Add("PlayerLoadout", "dadam_pvploadout", function(ply)
	if team.GetName(ply:Team()) == "PvP" then
		ply:Give("weapon_cs_knife")
		
		return true
	end
end)