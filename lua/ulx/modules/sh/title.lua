if SERVER then
	util.AddNetworkString("sbv_title")
	
	hook.Add("PlayerInitialSpawn", "sbv_fakename", function(ply)
		local title = ply:GetPData("title", nil)
		
		if title then
			ply:SetNWString("title", title)
		end
	end)
else
	net.Receive("sbv_title", function()
		local ply = Player(net.ReadInt(32))
		
		if IsValid(ply) then
			ply:SetNWString("title", nil)
		end
	end)
end

--------------------

function ulx.title(ply)
	local title = ply:GetNWString("title", nil)
	
	if title then
		ply:ChatPrint("Your current title is: '" .. title .. "'")
	else
		ply:ChatPrint("You don't have a title")
	end
end

function ulx.settitle(ply, title)
	local title = string.sub(title, 1, 32)
	
	ply:SetNWString("title", title)
	ply:SetPData("title", title)
	ply:ChatPrint("Your title has been set to '" .. title .. "'")
end

function ulx.cleartitle(ply)
	ply:SetNWString("title", nil)
	ply:RemovePData("title")
	ply:ChatPrint("Your title has been cleared")
	
	net.Start("sbv_title")
	net.WriteInt(ply:UserID(), 32)
	net.Broadcast()
end

local cmd = ulx.command("Fun", "ulx title", ulx.title, "!title")
cmd:defaultAccess(ULib.ACCESS_ALL)
cmd:help("Shows your current title.")

local cmd = ulx.command("Fun", "ulx settitle", ulx.settitle, "!settitle")
cmd:addParam{type = ULib.cmds.StringArg, hint = "title", ULib.cmds.takeRestOfLine}
cmd:defaultAccess(ULib.ACCESS_ALL)
cmd:help("Sets your title.")

local cmd = ulx.command("Fun", "ulx cleartitle", ulx.cleartitle, "!cleartitle")
cmd:defaultAccess(ULib.ACCESS_ALL)
cmd:help("Clears your title.")