if SERVER then
	util.AddNetworkString("dadam_propinfo")
	
	local timeouts = {}
	
	local function getConstraints(ent)
		local tbl = constraint.GetTable(ent)
		local data = {}
		
		for k, v in pairs(tbl) do
			data[v.Type] = data[v.Type] or 0
			data[v.Type] = data[v.Type] + 1
		end
		
		return data
	end
	
	net.Receive("dadam_propinfo", function(len, ply)
		if timeouts[ply] > CurTime() then return end
		timeouts[ply] = CurTime() + 0.9
		
		local ent = net.ReadEntity()
		
		if ent:IsValid() then
			net.Start("dadam_propinfo")
			net.WriteTable(getConstraints(ent))
			net.Send(ply)
		end
	end)
else
	hook.Add("ULibLocalPlayerReady", "dadam_propinfo", function()
		local pi = CreateClientConVar("ddd_pi", "1", true, false, "This toggle if propinfo will be displayed on screen.")
		local pia = CreateClientConVar("ddd_pia", "1", true, false, "This toggle if propinfo will contain advanced information.")
		
		local constraints = {}
		local validEnt = false
		local curEnt = nil
		
		-----Constraint stuff-----
		net.Receive("dadam_propinfo", function()
			constraints = net.ReadTable()
		end)
		
		local function getConstraints(ent)
			net.Start("dadam_propinfo")
			net.WriteEntity(ent)
			net.SendToServer()
		end
		
		timer.Create("dadam_propinfo", 1, 0, function()
			if validEnt then
				getConstraints(curEnt)
			end
		end)
		
		-----Hud stuff-----
		hook.Remove("HUDPaint", "NADMOD.HUDPaint")
		
		local props = NADMOD.PropOwners
		
		surface.CreateFont("dadam_propinfo", {
		  font = "Trebuchet24",
		  size = 15,
		  weight = 1000
		})
		
		local font = "dadam_propinfo"
		
		hook.Add("HUDPaint", "dadam_propinfo", function()
			if pi:GetBool() then
				local tr = LocalPlayer():GetEyeTrace()
				local ent = tr.Entity
				
				validEnt = false
				
				if not tr.HitNonWorld or not ent:IsValid() then return end
				
				local text, text2, text3, text4
				
				if not ent:IsPlayer() and ent:GetClass() != "prop_dynamic" and props[ent:EntIndex()] then
					text = "Owner: " .. props[ent:EntIndex()] or "N/A"
					text2 = "'" .. string.sub(table.remove(string.Explode("/", ent:GetModel() or "?")), 1,-5) .. "' ["..ent:EntIndex().."]"
					text3 = ent:GetClass()
					
					if curEnt != ent then
						constraints = {}
					end
					
					curEnt = ent
					validEnt = true
				elseif ent:IsPlayer() then
					local steamid = ent:SteamID()
					
					if steamid == "NULL" then steamid = "BOT" end
					
					text = ent:Name()
					text2 = steamid
					text3 = team.GetName(ent:Team())
				end
				
				if text then
					surface.SetFont(font)
					
					local mat = ent:GetMaterial()
					
					local w, h = surface.GetTextSize(text)
					local w2, h2 = surface.GetTextSize(text2)
					local w3, h3 = surface.GetTextSize(text3)
					local wm, hm = surface.GetTextSize(mat)
					
					if mat == "" or not pia:GetBool() then
						wm = 0
						hm = 0
					end
					
					local boxHeight = h + h2 + h3 + hm + 16 + table.Count(constraints) * h
					local boxWidth = math.Max(w, w2, w3, wm) + 22
					
					draw.RoundedBox(4, ScrW() - (boxWidth + 4), (ScrH()/2 - 200) - 16, boxWidth, boxHeight, Color(0, 0, 0, 150))
					draw.RoundedBox(4, ScrW() - (boxWidth + 4) + 2, (ScrH()/2 - 200) - 14, boxWidth - 4, boxHeight - 4, Color(255, 255, 255, 150))
					
					draw.SimpleText(text, font, ScrW() - (w / 2) - 16, ScrH()/2 - 200, Color(30, 30, 30), 1, 1)
					draw.SimpleText(text2, font, ScrW() - (w2 / 2) - 16, ScrH()/2 - 200 + h, Color(30, 30, 30), 1, 1)
					draw.SimpleText(text3, font, ScrW() - (w3 / 2) - 16, ScrH()/2 - 200 + h + h2, Color(30, 30, 30), 1, 1)
					
					if pia:GetBool() then
						draw.SimpleText(mat, font, ScrW() - (wm / 2) - 16, ScrH()/2 - 200 + h + h2 + hm, Color(30, 30, 30), 1, 1)
						
						local i = 0
						for cons, amount in pairs(constraints) do
							i = i + 1
							
							local w4, h4 = surface.GetTextSize(cons .. ": " .. amount)
							draw.SimpleText(cons .. ": " .. amount, font, ScrW() - (w4 / 2) - 16, ScrH()/2 - 200 + h + h2 + hm + i*h4, Color(30, 30, 30), 1, 1)
						end
					end
				end
			end
		end)
	end)
end