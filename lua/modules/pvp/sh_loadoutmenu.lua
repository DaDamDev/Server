pvp.loadoutmenu = {
	maxItems = 1,
	catalog = {
		weapon_cs_p90 = "P90",
		weapon_cs_sig552 = "SIG552",
		weapon_cs_tmp = "TMP",
		weapon_cs_deserteagle = "DESERT EAGLE",
		weapon_cs_famas = "FAMAS",
		weapon_cs_m3 = "M3SUPER90",
		weapon_cs_aug = "AUG",
		weapon_cs_awp = "AWP",
		weapon_cs_ak47 = "AK-47",
		weapon_cs_mp5 = "MP5 NAVY",
		weapon_cs_galil = "GALIL",
		weapon_cs_para = "M249 PARA",
		weapon_cs_xm1014 = "XM1014",
		weapon_cs_p228 = "P228",
		weapon_cs_g3 = "G3SG1",
		weapon_cs_glock = "GLOCK",
		weapon_cs_m4 = "M4A1 Carbine",
		weapon_cs_fiveseven = "FIVESEVEN",
		weapon_cs_mac10 = "MAC-10",
		weapon_cs_usp = "USP",
		weapon_cs_scout = "SCOUT SNIPER",
		weapon_cs_dualbertta = "DUAL BERETTAS",
		weapon_cs_ump = "UMP",
		weapon_cs_sig550 = "SIG550"
	}
}

local function getMaxItems()
	if pvp.currentMode and pvp.currentMode.loadoutmenu and pvp.currentMode.loadoutmenu.maxItems then
		return pvp.currentMode.loadoutmenu.maxItems
	end
	
	return pvp.loadoutmenu.maxItems
end

local function getCatalog()
	if pvp.currentMode and pvp.currentMode.loadoutmenu and pvp.currentMode.loadoutmenu.catalog then
		return pvp.currentMode.loadoutmenu.catalog
	end
	
	return pvp.loadoutmenu.catalog
end

if SERVER then
	
	util.AddNetworkString("sbv_pvp_loadoutmenu_select")
	
	net.Receive("sbv_pvp_loadoutmenu_select", function(_, ply)
		if not ply:InPVP() then return end
		if not ply:HasSpawnProtection() then return ply:PVPNotification("You need to have spawnprotection to change your loadout!") end
		
		local class = net.ReadString()
		
		if not class or not getCatalog()[class] then return end
		
		local loadout = ply:GetPVPLoadout()
		
		table.insert(loadout, class)
		
		while #loadout > getMaxItems() do
			ply:StripWeapon(loadout[1])
			
			table.remove(loadout, 1)
		end
		
		ply:Give(class)
		ply:SelectWeapon(class)
		
		ply:SetPVPLoadout(loadout)
	end)
	
else
	
	local frame
	
	local function createLoadoutMenu()
		frame = vgui.Create("DFrame")
		frame:SetPos(ScrW()/2 - 200, ScrH()/2 - 200)
		frame:SetSize(450, 450)
		frame:SetTitle("Worse loadout ever")
		frame:SetDraggable(false)
		frame:ShowCloseButton(false)
		frame:Show()
		frame:MakePopup()
		
		local list = vgui.Create("DIconLayout", frame)
		list:SetPos(0, 0)
		list:SetSize(450, 450)
		list:SetSpaceY(5)
		list:SetSpaceX(5)
		
		for class, name in pairs(getCatalog()) do
			local button = vgui.Create("DImageButton", list)
			button:SetSize(60, 60)
			button:SetToolTip(name)
			button:SetImage("entities/" .. class .. ".png", "vgui/entities/" .. class .. ".png")
			button.DoClick = function()
				net.Start("sbv_pvp_loadoutmenu_select")
				net.WriteString(class)
				net.SendToServer()
			end
			
			list:Add(button)
		end
	end
	
	hook.Add("PVPModeStarted", "sbv_pvp_loadoutmenu", function(mode)
		if frame then
			frame:Remove()
			frame = nil
		end
	end)
	
	hook.Add("OnSpawnMenuOpen", "sbv_pvp_loadoutmenu", function()
		if not LocalPlayer():InPVP() then return end
		
		if pvp.currentMode and pvp.currentMode.loadoutmenu then
			if LocalPlayer():HasSpawnProtection() then
				if not frame then
					createLoadoutMenu()
				end
				
				frame:Show()
				frame:MakePopup()
			else
				LocalPlayer():PVPNotification("You need to have spawnprotection to change your loadout!")
			end
		elseif pvp.currentMode then
			LocalPlayer():PVPNotification("You can't change your loadout in " .. pvp.currentMode.name)
		end
		
		return false
	end)
	
	hook.Add("OnSpawnMenuClose", "sbv_pvp_loadoutmenu", function()
		if frame then
			frame:Hide()
		end
	end)
	
end