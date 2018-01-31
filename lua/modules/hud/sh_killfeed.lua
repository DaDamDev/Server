if SERVER then
	local damageData = {}
	
	util.AddNetworkString("dadam_killfeed")
	
	-----Damage registration-----
	hook.Add("PlayerHurt", "dadam_killfeed", function(ply, attacker, health, dmg)
		damageData[ply] = damageData[ply] or {}
		
		damageData[ply][attacker] = (damageData[ply][attacker] or 0) + dmg
	end)
	
	-----Death Registration-----
	local function stuffs(ply, weapon, attacker)
		damageData[ply] = damageData[ply] or {[ply] = 100}
		
		--if table.Count(damageData[ply]) > 0 and (table.Count(damageData[ply]) == 1 and table.GetKeys(damageData[ply])[1] != ply) then
		local assist = table.GetKeys(damageData[ply])[1]
		
		for k, v in pairs(damageData[ply]) do
			if v > damageData[ply][assist] then
				assist = k
			end
		end
		
		net.Start("dadam_killfeed")
		net.WriteEntity(ply)
		net.WriteEntity(weapon)
		net.WriteEntity(attacker)
		net.WriteEntity(assist)
		net.Broadcast()
		
		damageData[ply] = nil
	end
	
	hook.Add("PlayerDeath", "dadam_killfeed", stuffs)
	hook.Add("OnNPCKilled", "dadam_killfeed", stuffs)
else
	surface.CreateFont("dadam_killfeed", {
		font = "Trebuchet24",
		size = 15,
		weight = 1000
	})
	
	local weaponModels = {}
	local entries = {}
	
	local killfeed = vgui.Create("DScrollPanel")
	killfeed:SetPos(ScrW() - 400, 100)
	killfeed:SetSize(420, 600)
	killfeed:GetVBar().Paint = function() return true end
	killfeed:GetVBar().btnUp.Paint = function() return true end
	killfeed:GetVBar().btnDown.Paint = function() return true end
	killfeed:GetVBar().btnGrip.Paint = function() return true end
	
	--local killstreak = vgui.Create("DPanel")
	
	for k, v in pairs(weapons.GetList()) do
		weaponModels[v.ClassName] = v.WorldModel
	end
	
	-----Death notification Registration-----
	net.Receive("dadam_killfeed", function()
		local ply, weapon, attacker, assist = net.ReadEntity(), net.ReadEntity(), net.ReadEntity(), net.ReadEntity()
		
		--print(attacker:Name() .. " + " .. assist:Name() .. " (" .. class .. ") " .. ply:Name())
		dadam_register_deathnote(ply, assist, attacker, weapon)
	end)
	
	function dadam_register_deathnote(ply, assist, attacker, weapon)
		local plyName, assName, attName, wepName = "", "", "", ""
		local plyColor, assColor, attColor = Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255)
		
		--------------------
		if ply:IsWorld() then
			plyName = "World"
		elseif ply:IsPlayer() then
			plyName = ply:Name()
			plyColor = team.GetColor(ply:Team())
		else
			plyName = ply:GetClass()
		end
		
		--------------------
		if assist == NULL then assist = ply end
		
		if assist:IsWorld() then
			assName = "World"
		elseif assist:IsPlayer() then
			assName = assist:Name()
			assColor = team.GetColor(assist:Team())
		else
			assName = assist:GetClass()
			--assName = assist:CPPIGetOwner()()
		end
		
		--------------------
		if attacker == NULL then attacker = ply end
		
		if attacker:IsWorld() then
			attName = "World"
		elseif attacker:IsPlayer() then
			attName = attacker:Name()
			attColor = team.GetColor(attacker:Team())
		else
			attName = attacker:GetClass()
			--attName = attacker:CPPIGetOwner()()
		end
		
		--------------------
		if weapon == NULL then weapon = ply end
		
		if weapon:IsPlayer() or weapon:IsNPC() then
			if weapon:GetActiveWeapon():IsWeapon() then
				wepName = weapon:GetActiveWeapon():GetClass()
			else
				wepName = weapon:GetClass()
			end
		elseif weapon:IsWeapon() then
			wepName = weapon:GetClass()
		end
		
		--------------------
		local note = vgui.Create("DPanel", killfeed)
		note:SetSize(400, 80)
		
		local xOff = 10
		
		local noteAttacker = vgui.Create("DLabel", note)
		noteAttacker:SetText(attName)
		noteAttacker:SetTextColor(attColor)
		noteAttacker:SetSize(20, 40)
		noteAttacker:SetPos(10, 10)
		noteAttacker:SetFont("dadam_killfeed")
		noteAttacker:SizeToContents()
		
		xOff = xOff + noteAttacker:GetWide()
		
		if assist and assist != ply and assist != attacker then
			local notePlus = vgui.Create("DLabel", note)
			notePlus:SetText(" + ")
			notePlus:SetTextColor(Color(255, 255, 255))
			notePlus:SetSize(20, 40)
			notePlus:SetPos(xOff, 10)
			notePlus:SetFont("dadam_killfeed")
			notePlus:SizeToContents()
			
			xOff = xOff + notePlus:GetWide()
			
			local noteAssist = vgui.Create("DLabel", note)
			noteAssist:SetText(assName)
			noteAssist:SetTextColor(assColor)
			noteAssist:SetSize(20, 40)
			noteAssist:SetPos(xOff, 10)
			noteAssist:SetFont("dadam_killfeed")
			noteAssist:SizeToContents()
			
			xOff = xOff + noteAssist:GetWide()
		end
		
		xOff = xOff + 10
		
		local l = xOff
		
		if weapon and ((weaponModels[wepName] and (weapon:IsPlayer() or weapon:IsNPC())) or (not weapon:IsPlayer() and not weapon:IsNPC())) and not weapon:IsWorld() then
			if weaponModels[wepName] and weapon:IsPlayer() then
				local icon = vgui.Create("DModelPanel", note)
				icon:SetSize(140, 140)
				icon:SetPos(xOff - 40, -80)
				icon:SetModel(weaponModels[wepName] or weapon:GetModel())
				function icon:LayoutEntity(ent) return end
			else
				local icon = vgui.Create("DModelPanel", note)
				icon:SetSize(140, 140)
				icon:SetPos(xOff - 50, -80)
				icon:SetModel(weaponModels[wepName] or weapon:GetModel())
				function icon:LayoutEntity(ent)
					local v1, v2 = ent:GetModelBounds()
					
					ent:SetModelScale(1 / math.max((v2.x - v1.x), (v2.y - v1.y), (v2.z - v1.z)) * 30)
				end
			end
		else
			local icon = vgui.Create("DKillIcon", note)
			icon:SetName(wepName)
			icon:SetSize(40, 40)
			icon:SetPos(xOff + 10, 20)
		end
		
		xOff = xOff + 70
		
		local notePly = vgui.Create("DLabel", note)
		notePly:SetText(plyName)
		notePly:SetTextColor(plyColor)
		notePly:SetSize(20, 40)
		notePly:SetPos(xOff, 10)
		notePly:SetFont("dadam_killfeed")
		notePly:SizeToContents()
		
		note.Paint = function()
			surface.SetDrawColor(Color(200, 200, 200))
			surface.DrawRect(0, 0, xOff + notePly:GetWide(), 60)
			
			surface.SetDrawColor(Color(60, 60, 60))
			surface.DrawRect(2, 2, l, 56)
			surface.DrawRect(xOff - notePly:GetWide() - 10, 2, notePly:GetWide() + 20, 56)
			surface.DrawRect(l, 2, 70, 5)
			surface.DrawRect(l, 53, 70, 5)
		end
		
		xOff = xOff + notePly:GetWide()
		entries[note] = {x = 390 - math.min(xOff, 390), y = table.Count(entries)*60}
		
		note:SetPos(390 - math.min(xOff, 390), (table.Count(entries)-1)*60)
		
		timer.Simple(5, function()
			for k, v in pairs(entries) do
				k:MoveTo(v.x, v.y - 60, 0.5)
				
				entries[k].y = v.y - 60
			end
			
			timer.Simple(0.5, function()
				note:Remove()
				entries[note] = nil
			end)
		end)
	end
	
	-----Hide default killfeed-----
	hook.Add("DrawDeathNotice", "dadam_killfeed", function(x, y)
		return 0, 0
	end)
end