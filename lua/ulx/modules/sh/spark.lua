function ulx.spark(calling_ply, target_plys)
	for _, ply in ipairs(target_plys) do
		if not ply:Alive() then
			return ULib.tsay(calling_ply, ply:Nick() .. " is dead", true)
		elseif ply.jail then
			return ULib.tsay(calling_ply, ply:Nick() .. " is in jail", true)
		elseif ply.ragdoll then
			return ULib.tsay(calling_ply, ply:Nick() .. " is a ragdoll", true)
		end	
		
		ply:Kill()
		
		local ragdoll = ply.corpse
		ragdoll:GetPhysicsObject():ApplyForceCenter(Vector(0, 0, -10000000))
		ragdoll:EmitSound("ambient/atmosphere/thunder1.wav", 100, 125, 1, CHAN_AUTO)
		
		for i = 0, ragdoll:GetBoneCount() do
			local id = ragdoll:TranslateBoneToPhysBone(i)

			if id ~= -1 then
				ragdoll:GetPhysicsObjectNum(id):ApplyForceCenter(Vector(math.random(-5000, 5000), math.random(-5000, 5000), math.random(0, 5000)))
			end
		end
		
		for i = 1, 25 do
			timer.Simple(math.random(0, 100)/100, function()
				local effectdata = EffectData()

				effectdata:SetOrigin(ragdoll:GetPos() + Vector(math.random(-20, 20), math.random(-20, 20), math.random(0, 50)))
				effectdata:SetStart(ragdoll:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), 500 + math.random(-50, 50)))

				util.Effect("ToolTracer", effectdata)
			end)
		end
	end
	
	ulx.fancyLogAdmin(calling_ply, "#A has stricken lightning upon #T!", target_plys)
end

local cmd = ulx.command("Fun", "ulx spark", ulx.spark, "!spark")
cmd:addParam{type = ULib.cmds.PlayersArg}
cmd:defaultAccess(ULib.ACCESS_ADMIN)
cmd:help("Strikes lightning upon your poor victem.")