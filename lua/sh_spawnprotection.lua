if SERVER then
	util.AddNetworkString("dadam_spawnprotection")
    local god_ply = {}
    local god_time = 2.2125
	
    hook.Add("PlayerShouldTakeDamage", "dadam_spawnprotection", function(ply, attacker)
        return (not IsValid(attacker) or not attacker:IsPlayer() or not attacker:HasGodMode()) and god_ply[ply]
    end)
	
    hook.Add("PlayerSpawn", "dadam_spawnprotection", function(ply)
        --Alert all the clients
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
        local material, white = Material("icon16/shield.png"), Color(255, 255, 255, 255)
		local key = ply:SteamID64()
		
        hook.Add("HUDPaint", "dadam_spawnprotection_"..key, function()
            cam.Start3D()
                render.SetMaterial(material)
                render.DrawSprite(ply:GetPos() + Vector(0, 0, 80), 16, 16, white)
            cam.End3D()
        end)
		
        timer.Simple(god_time,function ()
            hook.Remove("HUDPaint","dadam_spawnprotection_"..key)
        end)
    end)
end
