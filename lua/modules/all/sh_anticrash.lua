--[[if SERVER then
	local prev_time = SysTime()
	local laggInt = 0
	local reset = false
	
	util.AddNetworkString("dadam_antilag")
	
	local function FreezeDemProps()
		for k, v in pairs(ents.FindByClass("prop_*")) do
			local phys = v:GetPhysicsObject()
			if (IsValid(phys)) then
				phys:EnableMotion(false)
			end
		end
	end
	
	function FindByName(name)
		local pls = player.GetAll()
		for k,v in pairs(pls) do
			if v:GetName():lower():find(name) then 
				return v 
			end
		end
	end
	
	hook.Add("Think", "dadam_antilag", function()
		local cur_time = SysTime() 
		--FindByName("dadamrival"):ChatPrint("DEBUG: "..cur_time-prev_time)
		if cur_time-prev_time > 0.02 then
			if laggInt < 1 then
				laggInt = math.Clamp(laggInt+0.1, 0, 1)
				
				--FindByName("dadamrival"):ChatPrint("DEBUG: "..laggInt)
				
				if laggInt == 1 && not reset then
					FreezeDemProps()
					
					net.Start("dadam_antilag")
					net.WriteInt(table.Count(ents.FindByClass("prop_*")), 32)
					net.Broadcast()
					
					timer.Simple(5, function()
						laggInt = 0
						
						reset = false
					end)
					
					reset = true
					
					--FindByName("dadamrival"):ChatPrint("DEBUG: LAGGGG!")
				end
			end
		else
			laggInt = math.Clamp(laggInt-0.01, 0, 1)
			
			--if laggInt != 0 then
			--	FindByName("dadamrival"):ChatPrint("DEBUG: "..laggInt)
			--end
		end
		
		prev_time = cur_time
	end)
else
	net.Receive("dadam_antilag", function()
		local props = net.ReadInt(32)
		
		chat.AddText(Color(100, 100, 255), "Lag detected! All props ", Color(255, 255, 255), "["..props.."]", Color(100, 100, 255), " have been frozen.")
	end)
end]]