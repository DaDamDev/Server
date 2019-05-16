--TODO: make this as a file in data folder and a tool to easy add new brushes
local function leavePVP(ply)
	if not ply:IsPlayer() then return end
	
	ply:SetPos(Vector())
	ply:SetPVP(false)
	ply:PVPNotification("You have left pvp.")
	
	return true
end

local function pvpersOnly(ply)
	if not ply:IsPlayer() or ply:InPVP() then return end
	
	ply:SetPos(Vector())
	ply:KillSilent()
	ply:PVPNotification("Only those who are currently in pvp are allowed here.")
	
	return true
end

local brushes = {
	gm_cloudbuild = {
		teleporters_pvp = {
			min = Vector(4328, 2192, 272),
			max = Vector(4392, 2392, 416),
			trigger = function(ply)
				if not ply:IsPlayer() then return end
				
				ply:SetPos(Vector(4096, 1920, 272))
				ply:SetPVP(true)
				
				return true
			end
		},
		
		--PVP Arena 1
		pvp_arena1 = {
			min = Vector(7128, 8032, 64),
			max = Vector(8424, 9312, 448),
			trigger = pvpersOnly
		}, pvp_arena1_team1_teleporter = {
			--solid = true,
			min = Vector(7064, 8640, 64),
			max = Vector(7128, 8720, 192),
			trigger = leavePVP
		}, pvp_arena1_team2_teleporter = {
			--solid = true,
			min = Vector(8424, 8640, 64),
			max = Vector(8488, 8720, 192),
			trigger = leavePVP
		},
		
		--PVP Arena 2
		pvp_arena2 = {
			min = Vector(-14160, 3024, 48),
			max = Vector(-10064, 7120, 1536),
			trigger = pvpersOnly
		}, pvp_arena2_team1_teleporter = {
			--solid = true,
			min = Vector(-14128, 3056, 224),
			max = Vector(-14092, 3092, 352),
			trigger = leavePVP
		}, pvp_arena2_team2_teleporter = {
			--solid = true,
			min = Vector(-10100, 7084, 48),
			max = Vector(-10064, 7120, 172),
			trigger = leavePVP
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

hook.Add("Initialize", "sbv_custombrushes", function()
	timer.Simple(5, function()
		for k, brush in pairs(brushes) do
			if brush.solid then
				local ent = ents.Create("prop_physics")
				ent:SetModel("models/hunter/blocks/cube025x025x025.mdl")
				ent:SetRenderMode(RENDERMODE_ENVIROMENTAL)
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
	end)
end)

if brushes then
	hook.Add("PhysgunPickup", "sbv_custombrushes", function(ply, ent)
		if ent:CPPIGetOwner() == Entity(0) then return false end -- Disallow pickup of any world entities
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