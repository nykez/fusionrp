function GM:Initialize()
    print("[Fusion RP] Initialized! Running version " .. GAMEMODE.Version)
end

function GM:PlayerInitialSpawn(ply)
    ply:LoadProfile()
end
