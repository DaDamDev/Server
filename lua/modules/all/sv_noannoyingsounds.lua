hook.Add("OnEntityCreated", "dadam_noannoyingsound",function( ent )
	timer.Simple(0, function()
		if IsValid(ent) and ent:GetClass() == "gmod_thruster" then
			ent:SetSound("")
		end
		if IsValid(ent) and (ent:GetClass() == "gmod_wire_thruster" or ent:GetClass() == "gmod_wire_vectorthruster") then
			ent.soundname = Sound("")
		end
		if IsValid(ent) and ent:GetClass() == "gmod_wire_turret" then
			ent.sound = Sound("")
		end
		if IsValid(ent) and ent:GetClass() == "gmod_wire_teleporter" then
			ent.UseSounds = false
		end
	end)
end)