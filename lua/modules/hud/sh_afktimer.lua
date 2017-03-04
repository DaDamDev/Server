if SERVER then
	--util.AddNetworkString("dadam_afktimer")
	
	local time = {}
	
	hook.Add("KeyPress", "dadam_afktimer", function(ply, key)
		time[ply] = 0
	end)
	
	timer.Create("dadam_afktimer", 1, 0, function()
		for k, ply in pairs(player.GetAll()) do
			time[ply] = (time[ply] or 0)+1
			
			ply:SetNWInt("dadam_afktimer", time[ply])
		end
	end)
else
	local time = {}
	
	surface.CreateFont("dadam_afktimer_font", {
		font = "Trebuchet24",
		size = 15,
		weight = 1000
	} )
	
	function FancyTime(timeg)
	    local timer = {}
	    
	    timer.hour = math.floor(timeg/60/60)
	    timer.min = math.floor(timeg/60) - math.floor(timeg/60/60)*60
	    timer.sec = math.floor(timeg) - math.floor(timeg/60)*60
	    
	    if timer.min < 10 then
	    	timer.min = "0"..timer.min
    	end
    	if timer.sec < 10 then
	    	timer.sec = "0"..timer.sec
    	end
	    
	    return (timer.hour..":"..timer.min..":"..timer.sec)
	end
	
	timer.Create("dadam_afktimer", 0.8, 0, function()
		for k, ply in pairs(player.GetAll()) do
			time[ply] = ply:GetNWInt("dadam_afktimer") or 0
		end
	end)
	
	hook.Add("ULibLocalPlayerReady", "dadam_afktimer", function(plyrdy)
		hook.Add("HUDPaint", "dadam_afktimer", function()
			local lpp = LocalPlayer():GetPos()
			
			if table.Count(time) > 0 then
				for ply, t in pairs(time) do
					if table.HasValue(player.GetAll(), ply) then
						if ply != LocalPlayer() and time[ply] > 60 and not ply:IsBot() then
							local plyp = ply:GetPos()
							local dist = math.sqrt((lpp.x - (plyp.x))^2 + (lpp.y - (plyp.y))^2 + (lpp.z - (plyp.z))^2)
							local color = ColorAlpha(Color(255, 0, 0), (1000-dist))
							
							draw.DrawText("AFK: "..FancyTime(t), "dadam_afktimer_font", ply:EyePos():ToScreen().x, (ply:EyePos() + Vector(0, 0, 25-dist/20)):ToScreen().y, color, TEXT_ALIGN_CENTER)
						end
					end
				end
			end
		end)
	end)
end
