if SERVER then
	
	util.AddNetworkString("sbv_pvp_timer")
	
	local time = -1 -- anything below 0 means that there will be no timer
	local lastTime = 0
	
	function pvp.SetTimerTime(t)
		time = t
		lastTime = CurTime()
		
		net.Start("sbv_pvp_timer")
		net.WriteFloat(time)
		net.Send(player.GetPVP())
	end
	
	function pvp.GetTimerTime()
		return time
	end
	
	hook.Add("Initialize", "sbv_pvp_timer", function()
		pvp.SetTimerTime(-1)
	end)
	
	timer.Create("sbv_pvp_timer", 1, 0, function()
		local time = pvp.GetTimerTime()
		
		if time > 0 then
			local newtime = math.max(time - (CurTime() - lastTime), 0)
			
			pvp.SetTimerTime(newtime)
			
			if newtime == 0 then
				hook.Run("PVPTimerFinish")
			end
		end
	end)
	
else
	
	local time = -1
	
	surface.CreateFont("sbv_pvp_timer", {
		font = "Roboto",
		size = 20,
		weight = 800
	})
	
	net.Receive("sbv_pvp_timer", function()
		time = net.ReadFloat()
	end)
	
	hook.Add("HUDPaint", "sbv_pvp_timer", function()
		if not LocalPlayer():InPVP() or time < 0 then return end
		
		local x = ScrW() / 2
		
		surface.SetDrawColor(50, 50, 50, 150)
		surface.DrawRect(x - 50, 0, 100, 50)
		surface.DrawRect(x - 45, 0, 90, 45)
		
		draw.SimpleText(string.FormattedTime(time, "%02i:%02i"), "sbv_pvp_timer", x, 22.5, Color(220, 220, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end)
	
end