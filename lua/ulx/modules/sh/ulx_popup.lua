if SERVER then
	util.AddNetworkString("popup_set")
	util.AddNetworkString("popup_remove")
	
	function popup_sim(calling_ply, target_plys, amount)
		if SERVER then
			if amount > 0 then
				ulx.fancyLogAdmin(calling_ply, "#A has given "..amount.." popups to #T!", target_plys)
			else
				ulx.fancyLogAdmin(calling_ply, "#A has given infinite popups to #T!", target_plys)
			end
			
			net.Start("popup_set")
			net.WriteInt(amount, 32)
			net.Send(target_plys)
		end
	end
	
	function popup_sim_remove(calling_ply, target_plys)
		if SERVER then
			ulx.fancyLogAdmin(calling_ply, "#A has stopped the popups from #T!", target_plys)
			
			net.Start("popup_remove")
			net.Send(target_plys)
		end
	end
else
	local amount = -1
	local done = -1
	local popupCount = 0
	
	local popups = {}
	
	local popupSounds = {
		s1 = "garrysmod/balloon_pop_cute.wav",
		s2 = "garrysmod/content_downloaded.wav",
		s3 = "garrysmod/save_load1.wav",
		s4 = "garrysmod/save_load2.wav",
		s5 = "garrysmod/save_load3.wav",
		s6 = "garrysmod/save_load4.wav"
	}
	
	local popupTypes = {}
	
	popupTypes["default_nose"] = {
		txt1 = "Do you have a tiny nose?",
		txt2 = "Try our free nose enlarger!",
		but = "CLICK HERE TO TRY IT!",
		img = "gui/postprocess/morph.png"
	}; popupTypes["default_vacation"] = {
		txt1 = "Are you overworked?",
		txt2 = "You need a vacation!",
		but = "CHANGE YOUR LIFE!",
		img = "hlmv/background"
	}; popupTypes["default_floor"] = {
		txt1 = "Is your floor old fashion?",
		txt2 = "Yes it is!",
		but = "GET A NEW FLOOR NOW!",
		img = "gui/dupe_bg.png"
	}; popupTypes["default_smile"] = {
		txt1 = "Never be sad again!",
		txt2 = "Try this one recipie for the ultimate smile!",
		but = "GET A FREE TRIAL NOW!",
		img = "vgui/face/grin"
	}; popupTypes["default_learn"] = {
		txt1 = "Confused what this is? WE TO!",
		txt2 = "Learn more about this shit now!",
		but = "CLICK HERE FOR FREE SIGNUP!",
		img = "gwenskin/defaultskin.png"
	}; popupTypes["default_hugs"] = {
		txt1 = "Are you lonley?",
		txt2 = "Hugs for only half the price now!",
		but = "GET YOUR CHEAP HUGS NOW!",
		img = "entities/npc_dog.png"
	}
	
	surface.CreateFont("popup_desc", {
	  font = "Arial",
	  size = 15,
	  weight = 1000
	} )
	
	surface.CreateFont("popup_button", {
	  font = "Arial",
	  size = 20,
	  weight = 1000
	} )
	
	local function popupCreate(txt, txt2, buttontxt, img)
		local w = ScrW()
		local h = ScrH()
		
		img = Material(img, "noclamp")
		
		done = done + 1
		popupCount = popupCount + 1
		
		surface.PlaySound(table.Random(popupSounds))
		
		local Frame = vgui.Create("DFrame")
		Frame:SetPos(math.random(0, w-300), math.random(0, h-300))
		Frame:SetSize(300, 300)
		Frame:SetTitle("")
		Frame:SetDraggable(true)
		Frame:ShowCloseButton(true)
		Frame:Show()
		Frame:MakePopup()
		Frame.Paint = function()
			local buttonColor = ColorRand()
			
			draw.RoundedBox(0, 0, 0, 300, 300, Color(170, 170, 170, 255))
			
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(img)
			surface.DrawTexturedRect(0, 0, 300, 300)
			
			local w, h = draw.Text({text = txt, pos = {150, 30}, font = "popup_desc", color = Color(0, 0, 0, 255), xalign = TEXT_ALIGN_CENTER, yalign = TEXT_ALIGN_CENTER})
			local w2, h2 = draw.Text({text = txt2, pos = {150, 32+h}, font = "popup_desc", color = Color(0, 0, 0, 255), xalign = TEXT_ALIGN_CENTER, yalign = TEXT_ALIGN_CENTER})
			
			draw.RoundedBox(math.Clamp(5, 0, w), 148-w/2, 30-h/2, w, h, Color(30, 30, 30, 200))
			draw.RoundedBox(math.Clamp(5, 0, w2), 148-w2/2, 32+h-h2/2, w2, h2, Color(30, 30, 30, 200))
			draw.Text({text = txt, pos = {150, 30}, font = "popup_desc", color = Color(230, 230, 230, 200), xalign = TEXT_ALIGN_CENTER, yalign = TEXT_ALIGN_CENTER})
			draw.Text({text = txt2, pos = {150, 32+h}, font = "popup_desc", color = Color(230, 230, 230, 200), xalign = TEXT_ALIGN_CENTER, yalign = TEXT_ALIGN_CENTER})
			
			local w3, h3 = draw.Text({text = buttontxt, pos = {150, 250}, font = "popup_button", color = Color(0, 0, 0, 255), xalign = TEXT_ALIGN_CENTER, yalign = TEXT_ALIGN_CENTER})
			
			draw.RoundedBox(math.Clamp(5, 0, w3), 150-w3/2-5, 250-h3/2-5, w3+10, h3+10, buttonColor)
			draw.Text({text = buttontxt, pos = {150, 250}, font = "popup_button", color = Color(0, 0, 0, 255), xalign = TEXT_ALIGN_CENTER, yalign = TEXT_ALIGN_CENTER})
		end
		Frame.OnClose = function()
			popupCount = popupCount - 1
			
			if popupCount < 20 then
				--done = done + 1
				
				if (done < amount or amount == 0) and amount ~= -1 then
					local randomPopup = table.Random(popupTypes)
					
					popupCreate(randomPopup.txt1, randomPopup.txt2, randomPopup.but, randomPopup.img)
				end
			end
		end
		
		if (done < amount or amount == 0) and amount ~= -1 and popupCount < 20 then
			timer.Simple(math.random(0, 100)/100, function()
				if amount ~= -1 then
					local randomPopup = table.Random(popupTypes)
					
					popupCreate(randomPopup.txt1, randomPopup.txt2, randomPopup.but, randomPopup.img)
				end
			end)
		end
		
		table.insert(popups, Frame)
	end
	
	net.Receive("popup_set", function()
		amount = net.ReadInt(32)
		done = 0
		
		local randomPopup = table.Random(popupTypes)
		
		popupCreate(randomPopup.txt1, randomPopup.txt2, randomPopup.but, randomPopup.img)
	end)
	
	net.Receive("popup_remove", function()
		amount = -1
		done = -1
		popupCount = 0
		
		for k, data in ipairs(popups) do
			data:Remove()
		end
		
		popups = {}
	end)
end

local cmd = ulx.command("Fun", "ulx popup", popup_sim, "!popup")
cmd:addParam{type = ULib.cmds.PlayersArg}
cmd:addParam{type = ULib.cmds.NumArg}
cmd:defaultAccess(ULib.ACCESS_ADMIN)
cmd:help("Gives your victem(s) annoying popup-adds!")

local cmd2 = ulx.command("Fun", "ulx unpopup", popup_sim_remove, "!unpopup")
cmd2:addParam{type = ULib.cmds.PlayersArg}
cmd2:defaultAccess(ULib.ACCESS_ADMIN)
cmd2:help("Removes the annoying popup-adds from your victem(s)!")
