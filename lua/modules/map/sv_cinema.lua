if game.GetMap() ~= "gm_cloudbuild" then return end


local box = {
	min = Vector(8112, -3152, 600),
	max = Vector(9291, -2093, 947),
}
	

local function isInCinema(e)
	return e:GetPos():WithinAABox(box.min, box.max)
end

if CLIENT then
	local function findMediaPlayer()
		local e = ents.FindInSphere(Vector(8100.031, -3083.963, 923.935), 20)
		for _, ent in ipairs(e) do
			if ent:GetClass() == "mediaplayer_tv" and ent:GetModel() == "models/hunter/blocks/cube025x025x025.mdl" then
				return ent
			end
		end
		return false
	end
	
	
	-- Sidebar
	hook.Remove("OnContextMenuOpen", "MP.ShowSidebar")
	hook.Add("OnContextMenuOpen", "sbv_Cinema_MediaPlayerSidebar", function()
		local mp = findMediaPlayer()
		
		if IsValid(mp) and isInCinema(LocalPlayer()) then
			MediaPlayer.ShowSidebar(mp:GetMediaPlayer())
		else
			MediaPlayer.ShowSidebar()
		end
	end)
	
	
	list.Set( "MediaPlayerModelConfigs", "models/hunter/blocks/cube025x025x025.mdl", {
		offset = Vector(1,0,0),
		angle = Angle(0, 90, 90),
		width = 408,
		height = 280,
	})
	
	
	return
end


hook.Add("Initialize", "sbv_Cinema", function()
	timer.Simple(5, function()
		local e = ents.Create("mediaplayer_tv")
		
		e:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		e:SetAngles(Angle(0, 0, 0))
		e:SetPos(Vector(8100.031, -3083.963, 923.935))
		
		
		e:Spawn()
		e:SetOwner(Entity(0))
		e:SetNoDraw(true)
		hook.Add("PhysgunPickup", "sbv_Cinema", function(ply, ent) if ent == e then return false end end)
		
		
		local isInside = {}
		hook.Add("Move", "sbv_Cinema_Listener", function(ply, mv)
			local inside = isInCinema(ply)
			local mp = e:GetMediaPlayer()
			if inside and not isInside[ply] then
				-- Entered
				if not mp:HasListener(ply) then
					mp:AddListener(ply)
				end
				isInside[ply] = true
			elseif not inside and isInside[ply] then
				-- Left
				if mp:HasListener(ply) then
					mp:RemoveListener(ply)
				end
				isInside[ply] = false
			end
		end)
	end)
end)
		
