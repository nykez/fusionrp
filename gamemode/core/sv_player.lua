function PLAYER:LoadProfile()
    if !IsValid(self) then return end
    if !mysql:IsConnected() then return end

    local query = mysql:Select("*")
    query:ForTable("player_data")
    query:Where("steam_id", self:SteamID())
    query:Callback(function(result, status, lastID)
        if (type(result) == "table" and #result > 0) then
            for k, v in pairs(result) do
                PrintTable(v)
            end
        else
            self.IsNew = true
            self:CreateProfile()
        end
    end)

    query:Execute()
end

function PLAYER:CreateProfile()
    if !IsValid(self) then return end
    if !self.IsNew then return end

    local query = mysql:Insert("player_data")
    query:Insert("steam_id", self:SteamID())
    query:Insert("rp_first", "John")
    query:Insert("rp_last", "Doe")
    query:Insert("xp", 0)
    query:Insert("account_level", 0)
    query:Insert("money", 15000)
    query:Insert("bank", 0)
    query:Insert("organization", 0)
    query:Insert("model", "models/player/breen.mdl")
    query:Insert("playtime", 0)
    query:Insert("nick", self:Nick())
    query:Execute()

    /*
    net.Start("fusion_new_player")
    net.Send(self)
    */
end
