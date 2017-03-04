hook.Add("ULibLocalPlayerReady", "dadam_flatgrasstime", function(plyrdy)
	timer.Simple(1, function()
		if game.GetMap() == "gm_flatgrass" then
			-- Remove Flattywood and small city in background
			Material("gm_construct/flatsign"):SetInt("$alpha", 0)
			Material("gm_construct/citycard01"):SetInt("$alpha", 0)

			hook.Add("PostDrawOpaqueRenderables", "dadam_flatgrastime", function()
				cam.Start3D2D(Vector(-5058.207031, 0.759911, -15310.609375), Angle(0, 95, 70), 5)

				draw.SimpleText(os.date("%H:%M:%S", os.time()), "DermaLarge", 10, 7)

				cam.End3D2D()
			end)
		end
	end)
end)
