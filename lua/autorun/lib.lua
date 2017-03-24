dadam = dadam or {}

if SERVER then
	util.AddNetworkString("dadam_message")

	function dadam.Message(msg, ply)
		net.Start("dadam_message")
			net.WriteString(msg)
		if ply then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end
else
	-- Small capitalized "DDDEV"
	local dddev = string.char(225, 180, 133, 225, 180, 133, 225, 180, 133, 225, 180, 135, 225, 180, 160)
	
	function dadam.Message(msg)
		surface.PlaySound("npc/roller/mine/rmine_chirp_quest1.wav")
		chat.AddText(Color(141, 184, 197), dddev, Color(255, 255, 255), ": " .. msg)
	end

	net.Receive("dadam_message", function()
		dadam.Message(net.ReadString())
	end)
end
