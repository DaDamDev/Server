-- TODO: make look better

surface.CreateFont("sbv_nametags", {
	font = "Trebuchet24",
	size = 20,
	weight = 1000
})

hook.Add("HUDPaint", "sbv_nametags", function()
	local lpp = LocalPlayer():GetPos()
	
	for k, v in ipairs(player.GetAll()) do
		local ply = player.GetAll()[k]
		
		if ply then
			if ply ~= LocalPlayer() then
				local plyp = ply:GetPos()
				--local dist = math.sqrt(math.Distance(lpp.x, lpp.y, plyp.x, plyp.y)^2+math.abs(lpp.z - lpp.z)^2)
				local dist = math.sqrt((lpp.x - (plyp.x))^2 + (lpp.y - (plyp.y))^2 + (lpp.z - (plyp.z))^2)
				local color = ColorAlpha(team.GetColor(ply:Team()), (3000-dist))
				local color2 = ColorAlpha(team.GetColor(Color(255, 255, 255), (1000-dist))
				
				local screenPos = (ply:EyePos() + Vector(0, 0, 25)):ToScreen()
				
				draw.DrawText(ply:Name(), "sbv_nametags", screenPos.x, screenPos.y, color, TEXT_ALIGN_CENTER)
				draw.DrawText(ply:GetNWString("sbv_title"), "sbv_nametags", screenPos.x, screenPos + 20, color, TEXT_ALIGN_CENTER)
			end
		end
	end
end)