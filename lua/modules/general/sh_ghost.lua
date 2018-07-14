local ghosts = {}

local isValid = IsValid
function IsValid(ent)
	local valid = isValid(ent)
	
	if not valid then return false end
	if ghosts[ent] then return false end
	
	return true
end

local playerGetAll = player.GetAll
function player.GetAll()
	local players = {}
	
	for k, ply in pairs(playerGetAll()) do
		if not ghosts[ply] then
			table.insert(players, ply)
		end
	end
	
	return players
end

--------------------

if SERVER then
	util.AddNetworkString("sbv_ghost")
	
	local function ghost(ply)
		ghosts[ply] = not ghosts[ply] and true or nil
		
		if ghosts[ply] then
			ply:ChatPrint("You have ghosted yourself")
			
			net.Start("sbv_joinmessage_leave")
			net.WriteColor(team.GetColor(ply:Team()))
			net.WriteString(ply:GetName())
			net.WriteString(ply:SteamID())
			net.Broadcast()
		else
			ply:ChatPrint("You have unghosted yourself")
			
			net.Start("sbv_joinmessage_join")
			net.WriteEntity(ply)
			net.Broadcast()
		end
		
		net.Start("sbv_ghost")
		net.WriteInt(ply:UserID(), 32)
		net.WriteBool(ghosts[ply] and true or false)
		net.Send(playerGetAll())
	end
	
	hook.Add("PlayerSay", "sbv_ghost", function(ply, text)
		if (ply:IsSuperAdmin() or ghosts[ply]) and text == "!ghost" then
			ghost(ply)
			
			return ""
		end
	end)
else
	
	local function setNoDrawPlayerProps(ply, state)
		
	end
	
	----------
	
	net.Receive("sbv_ghost", function()
		local ply = Player(net.ReadInt(32))
		
		if isValid(ply) then
			ghosts[ply] = net.ReadBool()
			
			setNoDrawPlayerProps(ply, true)
		end
	end)
	
	----------
	
	hook.Add("DrawPhysgunBeam", "sbv_ghost", function(ply)
		if ghosts[ply] then return false end
	end)
	
	hook.Add("PrePlayerDraw", "sbv_ghost", function(ply)
		if ghosts[ply] then return true end
	end)
end