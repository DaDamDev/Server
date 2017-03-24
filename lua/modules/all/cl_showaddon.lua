hook.Add("OnPlayerChat", "dadam_showaddon", function(p, t)
	t = string.Trim(t)

	local _, s = t:find("http[s]?://steamcommunity%.com/sharedfiles/filedetails/%?id=%d")
	
	local isLink
	if s then
		isLink = true
		t = t:sub(s)
	end
	
	if tonumber(t) then
		steamworks.FileInfo(t, function(result)
			if result and result.title and result.title ~= "" then
				if result.installed then
					chat.AddText(Color(200, 50, 50), "Addon: ", Color(255, 255, 255), result.title, Color(50, 200, 50), " (installed)")
				else
					chat.AddText(Color(200, 50, 50), "Addon: ", Color(255, 255, 255), result.title)
				end
				
				if not isLink then
					chat.AddText(Color(170, 170, 170), "https://steamcommunity.com/sharedfiles/filedetails/?id=" .. t)
				end
			end
		end)
	end
end)
