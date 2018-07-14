--[[local function doAABBOverlap(min1, max1, min2, max2)
	if max1.x < min2.x or min1.x > max2.x then return false end
	if max1.y < min2.y or min1.y > max2.y then return false end
	if max1.z < min2.z or min1.z > max2.z then return false end
	
	return true
end

if SERVER then
	for k, ply in pairs(player.GetAll()) do
		ply:SetCustomCollisionCheck(true)
	end
	
	hook.Add("PlayerInitialSpawn", "sbv_playercollision", function(ply)
		ply:SetCustomCollisionCheck(true)
	end)
end

hook.Add("ShouldCollide", "sbv_playercollision", function(ent1, ent2)
	if (ent1:IsPlayer() or ent2:IsPlayer()) and (ent1:IsRagdoll() or ent2:IsRagdoll()) then
		local min1, max1 = ent1:WorldSpaceAABB()
		local min2, max2 = ent2:WorldSpaceAABB()
		local overlap = doAABBOverlap(min1, max1, min2, max2)
		
		return not overlap
	end
	
	return true
end)]]