hook.Add("ULibLocalPlayerReady", "dadam_tips", function()
	CreateClientConVar("ddd_tips", "1", true, false, "This toggle if tips will be displayed in chat.")

	-- Small capitalized "TIP"
	local tip = string.char(225, 180, 133, 225, 180, 133, 225, 180, 133, 225, 180, 135, 225, 180, 160)

	local tips = {
		"Type quit in console to leave the game",
		"Want to make Garry's Mod more enjoyable? Type 'voice_enable 0' in console",
		"Type '!setspawn' in chat to set your spawn and '!resetspawn' to reset it",
		"You get autoranked to Player/Regular after 24/48h of playtime on the server",
		"Type '!setings' in chat to open the settings menu"
	}

	function dadam.Tip(msg)
		--surface.PlaySound("npc/roller/mine/rmine_chirp_quest1.wav")
		chat.AddText(Color(197, 197, 141), tip, Color(255, 255, 255), ": ", Color(197, 197, 141), msg)
	end

	timer.Create("dadam_tips", 120, 0, function()
		if GetConVar("ddd_tips"):GetBool() then
			dadam.Tip(tips[math.Round(math.Rand(0.5, #tips + 0.499))])
		end
	end)
end)