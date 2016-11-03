--[[local reqTime = {}
reqTime[26] = 48*60*60 --Regular
reqTime[27] = 24*60*60 --Player

local teams = {}
teams[26] = "regular"
teams[27] = "player"]]--

timer.Create("dadam_autorank", 10, 0, function()
	--[[for k, ply in pairs(player.GetAll()) do
		for rank, time in pairs(reqTime) do
			if tonumber(ply:GetTime()) > time and ply:Team() > rank && ply:Team() != 29 then
				game.ConsoleCommand("ulx adduser $"..ply:SteamID().." "..teams[rank].."\n")
			end
		end
	end]]--
	if not ply:IsBot() then
		if team.GetName(ply:Team()) == "Guest" and ply:GetTime() > 24*60*60 then
			game.ConsoleCommand("ulx adduser $"..ply:SteamID().." player\n")
		elseif team.GetName(ply:Team()) == "Player" and ply:GetTime() > 48*60*60 then
			game.ConsoleCommand("ulx adduser $"..ply:SteamID().." regular\n")
		end
	end
end)