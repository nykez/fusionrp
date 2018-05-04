-- function GM:Initialize()
--     print("[Fusion RP] Initialized! Running version " .. GAMEMODE.Version)
-- end


-- function GM:PlayerSpawn(ply)
--     ply:SetupHands()

--     ply:Give("weapon_physgun")
--     ply:Give("weapon_doorfinder")
-- end

function GM:PlayerNoClip(ply)
    return true
end


-- function GM:Shutdown()
--     for _, v in pairs(player.GetAll()) do
--         v:SaveProfile()
--     end
-- end
