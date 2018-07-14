hook.Add("PlayerSpawnedProp", "sbv_propfreeze", function(ply, model, ent)
	ent:GetPhysicsObject():EnableMotion(false)
end)