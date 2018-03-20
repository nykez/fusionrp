Fusion.property = Fusion.property or {}
Fusion.property.cache = Fusion.property.cache or {}
Fusion.property.owners = Fusion.property.owners or {}

function Fusion.property:Sync(len)
    local prop = net.ReadTable()
    local owners = net.ReadTable()

    Fusion.property.cache = prop
    Fusion.property.owners = owners
    PrintTable(prop)
end
net.Receive("Fusion.property.sync", Fusion.property.Sync)

hook.Add("OnReloaded", "Fusion.PropertyPanelRefresh", function()
    if Fusion.property.panel then
        Fusion.property.panel:Remove()
        Fusion.property.panel = nil
    end
end)
