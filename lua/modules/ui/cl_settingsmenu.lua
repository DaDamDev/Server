local base
local skinConvar

local function open()
	if not base then
		skinConvar = GetConVar("ddd_skin")
		
		local w, h = ScrW(), ScrH()
		
		base = vgui.Create("DFrame")
		base:SetPos(w/2 - 150, h/2 - 250)
		base:SetSize(300, 500)
		base:SetTitle("DaDamDev Settings")
		base:MakePopup()
		base:SetDeleteOnClose(false)
		function base:OnClose() base:Hide() end
		
		-----Skin-----
		local skin = vgui.Create("DCollapsibleCategory", base)
		skin:SetPos(25, 50)
		skin:SetSize(150, 100)
		skin:SetExpanded(0)
		skin:SetLabel("UI Skin (" .. skinConvar:GetString() .. ")")
		
		local skinList = vgui.Create("DPanelList", skin)
		skinList:EnableHorizontal(false)
		skinList:EnableVerticalScrollbar(true)
		skin:SetContents(skinList)
		
		local skinWhite = vgui.Create("DButton")
		skinWhite:SetText("White")
		skinList:AddItem(skinWhite)
		function skinWhite:DoClick() LocalPlayer():ConCommand("ddd_skin default") skin:SetLabel("UI Skin (default)") end
		
		local skinDark = vgui.Create("DButton")
		skinDark:SetText("Dark")
		skinList:AddItem(skinDark)
		function skinDark:DoClick() LocalPlayer():ConCommand("ddd_skin dark") skin:SetLabel("UI Skin (dark)") end
		
		local skinSpacer = vgui.Create("DLabel", parent)
		skinSpacer:SetHeight(10)
		skinSpacer:SetText("")
		skinList:AddItem(skinSpacer)
		
		local skinNote = vgui.Create("DButton", parent)
		skinNote:SetHeight(30)
		skinNote:SetText("Requires rejoin to work!\nClick here to rejoin the server.")
		skinList:AddItem(skinNote)
		function skinNote:DoClick() LocalPlayer():ConCommand("retry") end
		--------------
	else
		base:Show()
	end
end

hook.Add("OnPlayerChat", "dadam_settings", function(ply, txt, team, ded)
	if ply == LocalPlayer() and txt == "!settings" then
		open()
	end
end)