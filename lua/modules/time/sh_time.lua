module("time", package.seeall)

local meta = FindMetaTable("Player")
if not meta then return end

function meta:GetTime()
	return self:GetNWFloat("TotalTime")
end

function meta:SetTime(num)
	self:SetNWFloat("TotalTime", num)
end

function meta:GetTimeStart()
	return self:GetNWFloat("TimeStart")
end

function meta:SetTimeStart( num )
	self:SetNWFloat("TimeStart", num)
end

function meta:GetTimeSessionTime()
	return CurTime() - self:GetTimeStart()
end

function meta:GetTimeTotalTime()
	return self:GetTime() + CurTime() - self:GetTimeStart()
end

function timeToStr(time)
	local tmp = time
	local s = tmp % 60
	tmp = math.floor(tmp/60)
	local m = tmp % 60
	tmp = math.floor(tmp/60)
	local h = tmp % 24
	tmp = math.floor(tmp/24)
	local d = tmp % 7
	local w = math.floor(tmp/7)

	return string.format("%02iw %id %02ih %02im %02is", w, d, h, m, s)
end