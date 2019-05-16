local meta = FindMetaTable("Player")

if SERVER then
	
	util.AddNetworkString("sbv_pvp_notification")
	
	function meta:PVPNotification(text)
		net.Start("sbv_pvp_notification")
		net.WriteString(text)
		net.Send(self)
	end
	
else
	
	local notif = {
		text = "",
		time = 5,
		offset = 0
	}
	
	surface.CreateFont("sbv_pvp_notification", {
		font = "Roboto",
		size = 20,
		weight = 800
	})
	
	----------
	
	local function wrapText(_text, size)
        local text = ""
        local line = ""
        
        surface.SetFont("sbv_pvp_notification")
        
        local function doWord(word)
            local w, h = surface.GetTextSize(line .. " " .. word)
            
            if w > size then
                text = text .. line .. "\n"
                line = word
            else
                line = line .. " " .. word
            end
        end
        
        for k, part in pairs(string.Split(_text, " ")) do
            local words = string.Split(part, "\n")
            
            for k, word in pairs(words) do
                doWord(word)
                
                if k < #words then
                    line = line .. "\n"
                end
            end
        end
        
        if line == "" then
            text = string.sub(text, 1, #text - 1)
        else
            text = text .. line
        end
        
        return text
	end
	
	local function setNotification(text)
		local text = wrapText(text, 350)
		local x, y = surface.GetTextSize(text)
		
		notif = {
			text = text,
			time = 0,
			offset = -y/2
		}
	end
	
	function meta:PVPNotification(text)
		setNotification(text)
	end
	
	----------
	
	net.Receive("sbv_pvp_notification", function()
		setNotification(net.ReadString())
	end)
	
	hook.Add("HUDPaint", "sbv_pvp_notification", function()
		if notif.time <= 5 then
			local x = ScrW() / 2
			local y = ScrH() - 130
			local fade = 1 - math.max(notif.time - 4, 0)
			
			notif.time = notif.time + FrameTime()
			
			draw.RoundedBox(50, x - 200, y - 50, 400, 100, Color(50, 50, 50, 150 * fade))
			draw.RoundedBox(45, x - 195, y - 45, 390, 90, Color(50, 50, 50, 150 * fade))
			draw.DrawText(notif.text, "sbv_pvp_notification", x, y + notif.offset, Color(220, 220, 220, 255 * fade), TEXT_ALIGN_CENTER)
		end
		
		if LocalPlayer():InPVP() and not pvp.currentMode then
			setNotification("There currently is nothing going on in pvp land.")
		end
	end)
	
end