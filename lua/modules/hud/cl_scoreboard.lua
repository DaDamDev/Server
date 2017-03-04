local Base, Scrollbar
local menus = {}
local plyC = table.Count(player.GetAll())

surface.CreateFont("dadam_scoreboard", {
  font = "Trebuchet24",
  size = ScrH()/1080*25,
  weight = 1000
} )

surface.CreateFont("dadam_scoreboard_menu", {
  font = "Trebuchet24",
  size = ScrH()/1080*13,
  weight = 300
} )

local function plyOrder()
	local plys = {}
	
	for k, ply in ipairs(player.GetAll()) do
		plys[ply] = ply:Team()
	end
	
	return table.SortByKey(plys, true)
end

local function menu(k)
	if menus[k] then
		menus[k] = nil
	else
		menus[k] = true
	end
	
	hide()
	show()
end

local function players()
	local w = ScrW()
	local h = ScrH()
	local r = h/1080
	local offset = 0
	
	for k, ply in pairs(plyOrder()) do
		local MenuButton = vgui.Create("DButton", Scrollbar)
		MenuButton:SetSize(1000*r, 46*r)
		MenuButton:SetPos(0, 110*r + 50*k*r + offset*r - 160*r)
		MenuButton:SetText("")
		MenuButton.DoClick = function() menu(k) end
		MenuButton.Paint = function(self, w, h)
			draw.RoundedBox(1, 0, 0, 1000*r, 46*r, ColorAlpha(team.GetColor(ply:Team()), 200))
			draw.DrawText(ply:Name(), "dadam_scoreboard", 50*r, 10*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			draw.DrawText(team.GetName(ply:Team()), "dadam_scoreboard", 900*r, 10*r, Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT)
			draw.DrawText(ply:Ping(), "dadam_scoreboard", 990*r, 10*r, Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT)
			
			if ply:GetNWInt("dadam_afktimer") > 60 then
				draw.DrawText(FancyTime(ply:GetNWInt("dadam_afktimer")), "dadam_scoreboard", 460*r, 10*r, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			end
			
			draw.DrawText(math.floor(ply:GetTimeTotalTime()/60/60).." Hours", "dadam_scoreboard", 660*r, 10*r, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			
			--draw.DrawText("HP: "..ply:Health(), "dadam_scoreboard_stats", 500*r, 5*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			--draw.DrawText("Armor: "..ply:Armor(), "dadam_scoreboard_stats", 500*r, 25*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			--draw.DrawText("Kills: "..ply:Frags(), "dadam_scoreboard_stats", 500*r + 150*r, 5*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			--draw.DrawText("Deaths: "..ply:Deaths(), "dadam_scoreboard_stats", 500*r + 150*r, 25*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
		end
		
		local Avatar = vgui.Create("AvatarImage", Scrollbar)
		Avatar:SetSize(40*r, 40*r)
		Avatar:SetPos(3*r, 113*r + 50*k*r + offset*r - 160*r)
		Avatar:SetPlayer(ply, 64)
		
		local AvatarButton = vgui.Create("DButton", Scrollbar)
		AvatarButton:SetSize(40, 40)
		AvatarButton:SetPos(3*r, 113*r + 50*k*r + offset*r - 160*r)
		AvatarButton:SetAlpha(0)
		AvatarButton.DoClick = function() ply:ShowProfile() end
		
		if menus[k] then
			local Menu = vgui.Create("DPanel", Scrollbar)
			Menu:SetPos(0, 156*r + 50*k*r + offset*r - 160*r)
			Menu:SetSize(1000*r, 100*r)
			Menu.Paint = function(self, w, h)
				draw.RoundedBox(1, 0, 0, 1000*r, 100*r, ColorAlpha(team.GetColor(ply:Team()), 150))
				
				draw.DrawText("Props: "..ply:GetCount("props"), "dadam_scoreboard_menu", 3*r, 3*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("SENTs: "..ply:GetCount("sents"), "dadam_scoreboard_menu", 3*r, 19*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("Vehicles: "..ply:GetCount("vehicles"), "dadam_scoreboard_menu", 3*r, 35*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("Effects: "..ply:GetCount("Effects"), "dadam_scoreboard_menu", 3*r, 51*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("Lamps: "..ply:GetCount("lamps"), "dadam_scoreboard_menu", 3*r, 67*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("Balloons: "..ply:GetCount("balloons"), "dadam_scoreboard_menu", 3*r, 83*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				
				draw.DrawText("E2s: "..ply:GetCount("wire_expressions"), "dadam_scoreboard_menu", 123*r, 3*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("SFs: "..ply:GetCount("starfall_processor"), "dadam_scoreboard_menu", 123*r, 19*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("EA2s: "..ply:GetCount("expadv_gate"), "dadam_scoreboard_menu", 123*r, 35*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("SPUs: "..ply:GetCount("wire_spus"), "dadam_scoreboard_menu", 123*r, 51*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("CPUs: "..ply:GetCount("wire_cpus"), "dadam_scoreboard_menu", 123*r, 67*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("GPUs: "..ply:GetCount("wire_gpus"), "dadam_scoreboard_menu", 123*r, 83*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				
				draw.DrawText("HP: "..ply:Health(), "dadam_scoreboard_menu", 243*r, 3*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("Armor: "..ply:Armor(), "dadam_scoreboard_menu", 243*r, 19*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("Kills: "..ply:Frags(), "dadam_scoreboard_menu", 243*r, 35*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("Deaths: "..ply:Deaths(), "dadam_scoreboard_menu", 243*r, 51*r, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			end
			
			if ply != LocalPlayer() then
				Mute = vgui.Create("DImageButton", Scrollbar)
				Mute:SetSize(29.3*r, 29.3*r)
				Mute:SetPos(970*r, 50*k*r + offset*r)
				Mute.DoClick = function() 
					ply:SetMuted(!ply:IsMuted())
					
					if ply:IsMuted() == true then
						Mute:SetImage("icon32/muted.png")
					else
						Mute:SetImage("icon32/unmuted.png")
					end
				end
				
				if ply:IsMuted() == true then
					Mute:SetImage("icon32/muted.png")
				else
					Mute:SetImage("icon32/unmuted.png")
				end
				
				Goto = vgui.Create("DImageButton", Scrollbar)
				Goto:SetSize(26.3*r, 26.3*r)
				Goto:SetPos(970*r, 32.3*r + 50*k*r + offset*r)
				Goto:SetImage("icon16/tab_go.png")
				Goto.DoClick = function()
					LocalPlayer():ConCommand("ulx goto $"..ply:SteamID())
				end
				
				PM = vgui.Create("DImageButton", Scrollbar)
				PM:SetSize(26.3*r, 26.3*r)
				PM:SetPos(970*r, 64.6*r + 50*k*r + offset*r)
				PM:SetImage("icon16/textfield.png")
				PM.DoClick = function()
					local PMW = vgui.Create("DFrame")
					PMW:SetPos(w/2 - 200, h/2 - 50)
					PMW:SetSize(400, 100)
					PMW:SetTitle("")
					PMW:SetDraggable(false)
					PMW:Show()
					PMW:MakePopup()
					PMW.Paint = function()
						draw.RoundedBox(5, 0, 0, 400, 100, Color(20, 20, 20, 200))
						
						draw.DrawText("Send a private messages to "..ply:Nick(), "dadam_scoreboard_menu", 200, 3*r, Color(220, 220, 220, 255), TEXT_ALIGN_CENTER)
					end
					
					local PMT = vgui.Create("DTextEntry", PMW)
					PMT:SetPos(25, 45)
					PMT:SetSize(350, 25)
					PMT.OnEnter = function(self)
						LocalPlayer():ConCommand("ulx psay $"..ply:SteamID().." "..self:GetValue())
					end
				end
			end
			
			offset = offset+100
		end
	end
end

function show()
	local w = ScrW()
	local h = ScrH()
	local r = h/1080

	Base = vgui.Create("DFrame")
	Base:SetPos(w/2 - 500*r, 100*r)
	Base:SetSize(1000*r, 900*r)
	Base:SetTitle("")
	Base:SetDraggable(false)
	Base:ShowCloseButton(false)
	Base:Show()
	Base:MakePopup()
	Base:SetKeyboardInputEnabled(false)
	Base.Paint = function(self, w2, h2)
		draw.RoundedBox(1, 0, 0, 1000*r, 156*r, Color(20, 20, 20, 200))
		
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("gui/gmod_logo"))
		surface.DrawTexturedRect(-30*r, -10*r, 220*r, 220*r)
		
		draw.DrawText(GetHostName(), "dadam_scoreboard", 500*r, 20*r, Color(220, 220, 220, 255), TEXT_ALIGN_CENTER)
		draw.DrawText("AFK", "dadam_scoreboard", 460*r, 120*r, Color(220, 220, 220, 255), TEXT_ALIGN_CENTER)
		draw.DrawText("Server Time", "dadam_scoreboard", 660*r, 120*r, Color(220, 220, 220, 255), TEXT_ALIGN_CENTER)
		draw.DrawText("Rank", "dadam_scoreboard", 900*r, 120*r, Color(220, 220, 220, 255), TEXT_ALIGN_RIGHT)
		draw.DrawText("Ping", "dadam_scoreboard", 990*r, 120*r, Color(220, 220, 220, 255), TEXT_ALIGN_RIGHT)
	end
	
	Scrollbar = vgui.Create("DScrollPanel", Base)
	Scrollbar:SetSize(2000*r, 740*r)
	Scrollbar:SetPos(0, 160*r)
	
	players()
	
	timer.Create("dadam_scoreboard_ping", 1, 0, function()
		if Base.Paint then
			Base.Paint()
		end
	end)

	timer.Create("dadam_scoreboard_playercheck", 0.1, 0, function()
		if plyC != table.Count(player.GetAll()) then
			hide()
			show()
		end
		
		plyC = table.Count(player.GetAll())
	end)
end

function hide()
	Base:Remove()
	
	timer.Stop("dadam_scoreboard_ping")
	timer.Stop("dadam_scoreboard_playercheck")
end

hook.Add("ScoreboardShow", "dadam_scoreboard", function()
	--[[if Base then
		Base:Remove()
	end]]--
	
	show()
	
	return false
end)

hook.Add("ScoreboardHide", "dadam_scoreboard", function()
	hide()
	
	menus = {}
end)
