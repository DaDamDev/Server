if SERVER then
	
	local categories = {
		smgs = {
			"weapon_cs_mac10",
			"weapon_cs_mp5",
			"weapon_cs_p90",
			"weapon_cs_tmp",
			"weapon_cs_ump"
		}, rifles = {
			"weapon_cs_ak47",
			"weapon_cs_aug",
			"weapon_cs_famas",
			"weapon_cs_galil",
			"weapon_cs_m4",
			"weapon_cs_sig552"
		}, shotguns = {
			"weapon_cs_m3",
			"weapon_cs_xm1014"
		}, sniperrifles = {
			"weapon_cs_awp",
			"weapon_cs_g3",
			"weapon_cs_scout",
			"weapon_cs_sig550"
		}, machineguns = {
			"weapon_cs_para"
		}, pistols = {
			"weapon_cs_deserteagle",
			"weapon_cs_p228",
			"weapon_cs_glock",
			"weapon_cs_fiveseven",
			"weapon_cs_usp",
			"weapon_cs_dualbertta"
		}
	}
	
	local ranking = {}
	local playerRanking = {}
	
	local function giveWeapons(ply)
		ply:StripWeapons()
		
		local knife = ply:Give("weapon_cs_knife")
		
		if playerRanking[ply].rank < 15 then
			ply:Give(playerRanking[ply].weapon)
			ply:SelectWeapon(playerRanking[ply].weapon)
		else
			knife:SetMaterial("models/shiny")
			knife:SetColor(Color(255, 215, 0))
			ply:SelectWeapon("weapon_cs_knife")
		end
	end
	
	pvp.modes.armsrace = {
		name = "Armsrace",
		spawnpoints = pvp.spawnpointPrefabs.ffa,
		hooks = {
			PVPModeStarted = function()
				local catas = table.Copy(categories)
				ranking = {}
				playerRanking = {}
				
				local function add(cata)
					local i = math.random(1, #catas[cata])
					
					table.insert(ranking, catas[cata][i])
					table.remove(catas[cata], i)
				end
				
				add("smgs")
				add("smgs")
				add("smgs")
				add("rifles")
				add("rifles")
				add("rifles")
				add("rifles")
				add("shotguns")
				add("sniperrifles")
				add("machineguns")
				add("pistols")
				add("pistols")
				add("pistols")
				add("pistols")
				
				for k, ply in pairs(player.GetPVP()) do
					playerRanking[ply] = {
						weapon = ranking[1],
						rank = 1
					}
				end
				
				pvp.SetTimerTime(-1) -- Disable timer
			end,
			PVPPlayerJoin = function(ply)
				playerRanking[ply] = {
					weapon = ranking[1],
					rank = 1
				}
			end,
			PVPPlayerLeave = function(ply)
				playerRanking[ply] = nil
			end,
			PlayerDisconnected = function(ply)
				playerRanking[ply] = nil
			end,
			PlayerDeath = function(ply, wep, attacker)
				if not attacker:InPVP() then return end
				local name = attacker:IsPlayer() and attacker:GetName() or "~Magic~"
				
				if wep and wep:GetClass() == "weapon_cs_knife" then
					playerRanking[ply].rank = math.max(playerRanking[ply].rank - 1, 1)
					playerRanking[ply].weapon = ranking[playerRanking[ply].rank]
					
					ply:PVPNotification("You got knifed by " .. name .. " and got set a weapon back!")
				end
				
				if ply == attacker then
					playerRanking[ply].rank = math.max(playerRanking[ply].rank - 1, 1)
					playerRanking[ply].weapon = ranking[playerRanking[ply].rank]
					
					ply:PVPNotification("You died by your own hands and got set a weapon back!")
				else
					local rank = playerRanking[attacker].rank + 1
					playerRanking[attacker].rank = rank
					
					if rank == 15 then
						for k, ply in pairs(player.GetPVP()) do
							ply:PVPNotification(name .. " has reached the golden knife!")
						end
						
						timer.Simple(0, function()
							giveWeapons(attacker)
						end)
					elseif rank == 16 then
						pvp.EndGame()
						
						for k, ply in pairs(player.GetPVP()) do
							ply:PVPNotification(name .. " has won!")
						end
					else
						playerRanking[attacker].weapon = ranking[rank]
						
						timer.Simple(0, function()
							giveWeapons(attacker)
						end)
					end
				end
			end,
			PlayerLoadout = function(ply)
				giveWeapons(ply)
				
				return true
			end
		}
	}
	
else
	
	pvp.modes.armsrace = {
		name = "Armsrace"
	}
	
end