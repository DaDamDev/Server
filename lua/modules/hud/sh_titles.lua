if SERVER then
	if not sql.TableExists("dadam_titles") then
		sql.Query("CREATE TABLE dadam_titles ( steamid64 varchar(255), title varchar(255) )")
		print("Attempting to create title database")
		
		if sql.TableExists("dadam_titles") then
			print("Title database has been created")
		end
	end
	
	hook.Add("PlayerSay", "dadam_title", function(ply, text, public)
		if string.sub(text, 1, 6) == "!title" then
			local arg = string.sub(text, 8, #text)
			local id = ply:SteamID64()
			
			if #arg > 0 then
				ply:ChatPrint("Your title is now: " .. string.sub(arg, 1, 32))
				
				if #arg > 32 then
					ply:ChatPrint("Note: Your title hit the char limit of 32 chars and has been shortend.")
				end
				
				sql.Query("UPDATE dadam_titles SET title = '" .. string.sub(arg, 1, 32) .. "' WHERE steamid64 = '" .. id .. "'")
				ply:SetNWString("dadam_title", string.sub(arg, 1, 32))
			else
				if #ply:GetNWString("dadam_title") > 0 then
					ply:ChatPrint("Your Title is: " .. ply:GetNWString("dadam_title"))
				else
					ply:ChatPrint("You dont have a title. ")
				end
			end
		elseif string.sub(text, 1, 11) == "!cleartitle" then
			local id = ply:SteamID64()
			
			sql.Query("UPDATE dadam_titles SET title = '' WHERE steamid64 = '" .. id .. "'")
			ply:SetNWString("dadam_title", "")
		end
	end )
	
	hook.Add("PlayerInitialSpawn", "dadam_title", function(ply)
		local id = ply:SteamID64()
		local result = sql.QueryRow("SELECT title FROM dadam_titles WHERE steamid64 = '" .. id .. "'")

		if result then
			ply:SetNWString("dadam_title", result.title)
		else
			sql.Query("INSERT into dadam_titles (steamid64, title) VALUES ('" .. id .. "', '')")
		end
	end)
else
	surface.CreateFont("dadam_title_font", {
		font = "Trebuchet24",
		size = 15,
		weight = 1000
	} )
	
	hook.Add("ULibLocalPlayerReady", "dadam_title", function(plyrdy)
		hook.Add("HUDPaint", "dadam_title", function()
			local lpp = LocalPlayer():GetPos()
			
			for k, ply in pairs(player.GetAll()) do
				if ply ~= LocalPlayer() then
					local plyp = ply:GetPos()
					local dist = math.sqrt((lpp.x - (plyp.x))^2 + (lpp.y - (plyp.y))^2 + (lpp.z - (plyp.z))^2)
					local color = ColorAlpha(Color(255, 255, 255), (1000-dist))
					
					draw.DrawText(ply:GetNWString("dadam_title"), "dadam_title_font", ply:EyePos():ToScreen().x, (ply:EyePos() + Vector(0, 0, 25-dist/40)):ToScreen().y, color, TEXT_ALIGN_CENTER)
				end
			end
		end)
	end)
end
