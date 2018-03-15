function GM:Initialize()
    print("[Fusion RP] Initialized! Running version " .. GAMEMODE.Version)
end

function GM:PlayerInitialSpawn(ply)
    ply:LoadProfile()
    ply:SetupHands()

    ply:Give('weapon_physgun')
    ply:Give("weapon_doorfinder")
end

function GM:PlayerDisconnected(ply)
    ply:SaveProfile()
    // Remove all of their props and stuff later
end

function GM:Shutdown()
    for _, v in pairs(player.GetAll()) do
        v:SaveProfile()
    end
end
