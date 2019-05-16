if SERVER then
	
	local scores = {}
	local roundtime = 305 -- 5 seconds extra cuz of freezetime
	
	pvp.modes.ffa = {
		name = "FFA",
		loadoutmenu = {}, -- Empty to enable loadoutmenu but not override default settings
		spawnpoints = pvp.spawnpointPrefabs.ffa,
		hooks = {
			PVPModeStarted = function()
				scores = {}
				
				for k, ply in pairs(player.GetPVP()) do
					scores[ply] = 0
				end
				
				pvp.SetTimerTime(roundtime)
			end,
			PVPTimerFinish = function()
				local p = nil
				local s = -1
				
				for ply, score in pairs(scores) do
					if score > s then
						p = ply
						s = score
					end
				end
				
				pvp.EndGame()
				
				if p then
					for k, ply in pairs(player.GetPVP()) do
						ply:PVPNotification(p:GetName() .. " has won!")
					end
				end
			end,
			PVPPlayerJoin = function(ply)
				scores[ply] = 0
			end,
			PVPPlayerLeave = function(ply)
				scores[ply] = nil
			end,
			PlayerDisconnected = function(ply)
				scores[ply] = nil
			end,
			PlayerDeath = function(ply, wep, attacker)
				if ply ~= attacker then
					scores[attacker] = scores[attacker] + 1
				end
			end,
			PlayerSpawn = function(ply)
				ply:PVPNotification("Select your loadout by holding Q!")
			end,
			PlayerLoadout = function(ply)
				local loadout = ply:GetPVPLoadout()
				
				ply:Give("weapon_cs_knife")
				
				for k, wep in pairs(loadout) do
					ply:Give(wep)	
				end
				
				if #loadout > 0 then
					ply:SelectWeapon(loadout[#loadout])
				end
				
				return true
			end
		}
	}
	
else
	
	pvp.modes.ffa = {
		name = "FFA",
		loadoutmenu = {}
	}
	
end