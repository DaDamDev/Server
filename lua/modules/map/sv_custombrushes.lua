--TODO: make this as a file in data folder and a tool to easy add new brushes
local adminOnly = function(ply)
	if not ply:IsSuperAdmin() then
		ply:SetPos(Vector(4096, 1920, 272))
		
		return true
	end
end

local brushes = {
	gm_cloudbuild = {
		teleporter_room = {
			min = Vector(3760, 2048, 272),
			max = Vector(4432, 2560, 432),
			trigger = adminOnly
		}, specialroom1 = {
			min = Vector(5316, 8324, 64),
			max = Vector(6212, 9284, 448),
			trigger = adminOnly
		}, specialroom2 = {
			min = Vector(3268, 8324, 64),
			max = Vector(4164, 9220, 448),
			trigger = function(ply)
				ply:SetNWBool("isminge", true)
			end
		}, specialroom2_teleporter = {
			solid = true,
			min = Vector(3652, 9220, 64),
			max = Vector(3712, 9284, 192)
		}, specialroom3 = {
			min = Vector(1220, 8324, 64),
			max = Vector(2116, 9284, 448),
			trigger = adminOnly
		}, pvp_arena1_team1 = {
			solid = true,
			min = Vector(7064, 8640, 64),
			max = Vector(7128, 8720, 192)
		}, pvp_arena1_team2 = {
			solid = true,
			min = Vector(8424, 8640, 64),
			max = Vector(8488, 8720, 192)
		}, pvp_arena2_team1 = {
			solid = true,
			min = Vector(-14128, 3056, 224),
			max = Vector(-14096, 3088, 344)
		}, pvp_arena2_team2 = {
			solid = true,
			min = Vector(-10096, 7088, 48),
			max = Vector(-10064, 7120, 168)
		}
	}
}

--------------------

local brushes = brushes[game.GetMap()]

local function doAABBOverlap(min1, max1, min2, max2)
	if max1.x < min2.x or min1.x > max2.x then return false end
	if max1.y < min2.y or min1.y > max2.y then return false end
	if max1.z < min2.z or min1.z > max2.z then return false end
	
	return true
end

--------------------

if CUSTOM_BRUSHES_ENTITIES then
	for ent, _ in pairs(CUSTOM_BRUSHES_ENTITIES) do
		if IsValid(ent) then
			ent:Remove()
		end
	end
end

CUSTOM_BRUSHES_ENTITIES = {}

local vertices = {}
for k, brush in pairs(brushes) do
	if brush.solid then
		local ent = ents.Create("func_brush")
		ent:SetModel("models/props_junk/PopCan01a.mdl")
		ent:SetColor(Color(0, 0, 0, 0))
		ent:SetRenderMode(RENDERMODE_TRANSALPHA)
		ent:SetPos(brush.min)
		ent:Spawn()
		ent:PhysicsInitBox(Vector(), brush.max - brush.min)
		ent:SetCollisionBounds(Vector(), brush.max - brush.min)
		ent:SetMoveType(MOVETYPE_NONE)
		ent:SetOwner(Entity(0))
		
		local phys = ent:GetPhysicsObject()
		phys:EnableMotion(false)
		
		CUSTOM_BRUSHES_ENTITIES[ent] = true
	end
end

if brushes then
	hook.Add("PhysgunPickup", "sbv_custombrushes", function(ply, ent)
		if CUSTOM_BRUSHES_ENTITIES[ent] then return false end
	end)
	
	hook.Add("FinishMove", "sbv_custombrushes", function(ply, data)
		local min, max = ply:WorldSpaceAABB()
		
		for k, brush in pairs(brushes) do
			if brush.trigger and doAABBOverlap(min, max, brush.min, brush.max) then
				return brush.trigger(ply)
			end
		end
	end)
end