function Fusion.property:Sync(len)
    local properties = net.ReadTable()
    local owners = net.ReadTable()

    Fusion.property.cache = properties
    Fusion.property.owners = owners
end
net.Receive("Fusion.property.sync", Fusion.property.Sync)
