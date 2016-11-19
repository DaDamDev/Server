--[[
	This is a modified version!
	Link: http://steamcommunity.com/sharedfiles/filedetails/?id=659490574
]]

local pMeta = FindMetaTable("Player")

if not __PLAYER_NICK then __PLAYER_NICK = pMeta.Nick end

function pMeta:GetName()
	return self:GetNWString("fakename", __PLAYER_NICK(self))
end

function pMeta:SetFakeName(newname)
	if SERVER then
		self:SetNWString("fakename", newname)
	end
end

pMeta.Nick = pMeta.GetName
pMeta.Name = pMeta.GetName
