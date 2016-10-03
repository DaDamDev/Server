local map = game.GetMap()

hook.Add("FinishMove", "dadam_antiskybox", function(ply, mvd)
    local pos = mvd:GetOrigin()
    if pos.z < -12826 && map == "gm_flatgrass" then
        ply:SetPos(Vector(pos.x, pos.y, -12826))
        return true
    end
end)