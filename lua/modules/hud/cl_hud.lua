surface.CreateFont("dadam_hud_font", {
	font = "Trebuchet24",
	size = 20,
	weight = 1000
} )

function AmmoP(ply)
	local ammo = -1
	
	if ply:GetActiveWeapon():IsValid() then
		ammo = ply:GetActiveWeapon():Clip1()
	end
	
	return ammo
end

hook.Add("ULibLocalPlayerReady", "dadam_hud", function(plyrdy)
	local w = ScrW()
	local h = ScrH()
	local lp = LocalPlayer()
	
	local armorP = 0
	local ammoP = 0
	
	hook.Add("HUDPaint", "dadam_hud", function()
		--
		--draw.RoundedBox(5, -5, h - 200, 305, 205, Color(70, 70, 70, 150))
		--draw.RoundedBox(5, -5, h - 195, 300, 200, Color(200, 200, 200, 150))
		--print(lp:GetActiveWeapon():IsValid())
		
		-- Ammo
		if AmmoP(lp) > -1 or (ammoP ~= 0 and AmmoP(lp) == -1) then
			if AmmoP(lp) > -1 and ammoP ~= 1 then
				ammoP = math.Clamp(ammoP + 0.2, 0, 1)
			elseif AmmoP(lp) == -1 then
				ammoP = math.Clamp(ammoP - 0.2, 0, 1)
			end
			
			local ammoM = -1
			local ammoT = -1
			
			if lp:GetActiveWeapon():IsValid() then
				ammoM = lp:GetActiveWeapon():GetMaxClip1()
			end
			if lp:GetActiveWeapon():IsValid() then
				ammoT = lp:GetAmmoCount(lp:GetActiveWeapon():GetPrimaryAmmoType())
			end
			
			draw.RoundedBox(1, 30, h-20 - 40*ammoP, 250, 30*ammoP, Color(70, 70, 70, 150))
			draw.RoundedBox(1, 33, h-17 - 40*ammoP, math.Clamp(244 * (AmmoP(lp)/ammoM), 0, 244), 24*ammoP, Color(240, 220, 0, 150))
			draw.DrawText(AmmoP(lp).."/"..ammoT, "dadam_hud_font", 155, h-15 - 40*ammoP, Color(220, 220, 220, 230*ammoP), TEXT_ALIGN_CENTER)
		end
		
		-- Armor
		if lp:Armor() > 0 or (armorP ~= 0 and lp:Armor() == 0) then
			if lp:Armor() > 0 and armorP ~= 1 then
				armorP = math.Clamp(armorP + 0.2, 0, 1)
			elseif lp:Armor() <= 0 then
				armorP = math.Clamp(armorP - 0.2, 0, 1)
			end
			
			draw.RoundedBox(1, 30, h-20 - 40*(armorP+ammoP), 250, 30*armorP, Color(70, 70, 70, 150))
			draw.RoundedBox(1, 33, h-17 - 40*(armorP+ammoP), math.Clamp(244 * (lp:Armor()/100), 0, 244), 24*armorP, Color(30, 70, 200, 150))
			draw.DrawText(lp:Armor(), "dadam_hud_font", 155, h-15 - 40*(armorP+ammoP), Color(220, 220, 220, 230*armorP), TEXT_ALIGN_CENTER)
		end
		
		-- HP
		draw.RoundedBox(1, 30, h-60 - 40*(armorP+ammoP), 250, 30, Color(70, 70, 70, 150))
		draw.RoundedBox(1, 33, h-57 - 40*(armorP+ammoP), math.Clamp(244 * (lp:Health()/lp:GetMaxHealth()), 0, 244), 24, Color(200, 70, 30, 150))
		draw.DrawText(lp:Health(), "dadam_hud_font", 155, h-55 - 40*(armorP+ammoP), Color(220, 220, 220, 230), TEXT_ALIGN_CENTER)
		
	end)
	
	hook.Add("HUDShouldDraw", "dadam_hud", function(name)
		local hud = {"CHudHealth", "CHudBattery", "CHudAmmo"}
		for k, element in pairs(hud) do
			if name == element then return false end
		end
		return true
	end)
end)
