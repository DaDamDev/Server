surface.CreateFont("dadam_nametags_font", {
	font = "Trebuchet24",
	size = 20,
	weight = 1000
} )

hook.Add("ULibLocalPlayerReady", "dadam_nametags", function(plyrdy)
	hook.Add("HUDPaint", "dadam_nametags", function()
		local lpp = LocalPlayer():GetPos()
		
		for k, v in ipairs(player.GetAll()) do
			local ply = player.GetAll()[k]
			
			if ply then
				if ply != LocalPlayer() then
					local plyp = ply:GetPos()
					--local dist = math.sqrt(math.Distance(lpp.x, lpp.y, plyp.x, plyp.y)^2+math.abs(lpp.z - lpp.z)^2)
					local dist = math.sqrt((lpp.x - (plyp.x))^2 + (lpp.y - (plyp.y))^2 + (lpp.z - (plyp.z))^2)
					local color = ColorAlpha(team.GetColor(ply:Team()), (3000-dist))
					
					draw.DrawText(ply:Name(), "dadam_nametags_font", ply:EyePos():ToScreen().x, (ply:EyePos() + Vector(0, 0, 25)):ToScreen().y, color, TEXT_ALIGN_CENTER)
				end
			end
		end
	end)
end)
