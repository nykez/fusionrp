Fusion.organizations = Fusion.organizations or {}
Fusion.organizations.cache = Fusion.organizations.cache or {}

function PLAYER:SetOrganization(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNetworkedInt("organization", int)
end

function Fusion.organizations:Create(ply, name, desc)
    if self.cache[id] then return end
    if ply:InOrg() then return end
    if !ply:Alive() then return end

    local id = nil
    local bFound = true

    while (bFound) do
        id = math.Round(math.random(0, 10000))
        local query = mysql:Select("player_orgs")
        query:Where("org_id", id)
        query:Callback(function(result, status, lastID)
            if !IsValid(result) then
                bFound = false
                break
            else
                continue
            end
        end)
        query:Execute()
    end

    if IsValid(id) then
        local query = mysql:Insert("player_orgs")
        query:Insert("org_id", id)
        query:Insert("owner_id", ply:SteamID())
        query:Insert("name", tostring(name))
        query:Insert("description", tostring(desc))
        query:Insert("ranks", "[]")
        query:Execute()
    end

    ply:Notify("We got you a new org!")
end
concommand.Add("org", function(ply)
    Fusion.organizations:Create(ply, "Test", "An MOTD.")
end)

function Fusion.organizations:Leave(ply)

end

function Fusion.organizations:Join(ply)

end

function Fusion.organizations:Cache(id)
    if self.cache[id] then return end

    local query = mysql:Select("player_orgs")
    query:Where("org_id", id)
    query:Callback(function(result, status, lastID)
        if (type(result) == "table" and #result > 0) then
            if result[1] != nil then
                local vars = result[1]
                Fusion.organizations.cache[tonumber(vars.org_id)] = vars
            end
        end
    end)
    query:Execute()
end

function Fusion.organizations:Decache(id)
    if self.cache[id] then
        self.cache[id] = nil
    end
end

hook.Add("Fusion.PlayerLoaded", "Fusion.OrgCache", function(ply)
    if IsValid(ply) then
        if !Fusion.organizations.cache[ply:GetOrganization()] then
            Fusion.organizations:Cache(ply:GetOrganization())
        end
    end
end)

hook.Add("PlayerDisconnected", "Fusion.OrgCacheDelete", function(ply)
    local bFound = false
    for k, v in pairs(Fusion.organizations.cache) do
        for _, player in pairs(player.GetAll()) do
            if player:GetOrganization() == tonumber(v.org_id) and player != ply then
                bFound = true
                break
            end
        end
    end

    if !bFound then
        Fusion.organizations:Decache(ply:GetOrganization())
    end
end)
