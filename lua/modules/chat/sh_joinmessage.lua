if SERVER then
	util.AddNetworkString("sbv_joinmessage_join")
	util.AddNetworkString("sbv_joinmessage_leave")
	
	hook.Add("PlayerInitialSpawn", "sbv_joinmessage", function(ply)
		local plys = {}
		
		for k, ply2 in pairs(player.GetAll()) do
			if ply ~= ply2 then
				table.insert(plys, ply2)
			end
		end
		
		net.Start("sbv_joinmessage_join")
		net.WriteEntity(ply)
		net.Send(plys)
	end)
	
	hook.Add("PlayerDisconnected", "sbv_joinmessage", function(ply)
		net.Start("sbv_joinmessage_leave")
		net.WriteColor(team.GetColor(ply:Team()))
		net.WriteString(ply:GetName())
		net.WriteString(ply:SteamID())
		net.Broadcast()
	end)
else
	net.Receive("sbv_joinmessage_join", function()
		local ply = net.ReadEntity()
		
		if ply then
			chat.AddText(ply, Color(255, 255, 255), " [" .. ply:SteamID() .. "]", Color(100, 100, 255), " Has joined.")
		end
	end)
	
	net.Receive("sbv_joinmessage_leave", function()
		local color = net.ReadColor()
		local name = net.ReadString()
		local steamid = net.ReadString()
		
		chat.AddText(color, name, Color(255, 255, 255), " [" .. steamid .. "]", Color(100, 100, 255), " Has left.")
	end)
end