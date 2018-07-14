local meta = FindMetaTable("Player")

local playerName = meta.GetName
function meta:GetName()
	return self:GetNWString("fakename", playerName(self))
end

meta.Nick = meta.GetName
meta.Name = meta.GetName

if SERVER then
	util.AddNetworkString("sbv_fakename")

	function meta:SetFakeName(name)
		self:SetNWString("fakename", name)
		self:SetPData("fakename", name)
	end

	function meta:ResetName()
		self:SetNWString("fakename", nil)
		self:RemovePData("fakename")

		net.Start("fakename")
		net.WriteInt(self:UserID(), 32)
		net.Broadcast()
	end

	hook.Add("PlayerInitialSpawn", "sbv_fakename", function(ply)
		local fakename = ply:GetPData("fakename")

		if fakename then
			ply:SetFakeName(fakename)
		end
	end)
else
	net.Receive("sbv_fakename", function()
		local ply = Player(net.ReadInt(32))

		if IsValid(ply) then
			ply:SetNWString("fakename", nil)
		end
	end)
end

--------------------

function ulx.fakename(caller, ply, name)
	if caller == ply then
		ULib.tsay(caller, "You have set your name to " .. name, true)
	else
		ULib.tsay(caller, "You have set the name of " .. ply:Nick() .. " to " .. name, true)
		ULib.tsay(ply, caller:Nick() .. " has set your name to " .. name, true)
	end
	
	ply:SetFakeName(name)
end

function ulx.resetname(caller, ply)
	ply:ResetName()
	
	if caller == ply then
		ULib.tsay(caller, "You have reset your name", true)
	else
		ULib.tsay(ply, caller:Nick() .. " has reset your name", true)
	end
end

local cmd = ulx.command("Utility", "ulx fakename", ulx.fakename, "!fakename", true)
cmd:addParam{type = ULib.cmds.PlayerArg, ULib.cmds.optional}
cmd:addParam{type = ULib.cmds.StringArg, hint = "name"}
cmd:defaultAccess(ULib.ACCESS_SUPERADMIN)
cmd:help("Gives a fake name.")

local cmd = ulx.command("Utility", "ulx resetname", ulx.resetname, "!resetname", true)
cmd:addParam{type = ULib.cmds.PlayerArg, ULib.cmds.optional}
cmd:defaultAccess(ULib.ACCESS_SUPERADMIN)
cmd:help("Clears the fake name.")