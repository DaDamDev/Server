hook.Add("PlayerSay", "sbv_noteam", function(ply, text, isTeam)
	if isTeam then
		ply:Say(text)
		
		return ""
	end
end)