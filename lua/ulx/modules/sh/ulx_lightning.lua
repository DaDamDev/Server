local data = {}

local function Lightning(calling_ply, target_plys)
	for _, ply in ipairs(target_plys) do
		if not ply:Alive() then
			ULib.tsay(calling_ply, ply:Nick() .. " is dead!", true)
			return
		end
		if ply.jail then
			ULib.tsay(calling_ply, ply:Nick() .. " is in jail", true)
			return
		end
		if ply.ragdoll then
			ULib.tsay(calling_ply, ply:Nick() .. " is a ragdoll", true)
			return
		end	
		
		ply:StripWeapons()
		ply:SetShouldServerRagdoll(true)
		ply:KillSilent()

		local ent = ents.Create("prop_ragdoll")
		ent:SetModel(ply:GetModel())
		ent:SetPos(ply:GetPos())
		ent:Spawn()
		ent:GetPhysicsObject():ApplyForceCenter(Vector(0, 0, -10000000))
		ent:SetOwner(ply)
		ent:EmitSound("ambient/atmosphere/thunder1.wav", 100, 125, 1, CHAN_AUTO)
		
		data[ply] = ent
		
		local bones = {
			"ValveBiped.Bip01_Head1",
			"ValveBiped.Anim_Attachment_RH",
			"ValveBiped.Bip01_Spine",
			"ValveBiped.Bip01_R_Hand",
			"ValveBiped.Bip01_R_Forearm",
			"ValveBiped.Bip01_R_Foot",
			"ValveBiped.Bip01_R_Thigh",
			"ValveBiped.Bip01_R_Calf",
			"ValveBiped.Bip01_R_Shoulder",
			"ValveBiped.Bip01_R_Elbow",
			"ValveBiped.Anim_Attachment_LH",
			"ValveBiped.Bip01_L_Hand",
			"ValveBiped.Bip01_L_Forearm",
			"ValveBiped.Bip01_L_Foot",
			"ValveBiped.Bip01_L_Thigh",
			"ValveBiped.Bip01_L_Calf",
			"ValveBiped.Bip01_L_Shoulder",
			"ValveBiped.Bip01_L_Elbow"
		}
		
		for _, v in pairs(bones) do
			if ent:LookupBone(v) then
				ent:ManipulateBoneScale(ent:LookupBone(v), Vector(math.random(1, 50), math.random(1, 8), math.random(1, 8)))
			end
		end
		
		for i = 1, 25, 1 do
			timer.Simple(math.random(0, 100)/100, function()
				local effectdata = EffectData()
				effectdata:SetOrigin(ent:GetPos() + Vector(math.random(-20, 20), math.random(-20, 20), math.random(0, 50)))
				effectdata:SetStart(ent:GetPos() + Vector(math.random(-100, 100), math.random(-100, 100), 500 + math.random(-50, 50)))
				util.Effect("ToolTracer", effectdata)
			end)
		end
	end
	
	ulx.fancyLogAdmin(calling_ply, "#A has stricken lightning on #T!", target_plys)
end

hook.Add("PlayerSpawn", "dadam_lightning", function(plyS)
	for ply, ent in pairs(data) do
		if ply == plyS and ent then
			ent:Remove()
			data[ply] = nil
		end
	end
end)

local cmd = ulx.command("Fun", "ulx lightning", Lightning, "!spark")
cmd:addParam{type = ULib.cmds.PlayersArg}
cmd:defaultAccess(ULib.ACCESS_ADMIN)
cmd:help("Strikes lightning on your poor victem.")
