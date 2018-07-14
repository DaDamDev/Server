--hook.Add("OnPlayerChat", "sbv_mention", function(ply, text, _, isDead)

--Done to not break stuff like sf's clientside OnPlayerChat hook
timer.Simple(0, function()
	function GAMEMODE:OnPlayerChat(ply, text, _, isDead)
		local newText = {}
		
		if isDead then
			table.insert(newText, Color(255, 0, 0))
			table.insert(newText, "{DEAD} ")
		end
		
		if ply:IsPlayer() then
			table.insert(newText, team.GetColor(ply:Team()))
			table.insert(newText, ply:Name())
		else
			table.insert(newText, Color(70, 110, 255))
			table.insert(newText, "Console")
		end
		
		table.insert(newText, Color(255, 255, 255))
		table.insert(newText, ": ")
		
		local curPos = 1
		local names = {}
		for k, ply in pairs(player.GetAll()) do
			local name = ply:Name()
			
			if name == "" then continue end
			
			names[ply] = name
		end
		
		while true do
			local match, startPos, endPos
			
			for ply, name in pairs(names) do
				local s, e = string.find(text, name, curPos)
				
				if s and (not startPos or s < startPos) then
					match = ply
					startPos = s
					endPos = e
				end
			end
			
			if not match then
				table.insert(newText, Color(255, 255, 255))
				table.insert(newText, string.sub(text, curPos, #text))
				
				break
			end
			
			table.insert(newText, Color(255, 255, 255))
			table.insert(newText, string.sub(text, curPos, startPos - 1))
			
			table.insert(newText, team.GetColor(match:Team()))
			table.insert(newText, match:Name())
			
			curPos = endPos + 1
		end
		
		chat.AddText(unpack(newText))
		return true
	end
end)