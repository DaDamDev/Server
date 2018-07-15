if game.GetMap() ~= "gm_cloudbuild" then return end

local spawnpoints = {
	Vector(8528, -192, 608),
	Vector(8528, -128, 608),
	Vector(8528, -64, 608),
	Vector(8464, -64, 608),
	Vector(8464, -128, 608),
	Vector(8464, -192, 608),
	Vector(8400, -192, 608),
	Vector(8400, -160, 608),
	Vector(8400, -128, 608),
	Vector(8400, -64, 608),
	Vector(8336, -64, 608),
	Vector(8336, -128, 608),
	Vector(8336, -192, 608),
	Vector(8272, -192, 608),
	Vector(8272, -128, 608),
	Vector(8272, -64, 608),
	Vector(8208, -64, 608),
	Vector(8208, -128, 608),
	Vector(8208, -192, 608),
	Vector(8144, -192, 608),
	Vector(8144, -128, 608),
	Vector(8144, -64, 608),
	Vector(8152, 0, 608),
	Vector(8208, 0, 608),
	Vector(8272, 0, 608),
	Vector(8336, 0, 608),
	Vector(8400, 0, 608),
	Vector(8464, 0, 608),
	Vector(8528, 0, 608),
	Vector(8528, 64, 608),
	Vector(8464, 64, 608),
	Vector(8400, 64, 608),
	Vector(8336, 64, 608),
	Vector(8272, 64, 608),
	Vector(8208, 64, 608),
	Vector(8144, 64, 608),
	Vector(8592, 64, 608),
	Vector(8592, 0, 608),
	Vector(8592, -64, 608),
	Vector(8592, -128, 608),
	Vector(8592, -192, 608),
}



hook.Add("PlayerSpawn", "sbv_MapSpawn", function(ply)
	if not ply.customspawn and not ply:InPVP() then
		ply:SetPos(spawnpoints[math.random(#spawnpoints)])
	end
end)
