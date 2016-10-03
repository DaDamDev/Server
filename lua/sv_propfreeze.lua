local function GetOwner(ent)
	if CPPI then
		return ent:CPPIGetOwner()
	end
	
	return ent
end

hook.Add("PlayerSpawnedProp", "dadam_propfreeze", function(ply, model, ent)
	ent:GetPhysicsObject():EnableMotion(false)
end)

--[[hook.Add("OnEntityCreated", "dadam_propfreeze", function(ent)
	timer.Simple(0.001, function()
		--GetOwner(ent):IsPlayer()
		
		if ent == nil or IsValid(ent) == false or GetOwner(ent) == nil then
			if GetOwner(ent) then
				if GetOwner(ent):IsPlayer() == false then
					return
				end
			end
			
			return
		end
		
		local obj = ent:GetPhysicsObject()
		
		if obj != nil and obj:IsValid() and GetOwner(ent) != game.GetWorld() then
			obj:EnableMotion(false)
		end
	end)
end)]]--