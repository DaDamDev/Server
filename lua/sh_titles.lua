if SERVER then
	if sql.TableExists("title_data") then
		sql.Query("CREATE TABLE IF NOT EXISTS title_data ( UniqueID string, Title INTEGER NOT NULL );")
		--[[print("----------------------------------------------------------------------------------------------------------------")
		print(sql.LastError())
		print("----------------------------------------------------------------------------------------------------------------")]]--
	end
	
	hook.Add("PlayerSay", "dadam_title", function(ply, text, public)
		if string.sub(text, 1, 6) == "!title" then
			arg = string.sub(text, 8, #text)
			
			if #arg > 0 then
				ply:ChatPrint("Your title is now: "..string.sub(arg, 1, 32))
				
				if #arg > 32 then
					ply:ChatPrint("Note: Your title hit the char limit of 32 chars and has been shortend.")
				end
				
				--print(ply:Nick().." changed his title to: "..arg.."("..#arg..")")
				--print(ply:Nick().." changed his title to: "..string.sub(arg, 1, 32))
				
				ply:SetNWString("dadam_title", string.sub(arg, 1, 32))
				
				--[[local result = sql.Query("SELECT Title FROM title_data WHERE UniqueID = "..ply:UniqueID()..";")
				print("----------------------------------------------------------------------------------------------------------------")
				print(result)
				print("----------------------------------------------------------------------------------------------------------------")
				if result then
					sql.Query("UPDATE title_data SET Title = "..string.sub(arg, 1, 32).." WHERE UniqueID = "..ply:UniqueID()..");")
					ply:ChatPrint("DEBUG: UPDATE; "..sql.LastError())
				else
					sql.Query("INSERT into title_data ( UniqueID, Title ) VALUES ( UniqueID = "..ply:UniqueID()..", Title = "..string.sub(arg, 1, 32)..");")
					ply:ChatPrint("DEBUG: MAKE; "..sql.LastError())
				end]]--
				
				--ply:ChatPrint("DEBUG: "..sql.Query("SELECT Title FROM title_data WHERE UniqueID = '"..ply:UniqueID().."'"))
				
				--sql.Query("UPDATE title_data SET Title = '"..arg.."' WHERE UniqueID = '"..ply:UniqueID().."'")
			else
				if #ply:GetNWString("dadam_title") > 0 then
					ply:ChatPrint("Your Title is: "..ply:GetNWString("dadam_title"))
				else
					ply:ChatPrint("You dont have a title. ")
				end
			end
		end
	end )
	
	hook.Add("PlayerInitialSpawn", "dadam_title", function(ply)
		local result = sql.QueryValue("SELECT Title FROM title_data WHERE UniqueID = "..ply:UniqueID()..";")
		if result then
			ply:SetNWString("dadam_title", result)
		end
		
		--[[local result = sql.Query("SELECT Title FROM title_data WHERE UniqueID = "..ply:UniqueID())
		
		if !IsValid(result) then
			sql.Query("INSERT INTO title_data ( UniqueID, OriginalTitle, Title ) VALUES ('" .. ply:UniqueID() .. "','" .. ply:Nick() .. "','')")
			ply:SetNWString("dadam_title", "")
		else
			ply:SetNWString("dadam_title", result[1]["Title"])
		end]]--
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
				if ply != LocalPlayer() then
					local plyp = ply:GetPos()
					local dist = math.sqrt((lpp.x - (plyp.x))^2 + (lpp.y - (plyp.y))^2 + (lpp.z - (plyp.z))^2)
					local color = ColorAlpha(Color(255, 255, 255), (1000-dist))
					
					draw.DrawText(ply:GetNWString("dadam_title"), "dadam_title_font", ply:EyePos():ToScreen().x, (ply:EyePos() + Vector(0, 0, 25-dist/40)):ToScreen().y, color, TEXT_ALIGN_CENTER)
				end
			end
		end)
	end)
end