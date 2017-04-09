CreateClientConVar("ddd_skin", "default", true, false, "This sets the derma skin on DaDamDev (Rejoin needed to see effects)")

local skins = {
	["black"] = "CISKIN",
	["dark"] = "CISKIN"
}

hook.Add("ForceDermaSkin", "dadam_skin", function()
    if skins[GetConVar("ddd_skin"):GetString()] then return skins[GetConVar("ddd_skin"):GetString()] end
end)