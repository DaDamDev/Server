hook.Add("PlayerDeath", "sbv_corpse", function(ply)
	ply:GetRagdollEntity():Remove()
	
	local ragdoll = ents.Create("prop_ragdoll")
	ragdoll:SetModel(ply:GetModel())
	ragdoll:SetPos(ply:GetPos())
	ragdoll:SetMoveType(MOVETYPE_VPHYSICS)
	ragdoll:Spawn()
	ragdoll:SetOwner(ply)
	ragdoll:AddCallback("PhysicsCollide", function(ent, data)
		if data.Speed > 60 then
			local effectdata = EffectData()
			effectdata:SetOrigin(data.HitPos)
			
			util.Decal("Blood", data.HitPos, data.HitPos + (data.HitPos - ent:GetPos()):GetNormalized())
			util.Effect("BloodImpact", effectdata, true, true)
		end
	end)
	
	ply:SpectateEntity(ragdoll)
	ply:SetVelocity(Vector())
	
	local vel = ply:GetVelocity()
	for i = 0, ply:GetBoneCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum(i)
		
		if IsValid(bone) then
			local pos, ang = ply:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
			
			if pos and ang then
				bone:SetPos(pos)
				bone:SetAngles(ang)
			end
			
			bone:SetVelocity(vel)
		end
	end
	
	
	ply.corpse = ragdoll
end)

local function removeBody(ply)
	if ply.corpse and IsValid(ply.corpse) then
		ply:UnSpectate()
		
		ply.corpse:Remove()
		ply.corpse = nil
	end
end

hook.Add("PlayerSpawn", "sbv_corpse", removeBody)
hook.Add("PlayerDisconnected", "sbv_corpse", removeBody)