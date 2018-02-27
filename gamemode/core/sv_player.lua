function PLAYER:LoadProfile()
    if !IsValid(self) then return end
    if !mysql:IsConnected() then return end

    local query = mysql:Select("player_data")
    query:Where("steam_id", self:SteamID())
    query:Callback(function(result, status, lastID)
        if (type(result) == "table" and #result > 0) then
            if result[1] != nil then
                local vars = result[1]
                self:SetFirstName(vars.rp_first)
                self:SetLastName(vars.rp_last)
                self:SetXP(vars.xp)
                self:SetAccountLevel(vars.account_level)
                self:SetMoney(vars.money)
                self:SetBank(vars.bank)
                self:SetOrganization(vars.organization)
                self:SetPlayTime(vars.playtime)
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
    query:Insert("inventory", "")
    query:Insert("skills", "")
    query:Insert("money", 15000)
    query:Insert("bank", 0)
    query:Insert("organization", 0)
    query:Insert("model", "models/player/breen.mdl")
    query:Insert("playtime", 0)
    query:Insert("nick", self:Nick())
    query:Execute()

    self:SetFirstName("John")
    self:SetLastName("Doe")
    self:SetXP(0)
    self:SetAccountLevel(0)
    self:SetMoney(15000)
    self:SetBank(0)
    self:SetOrganization(0)
    self:SetPlayTime(0)

    /*
    net.Start("fusion_new_player")
    net.Send(self)
    */
end

function PLAYER:SetFirstName(str)
    if !IsValid(self) then return end
    if type(str) != "string" then return end

    self:SetNetworkedString("rp_first", str)
end

function PLAYER:SetLastName(str)
    if !IsValid(self) then return end
    if type(str) != "string" then return end

    self:SetNetworkedString("rp_last", str)
end

function PLAYER:SetPlayTime(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNetworkedInt("playtime", int)
end
