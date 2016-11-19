if SERVER then
	util.AddNetworkString("dadam_chatmessage_join")
	util.AddNetworkString("dadam_chatmessage_leave")
	
	--join and disconnect
	hook.Add("PlayerInitialSpawn", "dadam_chatmessage_join", function(ply)
		local plys = {}
		
		for k, ply2 in pairs(player.GetAll()) do
			if ply != ply2 then
				table.insert(plys, ply2)
			end
		end
		
		net.Start("dadam_chatmessage_join")
		net.WriteEntity(ply)
		net.Send(plys)
	end)
	
	hook.Add("PlayerDisconnected", "dadam_chatmessage_leave", function(ply)
		net.Start("dadam_chatmessage_leave")
		net.WriteColor(team.GetColor(ply:Team()))
		net.WriteString(ply:GetName())
		net.WriteString(ply:SteamID())
		net.Broadcast()
	end)
else
	--join and disconnect
	net.Receive("dadam_chatmessage_join", function()
		local ply = net.ReadEntity()
		
		if ply then
			chat.AddText(ply, Color(255, 255, 255), " ["..ply:SteamID().."]", Color(100, 100, 255), " Has joined.")
		end
	end)
	
	net.Receive("dadam_chatmessage_leave", function()
		local color = net.ReadColor()
		local ply = net.ReadString()
		local steamid = net.ReadString()
		
		chat.AddText(color, ply, Color(255, 255, 255), " ["..steamid.."]", Color(100, 100, 255), " Has left.")
	end)
	
	--colored names
	local function FindByName(name)
		local pls = player.GetAll()
		for k, v in pairs(pls) do
			if v:Nick() == name then 
				return v 
			end
		end
	end
	
	hook.Add("OnPlayerChat", "dadam_chatmessage_colornames", function(ply, txt, teamChat, isDead)
		local textT = {}
		
		if teamChat then
			table.insert(textT, Color(255, 255, 255))
			table.insert(textT, "[TEAM] ")
		end
		
		if isDead then
			table.insert(textT, Color(255, 0, 0))
			table.insert(textT, "{DEAD} ")
		end
		
		if ply then
			table.insert(textT, team.GetColor(ply:Team()))
			table.insert(textT, ply:Nick())
		else
			table.insert(textT, Color(0, 220, 255))
			table.insert(textT, "Console")
		end
		
		table.insert(textT, Color(255, 255, 255))
		table.insert(textT, ": ")
		
		for i, t in pairs(string.Explode(" ", txt)) do
			if FindByName(t) then
				table.insert(textT, team.GetColor(FindByName(t):Team()))
				table.insert(textT, FindByName(t):Nick())
				table.insert(textT, " ")
				
				if FindByName(t) == LocalPlayer() then
					surface.PlaySound("npc/roller/mine/rmine_chirp_quest1.wav")
				end
			else
				table.insert(textT, Color(255, 255, 255))
				table.insert(textT, t)
				table.insert(textT, " ")
			end
		end
		
		chat.AddText(unpack(textT))
		
		return true
	end)
end