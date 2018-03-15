Fusion.property = Fusion.property or {}
Fusion.property.cache = Fusion.property.cache or {}
Fusion.property.owners = Fusion.property.owners or {}

function Fusion.property:Sync(len)
    local properties = net.ReadTable()
    local owners = net.ReadTable()

    Fusion.property.cache = properties
    Fusion.property.owners = owners
end
net.Receive("Fusion.property.sync", Fusion.property.Sync)
