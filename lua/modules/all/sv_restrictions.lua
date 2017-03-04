local weapons = {} --Allow
weapons["Regular"] = {"weapon_physgun","gmod_tool","weapon_physcannon","weapon_crowbar","weapon_stunstick","weapon_pistol","weapon_357","gmod_camera","weapon_fists","none","laserpointer","remotecontroller","torch"}
weapons["Player"] = {"weapon_physgun","gmod_tool","weapon_physcannon","gmod_camera","weapon_fists","none","laserpointer","remotecontroller","weapon_crowbar","weapon_physcannon","weapon_pistol","torch"}
weapons["Guest"] = {"weapon_physgun","gmod_tool","gmod_camera","none","laserpointer","remotecontroller"}
weapons["FUCKBOI"] = {"none"}

local sents = {} --Restrict
sents["Regular"] = {"sent_ball", "bt_fred"}
sents["Player"] = {"sent_ball", "bt_fred"}
sents["Guest"] = {"mediaplayer_tv", "../spawnicons/models/props/cs_office/tv_plasma", "../spawnicons/models/hunter/plates/plate5x8", "sent_ball", "bt_fred"}

local rest = {
	wep = true
}

local function spawnWep(ply, weapon, swep)
	if rest.wep then
		if !ply:IsValid() then return false end
		
		if weapons[team.GetName(ply:Team())] then
			local allowed = weapons[team.GetName(ply:Team())]
			if table.HasValue(allowed, weapon) then
				return true
			end
		else
			return true
		end
		
		dadam.Message("Sorry, you are not allowed to spawn "..weapon, ply)
		return false
	end
end

local function spawnSent(ply, class)
	if !ply:IsValid() then return false end
	
	if sents[team.GetName(ply:Team())] then
		local restricted = sents[team.GetName(ply:Team())]
		if not table.HasValue(restricted, class) then
			return true
		end
	else
		return true
	end
	
	dadam.Message("Sorry, you are not allowed to spawn "..class, ply)
	return false
end

hook.Add("PlayerSpawnSWEP", "dadam_restrictions", spawnWep)
hook.Add("PlayerGiveSWEP", "dadam_restrictions", spawnWep)

hook.Add("PlayerSpawnSENT", "dadam_restrictions", spawnSent)

concommand.Add("restrict_wep", function()
	rest.wep = not rest.wep
	dadam.Message("Weapon restrictions have now been toggled to "..(tostring(rest.wep)))
end)

rest.wep = true
