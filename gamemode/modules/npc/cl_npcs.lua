Fusion.npcs = Fusion.npcs or {}
Fusion.npcs.cache = Fusion.npcs.cache or {}

net.Receive("Fusion.npc.use", function(len, ply)
    if !IsValid(ply) then return end

    local id = net.ReadInt(16)
    if !Fusion.npcs.cache[id] then return end
    
    Fusion.npcs.cache[id].use()
end)
