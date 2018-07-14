local meta = FindMetaTable("Player")

if SERVER then
	local playerGodDisable = meta.GodDisable
	function meta:GodDisable()
		self:SetNWBool("hasgodmode", false)
		
		playerGodDisable(self)
	end
	
	local playerGodEnable = meta.GodEnable
	function meta:GodEnable()
		self:SetNWBool("hasgodmode", true)
		
		playerGodEnable(self)
	end
	
	
	local function disable(ply)
		ply:GodDisable()
	end
	
	hook.Add("PlayerDeath", "sbv_godmode", disable)
	hook.Add("PlayerSilentDeath", "sbv_godmode", disable)
end

function meta:HasGodMode()
	return self:GetNWBool("hasgodmode")
end