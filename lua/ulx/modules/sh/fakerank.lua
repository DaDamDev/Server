local meta = FindMetaTable("Player")

local playerTeam = meta.Team
function meta:Team()
	return self:GetNWString("faketeam", playerTeam(self))
end

local teams = {}
timer.Create("sbv_faketeam", 1, 0, function()
	teams = {}
	
	for k, v in pairs(team.GetAllTeams()) do
		table.insert(teams, v.Name)
	end
end)

if SERVER then
	util.AddNetworkString("sbv_faketeam")

	function meta:SetFakeTeam(id)
		self:SetNWString("faketeam", id)
		self:SetPData("faketeam", id)
	end

	function meta:ResetTeam()
		self:SetNWString("faketeam", nil)
		self:RemovePData("faketeam")

		net.Start("sbv_faketeam")
		net.WriteInt(self:UserID(), 32)
		net.Broadcast()
	end

	hook.Add("PlayerInitialSpawn", "sbv_faketeam", function(ply)
		local faketeam = ply:GetPData("faketeam")

		if faketeam then
			ply:SetFakeTeam(faketeam)
		end
	end)
else
	net.Receive("sbv_faketeam", function()
		local ply = Player(net.ReadInt(32))

		if IsValid(ply) then
			ply:SetNWString("faketeam", nil)
		end
	end)
end

--------------------

function ulx.fakerank(caller, ply, name)
	local name = string.lower(name)
	local id
	
	for k, v in pairs(team.GetAllTeams()) do
		if string.find(string.lower(v.Name), name) then
			name = v.Name
			id = k
			
			break
		end
	end
	
	if not id then
		return ULib.tsay(caller, "Team with name of " .. name .. " does not exist", true)
	end
	
	ply:SetFakeTeam(id)
	
	if caller == ply then
		ULib.tsay(caller, "You have set your rank to " .. name, true)
	else
		ULib.tsay(caller, "You have set the rank of " .. ply:Nick() .. " to " .. name, true)
		ULib.tsay(ply, caller:Nick() .. " has set your rank to " .. name, true)
	end
end

function ulx.resetrank(caller, ply)
	ply:ResetTeam()
	
	if caller == ply then
		ULib.tsay(caller, "You have reset your rank", true)
	else
		ULib.tsay(ply, caller:Nick() .. " has reset your rank", true)
	end
end

local cmd = ulx.command("Utility", "ulx fakerank", ulx.fakerank, "!fakerank")
cmd:addParam{type = ULib.cmds.PlayerArg, ULib.cmds.optional}
cmd:addParam{type = ULib.cmds.StringArg, completes = teams, hint = "rankname"}
cmd:defaultAccess(ULib.ACCESS_SUPERADMIN)
cmd:help("Sets the team of the player to the team matching the given name.")

local cmd = ulx.command("Utility", "ulx resetrank", ulx.resetrank, "!resetrank")
cmd:addParam{type = ULib.cmds.PlayerArg, ULib.cmds.optional}
cmd:defaultAccess(ULib.ACCESS_SUPERADMIN)
cmd:help("Resets the players team to default.")