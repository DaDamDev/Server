local meta = FindMetaTable("Player")

function meta:InPVP()
	return self:GetNWBool("inpvp", false)
end

function meta:GetPVPLoadout()
	return util.JSONToTable(self:GetNWString("pvploadout", "[]"))
end

function player.GetPVP()
	local plys = {}
	
	for k, ply in pairs(player.GetAll()) do
		if ply:InPVP() then
			table.insert(plys, ply)
		end
	end
	
	return plys
end

if SERVER then
	function meta:SetPVP(state)
		self:SetNWBool("inpvp", state)
		self:KillSilent()
		
		if state then
			hook.Run("PVPPlayerJoin", self)
		else
			hook.Run("PVPPlayerLeave", self)
			
			self:UnLock()
		end
	end
	
	function meta:SetPVPLoadout(loadout)
		self:SetNWString("pvploadout", util.TableToJSON(loadout))
	end
	
	-- Testing, change to ulx cmd later
	hook.Add("PlayerSay", "sbv_pvp", function(ply, text)
		if text == "!pvp" then
			ply:SetPVP(not ply:InPVP())
			
			ply:ChatPrint("Your pvp status is now " .. tostring(ply:InPVP()))
		end
	end)
	
end

--------------------

pvp = {
	arena = "arena1",
	modes = {},
	currentMode,
	currentModeName,
	timeLeft = 0,
	supportedMaps = {
		gm_cloudbuild = true
	}, spawnpointPrefabs = {
		ffa = {
			gm_cloudbuild = {
				arena1 = {
					Vector(7816, 8192, 64),
					Vector(7816, 8128, 64),
					Vector(7816, 8064, 64),
					Vector(7720, 8064, 64),
					Vector(7720, 8128, 64),
					Vector(7720, 8192, 64),
					Vector(7720, 9152, 64),
					Vector(7720, 9216, 64),
					Vector(7720, 9280, 64),
					Vector(7816, 9152, 64),
					Vector(7816, 9216, 64),
					Vector(7816, 9280, 64),
					Vector(8056, 8896, 64),
					Vector(7496, 8896, 64),
					Vector(8136, 8448, 64),
					Vector(8136, 8896, 64),
					Vector(7416, 8896, 64),
					Vector(7416, 8448, 64),
					Vector(7960, 9024, 256),
					Vector(7992, 8992, 256),
					Vector(8024, 8960, 256),
					Vector(8056, 8928, 256),
					Vector(7960, 8320, 256),
					Vector(7992, 8352, 256),
					Vector(8024, 8384, 256),
					Vector(8056, 8416, 256),
					Vector(7928, 8288, 256),
					Vector(7928, 9056, 256),
					Vector(7624, 9056, 256),
					Vector(7592, 9024, 256),
					Vector(7560, 8992, 256),
					Vector(7528, 8960, 256),
					Vector(7496, 8928, 256),
					Vector(7624, 8288, 256),
					Vector(7592, 8320, 256),
					Vector(7560, 8352, 256),
					Vector(7528, 8384, 256),
					Vector(7496, 8416, 256),
					Vector(7416, 8384, 64),
					Vector(7416, 8320, 64),
					Vector(7416, 8256, 64),
					Vector(7416, 8960, 64),
					Vector(7416, 9024, 64),
					Vector(7416, 9088, 64),
					Vector(8136, 8960, 64),
					Vector(8136, 9024, 64),
					Vector(8136, 9088, 64),
					Vector(8136, 8384, 64),
					Vector(8136, 8320, 64),
					Vector(8136, 8256, 64),
					Vector(7160, 9280, 64),
					Vector(7160, 9216, 64),
					Vector(7160, 9152, 64),
					Vector(7224, 9280, 64),
					Vector(7288, 9280, 64),
					Vector(7160, 8064, 64),
					Vector(7160, 8128, 64),
					Vector(7160, 8192, 64),
					Vector(7224, 8064, 64),
					Vector(7288, 8064, 64),
					Vector(8392, 8064, 64),
					Vector(8392, 8128, 64),
					Vector(8392, 8192, 64),
					Vector(8328, 8064, 64),
					Vector(8264, 8064, 64),
					Vector(8392, 9280, 64),
					Vector(8392, 9216, 64),
					Vector(8392, 9152, 64),
					Vector(8328, 9280, 64),
					Vector(8264, 9280, 64),
					Vector(8392, 8680, 64),
					Vector(8392, 8616, 64),
					Vector(8392, 8744, 64),
					Vector(7160, 8680, 64),
					Vector(7160, 8744, 64),
					Vector(7160, 8616, 64),
					Vector(7704, 8448, 64),
					Vector(7768, 8448, 64),
					Vector(7832, 8448, 64),
					Vector(7768, 8896, 64),
					Vector(7832, 8896, 64),
					Vector(7704, 8896, 64),
					Vector(7640, 8896, 64),
					Vector(7896, 8896, 64),
					Vector(7960, 8896, 64),
					Vector(7576, 8896, 64),
					Vector(7640, 8448, 64),
					Vector(7576, 8448, 64),
					Vector(7896, 8448, 64),
					Vector(7960, 8448, 64),
					Vector(8024, 8448, 64),
					Vector(7512, 8448, 64)
				}
			}
		}
	}
}

local map = game.GetMap()
if not pvp.supportedMaps[map] then return print("PVP wont be running, map is not supported") end

if SERVER then
	
	util.AddNetworkString("sbv_pvp_startmode")
	
	function pvp.StartMode(mode)
		pvp.currentMode = pvp.modes[mode]
		pvp.currentModeName = mode
		
		hook.Run("PVPModeStarted", mode)
		
		for k, ply in pairs(player.GetPVP()) do
			ply:UnLock()
			
			if ply:Alive() then
				ply:KillSilent()
			end
			
			ply:Spawn()
		end
		
		timer.Simple(0.1, function()
			for k, ply in pairs(player.GetPVP()) do
				ply:Lock()
			end
		end)
		
		timer.Simple(5, function()
			for k, ply in pairs(player.GetPVP()) do
				ply:UnLock()
			end
		end)
		
		net.Start("sbv_pvp_startmode")
		net.WriteString(mode)
		net.Send(player.GetPVP())
	end
	
	function pvp.StartRandomMode()
		local mode
		
		while mode ~= pvp.currentModeName do
			mode = table.GetKeys(pvp.modes)[math.random(1, table.Count(pvp.modes))]
		end
		
		pvp.StartMode(mode)
	end
	
	function pvp.EndGame()
		for k, ply in pairs(player.GetPVP()) do
			ply:Lock()
		end
		
		timer.Simple(5, function()
			pvp.StartRandomMode()
		end)
	end
	
	--------------------
	
	hook.Add("PVPPlayerJoin", "sbv_pvp", function(ply)
		net.Start("sbv_pvp_startmode")
		net.WriteString(pvp.currentModeName)
		net.Send(ply)
	end)
	
	hook.Add("Initialize", "sbv_pvp", function()
		pvp.StartRandomMode()
	end)
	
	-- Disable ulx cmds when in pvp unless player is admin or superadmin
	hook.Add("ULibCommandCalled", "sbv_pvp", function(ply)
		if ply:InPVP() and (not ply:IsAdmin() and not ply:IsSuperAdmin()) then return false end
	end)
	
	--------------------
	
	-- Disallow the spawning of anything while in pvp
	local function disallow(ply)
		if not ply:InPVP() then return end
		return false
	end
	
	hook.Add("PlayerSpawnEffect", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerSpawnNPC", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerSpawnObject", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerSpawnProp", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerSpawnRagdoll", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerSpawnSENT", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerSpawnSWEP", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerSpawnVehicle", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerGiveSWEP", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerNoClip", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerCanPickupItem", "sbv_pvp_disallow", disallow)
	hook.Add("PlayerCanPickupWeapon", "sbv_pvp_disallow", disallow)
	
	-- Mode hooks
	local function setupModeHook(hookName)
		hook.Add(hookName, "sbv_pvp_mode", function(...)
			if not pvp.currentMode or not pvp.currentMode.hooks[hookName] then return end
			
			return pvp.currentMode.hooks[hookName](...)
		end)
	end
	
	local function setupModeHookPlayer(hookName)
		hook.Add(hookName, "sbv_pvp_mode", function(ply, ...)
			if not ply:InPVP() or not pvp.currentMode or not pvp.currentMode.hooks[hookName] then return end
			
			return pvp.currentMode.hooks[hookName](ply, ...)
		end)
	end
	
	hook.Add("PlayerSpawn", "sbv_pvp", function(ply)
		if not pvp.currentMode or not ply:InPVP() then return end
		
		local points = pvp.currentMode.spawnpoints[map][pvp.arena]
		
		for i = 1, 10 do
			local point = points[math.random(1, #points)]
			
			local tr = util.TraceHull({
				start = point,
				endpos = point + Vector(0, 0, 72),
				filter = Entity(0),
				mins = Vector(-32, -32, -32),
				maxs = Vector(32, 32, 32),
				mask = MASK_ALL
			})
			
			if not tr.Hit or i == 10 then
				ply:SetPos(point)
				
				break
			end
		end
		
		if not pvp.currentMode.hooks.PlayerSpawn then return end
		return pvp.currentMode.hooks[hookName](ply)
	end)
	
	setupModeHookPlayer("PlayerLoadout")
	setupModeHookPlayer("PlayerDisconnected")
	setupModeHookPlayer("PlayerDeath")
	setupModeHook("PVPModeStarted")
	setupModeHook("PVPPlayerJoin")
	setupModeHook("PVPPlayerLeave")
	setupModeHook("PVPTimerFinish")
	
else
	
	net.Receive("sbv_pvp_startmode", function()
		local mode = net.ReadString()
		
		pvp.currentMode = pvp.modes[mode]
		
		hook.Run("PVPModeStarted", mode)
		
		pvp.DisableTimer()
		LocalPlayer():PVPNotification(pvp.currentMode.name .. " has started!")
	end)
	
	--------------------
	
	-- Disallow the spawning of anything while in pvp
	local function disallow(ply)
		if not ply:InPVP() then return end
		return false
	end
	
	hook.Add("PlayerNoClip", "sbv_pvp", disallow)
	
end