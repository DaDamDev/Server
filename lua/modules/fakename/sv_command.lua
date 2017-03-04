local function FindByName(name)
	for k, v in pairs(player.GetAll()) do
		if v:GetName():lower():find(name:lower()) then 
			return v 
		end
	end
end

hook.Add("PlayerSay", "dadam_fakename", function(ply, text, public)
	if string.sub(text, 1, 9) == "!fakename" then
		if ply:IsSuperAdmin() then
			local args = string.Explode(" ", string.sub(text, 11, #text))
			
			if #args == 1 then
				ply:ChatPrint("You have set your name to \""..string.sub(text, 11, #text).."\"")
				
				ply:SetFakeName(string.sub(text, 11, #text))
			elseif #args > 1 then
				local name = ""
				
				for i = 2, #args do
					name = name..args[i]
					
					if i < #args then
						name = name.." "
					end
				end
				
				FindByName(args[1]):ChatPrint("Your name has been set to \""..name.."\" by "..ply:Nick())
				ply:ChatPrint("You have set "..FindByName(args[1]):Nick().." name to \""..name.."\"")
				
				FindByName(args[1]):SetFakeName(name)
			end
		else
			ply:ChatPrint("You need to be SuperAdmin to use this command.")
		end
	end
end)
