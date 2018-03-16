Fusion.npcs = Fusion.npcs or {}
Fusion.npcs.cache = Fusion.npcs.cache or {}

net.Receive("Fusion.npc.use", function(len)
    local id = net.ReadInt(16)
    if !Fusion.npcs.cache[id] then return end

    Fusion.npcs.cache[id].use()
end)
