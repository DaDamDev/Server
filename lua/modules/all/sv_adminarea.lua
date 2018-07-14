-- Admin only area

if game.GetMap() ~= "gm_cloudbuild" then return end

local areas = {
	{
		min = Vector(5313, 8322, 72),
		max = Vector(6262, 9268, 621),
	}
}

local isInArea = {}


hook.Add("Move", "sbv_Area_Blocker", function(ply, mv)
	local isInside = false
	for _, box in ipairs(areas) do
		local e = ents.FindInBox(box.min, box.max)
		if table.HasValue(e, ply) then
			isInside = true
			break
		end
	end
	
	if isInside and not isInArea[ply] then
		isInArea[ply] = true
		if not ply:IsSuperAdmin() then
			mv:SetOrigin(Vector(3978, 2151, 336))
			ply:SetEyeAngles(Angle(0, 180, 0))
			ply:ChatPrint("This room is only for admins.")
			
			mv:SetVelocity(Vector(0, 0, 0))
			
			return true
		end
		return false
	elseif isInArea[ply] and not isInside then
		isInArea[ply] = false
		return false
	end
	

end)
