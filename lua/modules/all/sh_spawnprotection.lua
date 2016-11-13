if SERVER then
	util.AddNetworkString("dadam_spawnprotection")
	local god_ply = {}
	local god_time = 2.2125
	
	hook.Add("PlayerShouldTakeDamage", "dadam_spawnprotection", function(ply, attacker)
		if (IsValid(attacker) and attacker:IsPlayer() and attacker:HasGodMode()) or god_ply[ply] then
			return false
		else
			return true
		end
	end)
	
	hook.Add("PlayerSpawn", "dadam_spawnprotection", function(ply)
		net.Start("dadam_spawnprotection")
		net.WriteInt(god_time, 32)
		net.WriteEntity(ply)
		net.Broadcast()
		
		god_ply[ply] = true
		timer.Simple(god_time, function()
			god_ply[ply] = nil
			ply:EmitSound("buttons/blip1.wav")
		end)
	end)
else
	net.Receive("dadam_spawnprotection", function()
		local god_time = net.ReadInt(32)
		local ply = net.ReadEntity()
		
		if ply then
			if ply != LocalPlayer() then
				local key = ply:UniqueID()
				
				hook.Add("PostDrawOpaqueRenderables", "dadam_spawnprotection_"..key, function()
					cam.Start3D()
						render.SetMaterial(Material("icon16/shield.png"))
						render.DrawSprite(ply:GetPos() + Vector(0, 0, 80), 16, 16, Color(255, 255, 255, 255))
					cam.End3D()
				end)
				
				timer.Simple(god_time, function()
					hook.Remove("PostDrawOpaqueRenderables", "dadam_spawnprotection_"..key)
				end)
			else
				local fade = 1
				
				timer.Simple(math.Clamp(god_time-0.3, 0.3, 9999), function()
					timer.Create("dadam_spawnprotection_display", 0.015, 20, function()
						fade = fade - 0.1
					end)
				end)
				
				hook.Add("HUDPaint", "dadam_spawnprotection_display", function()
					surface.SetMaterial(Material("icon16/shield.png", "noclamp"))
					surface.SetDrawColor(255, 255, 255, 255 * fade)
					surface.DrawTexturedRect(ScrW()/2 - 16, ScrH()/2 - 16, 32, 32)
				end)
				
				timer.Simple(god_time, function()
					hook.Remove("HUDPaint", "dadam_spawnprotection_display")
				end)
			end
		end
    end)
end
