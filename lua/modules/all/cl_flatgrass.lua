-----Spawn and skybox materials------
local function changeMat(org, rep, s)
    local m = Material(org)
    m:SetTexture("$basetexture", Material(rep):GetTexture("$basetexture"))
   
    local matrx = Matrix()
    local s = 2
    matrx:SetScale(Vector(s, s, s))
   
    m:SetMatrix("$basetexturetransform", matrx)
   
    -- Reflection
    m:SetUndefined("$envmap")
    m:SetUndefined("$envmapmask")
    m:SetUndefined("$envmapframe")
    m:SetUndefined("$envmapmaskframe")
    m:SetUndefined("$envmapmaskscale")
    m:SetUndefined("$envmapmasktransfom")
    m:SetUndefined("$envmapsaturation")
    m:SetUndefined("$envmaptint")
    m:SetUndefined("$reflectivity")
   
    m:Recompute()
end
 
hook.Add("ULibLocalPlayerReady", "dadam_flatgrass_material", function(plyrdy)
	local map = game.GetMap()
	 
	if map == "gm_flatgrass" then
		changeMat("maps/gm_flatgrass/concrete/concretefloor028c_0_1312_-12736", "phoenix_storms/roadside", 2)
		changeMat("maps/gm_flatgrass/concrete/concretefloor028c_0_96_-12032", "phoenix_storms/roadside", 2)
		changeMat("maps/gm_flatgrass/concrete/concretefloor028a_0_-31_-12736", "phoenix_storms/road", 2)
		changeMat("maps/gm_flatgrass/concrete/concretefloor028a_0_96_-12032", "phoenix_storms/roadside", 2)
		changeMat("maps/gm_flatgrass/concrete/concretefloor028c_0_480_-12736", "phoenix_storms/roadside", 2)
		changeMat("maps/gm_flatgrass/concrete/concretefloor028c_0_992_-12736", "phoenix_storms/roadside", 2)
		changeMat("maps/gm_flatgrass/concrete/concretefloor028c_0_-1439_-12736", "phoenix_storms/roadside", 2)
		changeMat("maps/gm_flatgrass/concrete/concretefloor028c_0_-991_-12736", "phoenix_storms/roadside", 2)
		changeMat("maps/gm_flatgrass/concrete/concretefloor028c_0_-543_-12736", "phoenix_storms/roadside", 2)
		changeMat("concrete/concreteceiling003a", "phoenix_storms/roadside", 2)
		changeMat("brick/brickwall053d", "phoenix_storms/roadside", 2)
		changeMat("brick/brickwall003a_construct", "phoenix_storms/road", 2)
	end
end)

-----Clocks, lights and that kind of stuff-----
hook.Add("ULibLocalPlayerReady", "dadam_flatgrass_cosmetic", function(plyrdy)
	timer.Simple(1, function()
		if game.GetMap() == "gm_flatgrass" then
			-- Remove Flattywood and small city in background
			Material("gm_construct/flatsign"):SetInt("$alpha", 0)
			Material("gm_construct/citycard01"):SetInt("$alpha", 0)

			hook.Add("PostDrawOpaqueRenderables", "dadam_flatgrass_cosmetics", function()
				-----Skybox time-----
				cam.Start3D2D(Vector(-5058.207031, 0.759911, -15310.609375), Angle(0, 95, 70), 5)
					draw.SimpleText(os.date("%H:%M:%S", os.time()), "DermaLarge", 10, 7)
				cam.End3D2D()
				
				-----Map lights-----
				local lightColor = Color(255,255,255,255)
				
				--Secret room
				local dlight = DynamicLight(10000)
				if dlight then
					dlight.pos = Vector(-716.143341, -250, -12660.031250)
					dlight.r = lightColor.r
					dlight.g = lightColor.g
					dlight.b = lightColor.b
					dlight.brightness = 1.5
					dlight.Decay = 0
					dlight.Size = 1024*1.5
					dlight.DieTime = CurTime() + 0.6
				end
				
				local dlight = DynamicLight(10001)
				if dlight then
					dlight.pos = Vector(-716.143341, 250, -12660.031250)
					dlight.r = lightColor.r
					dlight.g = lightColor.g
					dlight.b = lightColor.b
					dlight.brightness = 1.5
					dlight.Decay = 0
					dlight.Size = 1024*1.5
					dlight.DieTime = CurTime() + 0.6
				end
				
				--Spawn
				local dlight = DynamicLight(10002)
				if dlight then
					dlight.pos = Vector(0, 0, -12500)
					dlight.r = lightColor.r
					dlight.g = lightColor.g
					dlight.b = lightColor.b
					dlight.brightness = 2.5
					dlight.Decay = 0
					dlight.Size = 1024*3.5
					dlight.DieTime = CurTime() + 0.6
				end
				
				-----Random clocks-----
				--Train station clock
				--[[local time = os.date("*t", os.time())
				
				local x, y = math.sin(math.rad(-time.sec/60*360)) * 10, math.cos(math.rad(-time.sec/60*360)) * 10
				render.DrawLine(Vector(186.4, -218.771545, -12619.8), Vector(186.4, -218.771545 + x, -12619.8 + y), Color(255, 0, 0), true)
				
				local x, y = math.sin(math.rad(-time.min/60*360)) * 6, math.cos(math.rad(-time.min/60*360)) * 8
				render.DrawLine(Vector(186.4, -218.771545, -12619.8), Vector(186.4, -218.771545 + x, -12619.8 + y), Color(0, 0, 0), true)
				
				local x, y = math.sin(math.rad(-time.hour/12*360)) * 4, math.cos(math.rad(-time.hour/12*360)) * 5
				render.DrawLine(Vector(186.4, -218.771545, -12619.8), Vector(186.4, -218.771545 + x, -12619.8 + y), Color(0, 0, 0), true)]]
			end)
		end
	end)
end)
