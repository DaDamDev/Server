local function changeMat(org, rep, s)
    local m = Material(org)
    m:SetTexture("$basetexture", Material(rep):GetTexture("$basetexture"))
   
    local matrx = Matrix()
    local s = 2
    matrx:SetScale(Vector(s, s, s))
   
    m:SetMatrix("$basetexturetransform", matrx)
   
    -- reflection
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