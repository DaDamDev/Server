if SERVER then
	-- // Mats //
	resource.AddFile("garrysmod/materials/hud/bullet2.png")
end

if CLIENT then
--[[###################################################################################----
								Vars n Stuff
----###################################################################################]]--

local ShineFontSettings = {
	font = "Roboto",
	extended = false,
	size = 24,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
}
surface.CreateFont("ShineFont", ShineFontSettings)
	
local Mats = {}


--[[###################################################################################----
								Good to use Functions
----###################################################################################]]--
local function Col(r, g, b, a)

	-- // Creates Color //
	return Color(
		r,
		b and g or r,
		b or r,
		a and a or (b and 255 or g)
	)

end

local function colMul(color, mul)
	return Col(color.r * mul, color.g * mul, color.b * mul, color.a * mul)
end

local function colAdd(col1, col2)
	return Col(col1.r + col2.r, col1.g + col2.g, col1.b + col2.b, col1.a + col2.a)
end

local function colSetA(color, a)
	return Col(color.r, color.g, color.b, a)
end

local function LerpCol(t, start, End)
	return colAdd(colMul(start, 1 - t), colMul(End, t))
end

local function vec(x, y)

	-- // Create a Table and trys to be a Vector() //
	return {x = x, y = y or x, z = z or 0}

end


--[[###################################################################################----
								Functions
----###################################################################################]]--
Mats.blur = Material("pp/blurscreen")
local function DrawBlurRect(x, y, w, h, amt)

	-- // Gets and Sets the Material /////////////
	
	surface.SetMaterial(Mats.blur)
	surface.SetDrawColor(255, 255, 255, 255)
	-- ///////////////////////////////////////////

	-- // Draws the limited Area /////////////////
	render.SetScissorRect(x, y, x + w, y + h, true)

		-- // Blur Magic ///////////////////////////
		for i = 1, amt, .25 do
			Mats.blur:SetFloat("$blur", amt)
			Mats.blur:Recompute()
			render.UpdateScreenEffectTexture()

			surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
		end
		-- /////////////////////////////////////////

	render.SetScissorRect(0, 0, 0, 0, false)
	-- ///////////////////////////////////////////
end


local fonts = {}
local function getFont(name, size, tbl)
	if not fonts[name] then
		fonts[name] = {}
	end

	local fontname = name .. "_" .. size
	if not fonts[name][tostring(size)] then
		local tmp = table.Copy(tbl)
		tmp.size = size

		surface.CreateFont(fontname, tmp)
		fonts[name][tostring(size)] = fontname
	end

	return fontname
end



local function drawText(text, x, y, aglinX, aglinY, spacing, color, font)

	-- // Check and if not replace with default  //
	font = font or "DebugFixed"
	color = color or Col(255)
	spacing = spacing or 0
	-- ////////////////////////////////////////////

	-- //  Aglinment on X and Y ///////////////////
	-- Things needs to be set
	surface.SetFont(font)
	local w, h = 0, 0

	-- Giving supports for Multilines
	local words = string.Explode("\n", text)
	local lines = #words

	for i = 1, lines do
		-- Getting Size
		local strW, strH = surface.GetTextSize(text)

		-- Setting our Width and Hight Scale for the text
		w = math.max(w, strW)
		h = h + strH / lines + spacing * (i == lines and 0 or 1)
	end

	-- Correcting X and Y
	local corX = x - w / 2 * aglinX
	local corY = y - h / 2 * aglinY
	-- ///////////////////////////////////////////


	-- //  Aglinment on X  ///////////////////////
	for i = 1, lines do
		local steps = corY + (h + spacing) / lines * (i - 1)

		surface.SetTextColor(color)
		surface.SetTextPos(corX, steps)
		surface.DrawText(words[i])
	end
	-- ///////////////////////////////////////////

	return w, h

end


local function drawLine(x1, y1, x2, y2, thickness)

	-- //  Calculation  //////////////////////////
	local ang = math.rad(Vector(x2 - x1, y2 - y1):Angle().y)

	local tmp = {
		vec(x1 - math.sin(ang) * thickness, y1 + math.cos(ang) * thickness),
		vec(x1 + math.sin(ang) * thickness, y1 - math.cos(ang) * thickness),
		vec(x2 + math.sin(ang) * thickness, y2 - math.cos(ang) * thickness),
		vec(x2 - math.sin(ang) * thickness, y2 + math.cos(ang) * thickness)
	}
	-- ///////////////////////////////////////////

	surface.DrawPoly(tmp)
end


--[[###################################################################################----
								Elements
----###################################################################################]]--

local Elements = {}
HUDState = {}
HUDState.__index = HUDState

HUDMagazine = {}
HUDMagazine.__index = HUDMagazine


-- //  Body  //////////////////////////
function HUDState:SetPos(x, y) self.x = x; self.y = y end
function HUDState:SetSize(w, h) self.w = w; self.h = h end
function HUDState:SetGap(number) self.gap = number end
function HUDState:SetBlur(number) self.blur = number end
function HUDState:MapToScreen(resW, resH, scrW, scrH)
	self.x = math.Remap(scrW, 0, resW, 0, self.x)
	self.y = math.Remap(scrH, 0, resH, 0, self.y)

	local oldw = self.w
	self.w = math.Remap(scrW, 0, resW, 0, self.w)
	local oldh = self.h
	self.h = math.Remap(scrH, 0, resH, 0, self.h)

	self.textsize = math.Remap(self.h, 0, oldh, 0, self.textsize)
	self.thickness = math.Remap(self.h, 0, oldh, 0, self.thickness)
	self.gap = math.Remap(self.w, 0, oldw, 0, self.gap)
end
function HUDState:SetVisible(boolean) self.visible = boolean end
function HUDState:SetVisibleSpeed(number) self.visibleSpeed = number end

-- //  Bar  //////////////////////////
function HUDState:SetThickness(number) self.thickness = number end
function HUDState:SetLerpSpeed(number) self.lerpspeed = number end
function HUDState:SetTrailSpeed(number) self.trailspeed = number end
function HUDState:DrawTrail(boolean) self.drawTrail = boolean end
function HUDState:ShowBar(boolean) self.showbar = boolean end


-- //  Text  //////////////////////////
function HUDState:SetPrefix(string) self.prefix = string end
function HUDState:SetSuffix(string) self.suffix = string end
function HUDState:SetTextSize(number) self.textsize = number end
function HUDState:OffsetTextY(number) self.textOffY = number end

-- //  Value  //////////////////////////
function HUDState:SetValue(number) self.val = number end
function HUDState:ShowValue(boolean) self.showval = boolean end
function HUDState:SetMaxValue(number) self.maxval = number end
function HUDState:SetRoundVal(number) self.roundval = number end

function HUDState:AutoMax(boolean)
	self.autoMax = boolean and function(self)
		if self.val > self.maxval then
			self.maxval = self.val
		end
	end or function() end
end


-- //  Get  //////////////////////////
function HUDState:GetX() return self.x end
function HUDState:GetY() return self.y end
function HUDState:GetW() return self.w end
function HUDState:GetH() return self.h end
function HUDState:GetGap() return self.gap end
function HUDState:GetBlur() return self.blur end


function HUDState:GetThickness() return self.thickness end
function HUDState:GetLerpSpeed() return self.lerpspeed end
function HUDState:GetTrailSpeed() return self.trailspeed end

function HUDState:GetPrefix() return self.prefix end
function HUDState:GetSuffix() return self.suffix end
function HUDState:GetTextSize() return self.textsize end

function HUDState:GetValue() return self.val end
function HUDState:GetLastValue() return self.lastval end
function HUDState:GetLerpValue() return self.lerpval end
function HUDState:GetShowValue() return self.showval end
function HUDState:GetMaxValue() return self.maxval end
function HUDState:GetRoundVal() return self.roundval end

function HUDState:Colors() return self.colors end



-- ///////////////////////////////////////////
local function createHUDState(x, y, w, h)
	local self = setmetatable({}, HUDState)

	-- // Vals ///////////////////////////////////
	self.visible = true
	self.x = x
	self.y = y
	self.w = w
	self.h = h

	self.lerpw = 0
	self.realw = 0

	self.prefix = ""
	self.suffix = ""
	self.textsize = 24
	self.showval = true
	self.textOffY = 0

	self.lastval = 0
	self.val = 0
	self.roundval = 0
	self.lerpval = 0
	self.maxval = 0

	self.blur = 2
	self.gap = w / 32
	self.thickness = h / 4
	self.drawTrail = true
	self.showbar = true

	self.colors = {
		bar = Col(255),
		underbar = Col(0, 50),
		background = Col(0, 50),
		outline = Col(255, 50),

		text = Col(255),

		gain = Col(50, 255, 50, 150),
		lose = Col(255, 50, 50, 150),

		fade = Col(0)
	}

	self.lerpspeed = 6
	self.trailspeed = 1
	self.visibleSpeed = 6

	self.t1 = 0
	self.t2 = 0

	self.autoMax = function() end
	-- ///////////////////////////////////////////


	-- // Functions //////////////////////////////
	self.update = function(self)
		-- // auto funcs //
		self.autoMax(self)

		-- // Smooths Val //
		local lerpt = math.Round(FrameTime() * self.lerpspeed, 2)
		self.lerpw = Lerp(lerpt, self.lerpw, self.realw)
		self.lerpval = Lerp(lerpt, self.lerpval, self.val)

		self.t2 = math.Clamp(self.visible and self.t2 + FrameTime() * self.visibleSpeed or self.t2 - FrameTime() * self.visibleSpeed, 0, 1)

		-- // Trail time //
		self.t1 = math.min(self.t1 + FrameTime() * self.trailspeed, 1)
		self.t1 = math.Round(self.lerpval, 2) != self.val and 0 or self.t1
		self.lastval = Lerp(self.t1, self.lastval, self.val)
	end



	self.render = function(self)
		if self.t2 > 0 then
			local col = self.colors

			-- // Blur Rect //
			surface.SetDrawColor(Col(255))
			DrawBlurRect(self.x, self.y, self.lerpw, self.h, Lerp(self.t2, 0, self.blur))
			draw.NoTexture()


			-- // Outline //
			surface.SetDrawColor(LerpCol(self.t2, colSetA(col.outline, 0), col.outline))
			surface.DrawOutlinedRect(self.x, self.y, self.lerpw, self.h)


			-- // Background //
			surface.SetDrawColor(LerpCol(self.t2, colSetA(col.background, 0), col.background))
			surface.DrawRect(self.x, self.y, self.lerpw, self.h)


			-- // Text //
			local textcol = LerpCol(self.t2, colSetA(col.text, 0), col.text)
			local text = self.prefix .. (self.showval and math.Round(self.val, self.roundval) or "") .. self.suffix
			local font = getFont("ShineFont", self.textsize, ShineFontSettings)
			local x, y = self.x + self.gap, self.y + self.h / 2 + self.textOffY
			local tw, th = drawText(text, x, y, 0, 1, 0, textcol, font)
			self.realw = tw + self.gap * 2

			--// Gain and Lose //
			local changecol = self.val > self.lastval and col.gain or col.lose
			col.fade = LerpCol(self.t1, changecol, col.bar)

			if self.showbar then
				-- // Below Bar //
				surface.SetDrawColor(LerpCol(self.t2, colSetA(col.underbar, 0), col.underbar))

				local y = self.y + self.h / 2
				local min = self.x + tw + self.gap * 2
				local max = self.x + self.lerpw - self.gap
				self.realw = self.w

				drawLine(min, y, max, y, self.thickness)


				-- // Bar //
				surface.SetDrawColor(LerpCol(self.t2, colSetA(col.bar, 0), col.bar))
				local progress = math.Remap(math.min(self.lerpval, self.maxval), 0, self.maxval, min, max)
				drawLine(min, y, progress, y, self.thickness)


				-- // Trail Bar //
				if self.drawTrail then
					local fade = colSetA(changecol, changecol.a * (1 - self.t1))
					surface.SetDrawColor(LerpCol(self.t2, colSetA(fade, 0), fade))

					local trail = math.Remap(self.t1, 0, 1, math.Remap(math.min(self.lastval, self.maxval), 0, self.maxval, min, max), progress)
					drawLine(progress, y, trail, y, self.thickness)
				end
			end
		end
	end
	-- ///////////////////////////////////////////

	table.insert(Elements, self)
	return self
end



local function createHUDMagazine(x, y, w, h)
	local self = setmetatable({}, HUDState)

	-- // Vals ///////////////////////////////////
	self.visible = true
	self.x = x
	self.y = y
	self.w = w
	self.h = h

	self.textsize = 24
	self.showtext = true

	self.val1 = 0
	self.val2 = 0
	self.val3 = 0
	self.val4 = 0

	self.textLeft = function(self)
		return self.val1 .. " / " .. self.val2
	end

	self.textRight = function(self)
		return self.val4 >= 0 and self.val4 or ""
	end

	self.blur = 2
	self.gap = w / 32

	self.bullets = true
	self.bulletSize = 16
	self.bulletgap = 4
	self.bulletPath = "garrysmod/materials/hud/bullet2.png"
	self.bulletMat = Material(self.bulletPath)
	self.bulletAng = 90
	self.bulletOffsets = {
		x = 0,
		y = 0,
		w = self.bulletSize / 4,
		h = h / 4 - self.gap,
	}

	self.colors = {
		line = Col(0, 50),
		background = Col(0, 50),
		outline = Col(255, 50),

		bullet = Col(255),
		nobullet = Col(0, 150),
		text = Col(255),
	}

	self.t1 = 1

	-- ///////////////////////////////////////////


	-- // Functions //////////////////////////////
	self.update = function(self)

	end



	self.render = function(self)
		if self.t1 > 0 then
			local col = self.colors

			-- // Blur Rect //
			surface.SetDrawColor(Col(255))
			DrawBlurRect(self.x, self.y, self.w, self.h, Lerp(self.t1, 0, self.blur))
			draw.NoTexture()


			-- // Outline //
			surface.SetDrawColor(LerpCol(self.t1, colSetA(col.outline, 0), col.outline))
			surface.DrawOutlinedRect(self.x, self.y, self.w, self.h)


			-- // Background //
			surface.SetDrawColor(LerpCol(self.t1, colSetA(col.background, 0), col.background))
			surface.DrawRect(self.x, self.y, self.w, self.h)


			-- // Text //
			local textcol = LerpCol(self.t1, colSetA(col.text, 0), col.text)
			local font = getFont("ShineFont", self.textsize, ShineFontSettings)
			local tw, th = surface.GetTextSize(self.textLeft(self))
			local x, y = self.x + self.gap, self.y + th / 4 + self.gap
			drawText(self.textLeft(self), x, y, 0, 1, 0, textcol, font)

			local tw, th = surface.GetTextSize(self.textRight(self))
			local x, y = self.x + self.w - self.gap - tw / 2, self.y + th / 4 + self.gap
			drawText(self.textRight(self), x, y, 2, 1, 0, textcol, font)


			-- // Line //
			surface.SetDrawColor(LerpCol(self.t1, colSetA(col.line, 0), col.line))
			drawLine(self.x + self.gap, self.y + th + self.gap / 2, self.x + self.w - self.gap, self.y + th + self.gap / 2, self.thickness)


			-- // Mat //
			surface.SetMaterial(self.bulletMat)
			local off = self.bulletOffsets
			local rad = math.abs(math.rad(self.bulletAng))
			local sx = self.bulletSize + Lerp(math.cos(rad), off.w, off.h)
			local sy = self.bulletSize + Lerp(math.sin(rad), off.w, off.h)

			local realw = sx / 4

			for i = 1, (self.w - self.gap * 2) / (realw + self.bulletgap) do
				local x = self.x + self.gap + (self.bulletgap + realw) * (i - 1) - realw
				local y = self.y + self.h - self.gap - sy

				surface.SetDrawColor(LerpCol(self.t1, colSetA(col.bullet, 0), col.bullet))
				surface.DrawTexturedRectRotated(x + sx / 2, y + sy / 2, self.bulletSize + off.h, self.bulletSize + off.w, self.bulletAng)
			end
		end
	end
	-- ///////////////////////////////////////////

	table.insert(Elements, self)
	return self
end



local function drawElements()
	for k, v in pairs(Elements) do
		v.update(v)
		v.render(v)
	end
end



--[[###################################################################################----
								Setup
----###################################################################################]]--


-- // Health //
local hpHUD = createHUDState(10, 1080 - 40, 256, 30)
local hpHUDcol = hpHUD:Colors()
hpHUD:SetMaxValue(100)
hpHUD:SetThickness(1)
hpHUD:SetTextSize(24)
hpHUD:AutoMax(true)
hpHUD:SetGap(10)
hpHUD:MapToScreen(1920, 1080, ScrW(), ScrH())

-- God : 255, 215, 0
-- Normal : 50, 255, 139
hpHUDcol.bar = Col(50, 255, 139)
hpHUDcol.gain = Col(0, 180, 255, 255)
--hpHUDcol.gain = Col(174, 92, 255, 255)
hpHUDcol.lose = Col(255, 100, 100, 150)
hpHUDcol.background = Col(0, 100)



-- // Armor //
local armorHUD = createHUDState(10, 1080 - 75, 256, 30)
local armorHUDcol = armorHUD:Colors()
armorHUD:SetMaxValue(100)
armorHUD:SetThickness(1)
armorHUD:SetTextSize(24)
armorHUD:AutoMax(true)
armorHUD:SetGap(10)
armorHUD:MapToScreen(1920, 1080, ScrW(), ScrH())

armorHUDcol.bar = Col(52, 198, 255)
--armorHUDcol.gain = Col(255, 150, 20, 255)
armorHUDcol.lose = Col(174, 92, 255, 255)
--armorHUDcol.lose = Col(255, 100, 100, 150)
armorHUDcol.gain = Col(255, 84, 253, 200)
armorHUDcol.background = Col(0, 100)


--
-- // Ammo //
local w, h = 256, 70
local ammoHUD = createHUDMagazine(1920 - w - 10, 1080 - h - 10, w, h)
local ammoHUDcol= ammoHUD:Colors()
ammoHUD:SetMaxValue(100)
ammoHUD:SetThickness(1)
ammoHUD:SetTextSize(24)
ammoHUD:AutoMax(true)
ammoHUD:SetGap(10)
ammoHUD:MapToScreen(1920, 1080, ScrW(), ScrH())
]]


--[[###################################################################################----
								The Hooks
----###################################################################################]]--
local me = LocalPlayer()


hook.Remove("HUDPaint", "dadam_hud")


local time = 0
hook.Add("HUDPaint", "Render_HUD_Shine", function()
	me = LocalPlayer()
	-- // Values //
	local hp = math.max(me:Health(), 0)
	hpHUD:SetValue(hp)

	local suit = me:Armor()
	armorHUD:SetValue(suit)

	-- resets after death
	if not me:Alive() then
		hpHUD:SetMaxValue(100)

		armorHUD:SetMaxValue(100)
		armorHUD:SetValue(0)
	end

	-- fancy colors
	hpHUD:SetSuffix(hp <= 0 and "dead..." or "")
	local god = me:HasGodMode()

	local state = Col(50, 255, 139)
	hpHUD:OffsetTextY(0)
	if god then
		state = Col(255, 215, 0)
		hpHUD:SetSuffix("∞")
		hpHUD:OffsetTextY(math.Remap(ScrH(), 0, 1080, 0, -1.5))
	end

	hpHUD:ShowBar(!god and hp > 0)
	hpHUD:ShowValue(!god and hp > 0)

	hpHUDcol.bar = LerpCol(FrameTime() * 6, hpHUDcol.bar, state)
	hpHUDcol.text = hpHUDcol.fade
	hpHUDcol.outline = colSetA(hpHUDcol.fade, 35)



	-- // Armor //
	armorHUDcol.outline = colSetA(armorHUDcol.fade, 35)
	armorHUDcol.text = armorHUDcol.fade

	armorHUD:SetVisible(armorHUD:GetValue() > 0 and not god)
	armorHUD:ShowBar(armorHUD:GetValue() > 0 and not god)
	
	ammoHUD.t1 = 0
	if me:GetActiveWeapon():IsValid() then
		local weapon = me:GetActiveWeapon()
		ammoHUD.val1 = weapon:Clip1() -- Current Clip
		ammoHUD.val3 = weapon:GetMaxClip1() -- Max Clip Size
		ammoHUD.val2 = me:GetAmmoCount(weapon:GetPrimaryAmmoType()) -- Total Ammo
		ammoHUD.val4 = me:GetAmmoCount(weapon:GetSecondaryAmmoType()) -- 2nd Ammo Type
		
		if ammoHUD.val1 > 0 then
			ammoHUD.t1 = 1
		end
	end



	drawElements()
end)


local hudHide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true
}

hook.Add("HUDShouldDraw", "ShineHUD", function(name)
	if hudHide[name] then return false end
end)

end
