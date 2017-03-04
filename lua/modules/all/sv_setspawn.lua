local spawns = {}

local function SetSpawn(ply)
	spawns[ply] = {}
	spawns[ply].pos = ply:GetPos()
	spawns[ply].ang = ply:EyeAngles()
	
	dadam.Message("Your spawn has been set.", ply)
end

local function ResetSpawn(ply)
	if spawns[ply] then
		spawns[ply] = nil
		
		dadam.Message("Your spawn has been reset.", ply)
	else
		dadam.Message("You did not have a spawnpoint set.", ply)
	end
end

hook.Add("PlayerSpawn", "dadam_setspawn", function(ply)
	if spawns[ply] != nil then
		ply:SetPos(spawns[ply].pos)
		ply:SetEyeAngles(spawns[ply].ang)
	end
end)

hook.Add("PlayerSay", "dadam_setspawn", function(ply, text, public)
	if string.sub(text, 1, 9) == "!setspawn" then
		SetSpawn(ply)
	elseif string.sub(text, 1, 11) == "!resetspawn" then
		ResetSpawn(ply)
	end
end)

--[[local cmd_SetSpawn = ulx.command("Utility", "setspawn", SetSpawn, "!setspawn")
cmd_SetSpawn:defaultAccess(ULib.ACCESS_ALL)
cmd_SetSpawn:help("Sets your spawn.")

local cmd_SetSpawn = ulx.command("Utility", "resetspawn", ResetSpawn, "!resetspawn")
cmd_SetSpawn:defaultAccess(ULib.ACCESS_ALL)
cmd_SetSpawn:help("Resets your spawn.")]]