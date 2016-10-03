local weapons = {} --Allow
weapons["regular"] = {"weapon_physgun","gmod_tool","weapon_pistol","weapon_physcannon","weapon_crowbar","weapon_stunstick","weapon_crossbow","weapon_357","weapon_357","gmod_camera","weapon_fists","none","laserpointer","remotecontroller","torch"}
weapons["player"] = {"weapon_physgun","gmod_tool","gmod_camera","weapon_fists","none","laserpointer","remotecontroller","weapon_crowbar","weapon_physcannon","weapon_pistol","torch"}
weapons["guest"] = {"weapon_physgun","gmod_tool","gmod_camera","weapon_fists","none","laserpointer","remotecontroller","torch","weapon_crowbar"}
weapons["fuckboi"] = {"none"}

local sents = {} --Restrict
sents["regular"] = {"sent_ball"}
sents["player"] = {"sent_ball"}
sents["guest"] = {"mediaplayer_tv", "../spawnicons/models/props/cs_office/tv_plasma", "../spawnicons/models/hunter/plates/plate5x8", "sent_ball"}

local teams = {
	[21] = "owner",
	[22] = "sadmin",
	[23] = "admin",
	[24] = "mod",
	[25] = "trusted",
	[26] = "regular",
	[27] = "player",
	[28] = "guest",
	[29] = "fuckboi"
}

local rest = {
	wep = true
}

local function spawnWep(ply, weapon, swep)
	if rest.wep then
		if !ply:IsValid() then return false end
		
		if weapons[teams[ply:Team()]] then
			local allowed = weapons[teams[ply:Team()]]
			if table.HasValue(allowed, weapon) then
				return true
			end
		else
			return true
		end
		
		ply:ChatPrint("Sorry, you are not allowed to spawn "..weapon)
		return false
	end
end

local function spawnSent(ply, class)
	if !ply:IsValid() then return false end
	
	if sents[teams[ply:Team()]] then
		local restricted = sents[teams[ply:Team()]]
		if not table.HasValue(restricted, class) then
			return true
		end
	else
		return true
	end
	
	ply:ChatPrint("Sorry, you are not allowed to spawn "..class)
	return false
end

hook.Add("PlayerSpawnSWEP", "dadam_restrictions", spawnWep)
hook.Add("PlayerGiveSWEP", "dadam_restrictions", spawnWep)

hook.Add("PlayerSpawnSENT", "dadam_restrictions", spawnSent)

concommand.Add("restrict_wep", function()
	rest.wep = not rest.wep
	for _, ply in ipairs(player.GetAll()) do
		ply:ChatPrint("Weapon restrictions have now been toggled to "..(tostring(rest.wep)))
	end
end)