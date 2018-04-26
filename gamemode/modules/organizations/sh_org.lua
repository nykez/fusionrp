Fusion.organizations = Fusion.organizations or {}
Fusion.organizations.cache = Fusion.organizations.cache or {}

function PLAYER:GetOrganization()
    return self:GetNetworkedInt("organization", 0)
end

function PLAYER:InOrg()
    if self:GetOrganization() != 0 then return true end

    return false
end

function Fusion.organizations:GetOwner(id)
    if !self.cache[id] then return end
    if !self.cache[id].owner_id then return end

    return self.cache[id].owner_id
end
