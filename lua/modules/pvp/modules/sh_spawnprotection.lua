local protectionExitDelay = 0.5

--------------------

local meta = FindMetaTable("Player")

function meta:HasSpawnProtection()
	return self:GetNWBool("spawnprotection", false)
end

if SERVER then
	
	--[[local CMoveData = FindMetaTable("CMoveData")
	
	function CMoveData:RemoveKeys(keys)
		local newbuttons = bit.band(self:GetButtons(), bit.bnot(keys))
		self:SetButtons(newbuttons)
	end]]
	
	function meta:SetSpawnProtection(state)
		self:SetNWBool("spawnprotection", state)
	end
	
	----------
	
	local exitKeys = {
		IN_ATTACK,
		IN_FORWARD,
		IN_BACK,
		IN_USE,
		IN_MOVELEFT,
		IN_MOVERIGHT,
		IN_ATTACK2,
		IN_WEAPON1,
		IN_WEAPON2,
		IN_GRENADE1,
		IN_GRENADE2
	}
	
	local blockExit = {}
	
	hook.Add("PlayerSpawn", "sbv_pvp_spawnprotection", function(ply)
		if not ply:InPVP() or ply:IsBot() then return end
		
		ply:GodEnable()
		ply:SetSpawnProtection(true)
		ply:SetColor(Color(50, 100, 255))
		
		for k, key in pairs(exitKeys) do
			if ply:KeyDown(key) then
				blockExit[key] = true
			end
		end
		
	end)
	
	--Stills allows to shoot, plz help
	hook.Add("SetupMove", "sbv_pvp_spawnprotection", function(ply, data, cmd)
		if not ply:HasSpawnProtection() then return end
		
		local new = {}
		for key, v in pairs(blockExit) do
			if data:KeyDown(key) then
				--data:RemoveKeys(key)
				
				new[key] = true
			end
		end
		blockExit = new
		
		for k, key in pairs(exitKeys) do
			if data:KeyDown(key) and not blockExit[key] then
				ply:SetSpawnProtection(false)
				
				timer.Simple(protectionExitDelay, function()
					ply:GodDisable()
					ply:SetColor(Color(255, 255, 255))
				end)
			end
		end
	end)
	
else
	
	local scale = 1
	
	hook.Add("RenderScreenspaceEffects", "sbv_pvp_spawnprotection", function()
		local lp = LocalPlayer()
		
		if not lp:InPVP() then return end
		if not lp:HasSpawnProtection() then
			if scale > 0 then
				scale = math.max(scale - FrameTime() * (1 / protectionExitDelay), 0)
			end
		else
			scale = 1
		end
		
		DrawColorModify({
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = -scale*0.2,
			["$pp_colour_contrast"] = 1 - scale*0.6,
			["$pp_colour_colour"] = 1 - scale*0.8,
			["$pp_colour_mulr"] = scale*0.05,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		})
	end)
	
end