function PLAYER:SetAccountLevel(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNetworkedInt("account_level", int)
end

hook.Add("PlayerInitialSpawn", "Fusion.GetCountrySpawn", function(ply)
    if !IsValid(ply) then return end
    if ply:IsBot() then return end
    if !game.IsDedicated() then return end

    local ip = string.Explode(":", ply:IPAddress())
    http.Fetch("http://freegeoip.net/json/" .. tostring(ip[1]), function(body, len, headers, code)
        local tbl = util.JSONToTable(body)

        if tbl.country_name then
            local country = tbl.country_name
            ply:SetNetworkedString("country", country)
        end
    end,

    function(error)
        print("[Fusion RP] Couldn't fetch country for " .. ply:SteamID())
    end)
end)
