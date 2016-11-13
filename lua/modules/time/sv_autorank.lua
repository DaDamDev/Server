timer.Create("dadam_autorank", 5, 0, function()
	for k, ply in pairs(player.GetAll()) do
		if not ply:IsBot() then
			if team.GetName(ply:Team()) == "Guest" and tonumber(ply:GetTime()) > 24*60*60 then
				game.ConsoleCommand("ulx adduser $"..ply:SteamID().." player\n")
			end
			
			if team.GetName(ply:Team()) == "Player" and tonumber(ply:GetTime()) > 48*60*60 then
				game.ConsoleCommand("ulx adduser $"..ply:SteamID().." regular\n")
			end
		end
	end
end)