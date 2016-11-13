local spawns = {}

local function SetSpawn(ply)
	spawns[ply] = {}
	spawns[ply].pos = ply:GetPos()
	spawns[ply].ang = ply:EyeAngles()
	
	ply:ChatPrint("Your spawn has been set.")
end

local function ResetSpawn(ply)
	if spawns[ply] then
		spawns[ply] = nil
		
		ply:ChatPrint("Your spawn has been reset.")
	else
		ply:ChatPrint("You did not have a spawnpoint set.")
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