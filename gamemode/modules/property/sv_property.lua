Fusion.property = Fusion.property or {}
Fusion.property.cache = Fusion.property.cache or {}
Fusion.property.owners = Fusion.property.owners or {}

util.AddNetworkString("Fusion.property.sync")
util.AddNetworkString("Fusion.property.purchase")
util.AddNetworkString("Fusion.property.sell")

function Fusion.property:SyncAll()
    if !Fusion.property.cache then return end
    if !Fusion.property.owners then return end

    net.Start("Fusion.property.sync")
        net.WriteTable(Fusion.property.cache)
        net.WriteTable(Fusion.property.owners)
    net.Broadcast()
end

function Fusion.property:Sync(ply)
    if !Fusion.property.cache then return end
    if !Fusion.property.owners then return end

    net.Start("Fusion.property.sync")
        net.WriteTable(Fusion.property.cache)
        net.WriteTable(Fusion.property.owners)
    net.Send(ply)
end

function Fusion.property:Purchase(ply, id)
    if !IsValid(ply) then return end

    local property = self:Get(id)
    if !property then return end

    if self:IsOwned(id) then
        ply:Notify("That property is already owned!")
    end

    if ply:GetBank() < property.price then
        ply:Notify("You can't afford that!")
        return
    end

    ply:TakeBank(property.price)

    self.owners[id] = ply

    ply:Notify("You purchased " .. property.name .. "!")

    self:SyncAll()
end

function Fusion.property:Sell(ply, id)
    if !IsValid(ply) then return end

    local property = self:Get(id)
    if !property then return end

    if !self:IsOwned(id) then return end
    if self:GetOwner(id) != ply then return end

    ply:AddBank(math.Round(property.price / 2))

    self.owners[id] = nil

    ply:Notify("You sold " .. property.name .. "!")

    self:SyncAll()
end

net.Receive("Fusion.property.purchase", function(len, ply)
    if !IsValid(ply) then return end

    local id = net.ReadInt(16)
    Fusion.property:Purchase(ply, id)
end)

net.Receive("Fusion.property.sell", function(len, ply)
    if !IsValid(ply) then return end

    local id = net.ReadInt(16)
    Fusion.property:Sell(ply, id)
end)

hook.Add("PlayerInitialSpawn", "Fusion.property.playerspawn", function(ply)
    Fusion.property:Sync(ply)
end)
