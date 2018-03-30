function PLAYER:LoadProfile()
    if !IsValid(self) then return end
    if !mysql:IsConnected() then return end

    local query = mysql:Select("player_data")
    query:Where("steam_id", self:SteamID())
    query:Callback(function(result, status, lastID)
        if (type(result) == "table" and #result > 0) then
            if result[1] != nil then
                local vars = result[1]

                if tostring(vars.rp_first) == "John" and tostring(vars.rp_last) == "Doe" then
                    self.IsNew = true
                    net.Start("Fusion.new.character")
                    net.Send(self)
                    return
                end

                self:SetFirstName(tostring(vars.rp_first))
                self:SetLastName(tostring(vars.rp_last))
                self:SetXP(tonumber(vars.xp))
                self:SetLevel(tonumber(vars.level))
                self:SetAccountLevel(tonumber(vars.account_level))
                self:SetMoney(tonumber(vars.money))
                self:SetBank(tonumber(vars.bank))
                self:SetOrganization(tonumber(vars.organization))
                self:SetPlayTime(tonumber(vars.playtime))

                self:SetModel(vars.model)
                Fusion.character:BodyGroups(self, util.JSONToTable(vars.modeldata))

                self.inventory = Fusion.util:Table(tostring(vars.inventory))
                self.vehicles = Fusion.util:Table(tostring(vars.vehicles))

                hook.Run("Fusion.PlayerLoaded", self)
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
    query:Insert("level", 1)
    query:Insert("account_level", 0)
    query:Insert("money", 15000)
    query:Insert("bank", 0)
    query:Insert("organization", 0)
    query:Insert("model", "models/player/breen.mdl")
    query:Insert("modeldata", "[]")
    query:Insert("playtime", 0)
    query:Insert("nick", self:Nick())
    query:Insert("inventory", "[]")
    query:Insert("skills", "[]")
    query:Insert("vehicles", "[]")
    query:Execute()

    self:SetFirstName("John")
    self:SetLastName("Doe")
    self:SetXP(0)
    self:SetLevel(1)
    self:SetAccountLevel(0)
    self:SetMoney(15000)
    self:SetBank(0)
    self:SetOrganization(0)
    self:SetPlayTime(0)

    self.inventory = {}
    self.vehicles = {}

    net.Start("Fusion.new.character")
    net.Send(self)
end

function PLAYER:SaveProfile()
    local query = mysql:Update("player_data")
    query:Where("steam_id", self:SteamID())
    query:Update("rp_first", self:GetFirstName())
    query:Update("rp_last", self:GetLastName())
    query:Update("xp", self:GetXP())
    query:Update("level", self:GetLevel())
    query:Update("account_level", self:GetAccountLevel())
    query:Update("skills", "[]")
    query:Update("money", self:GetWallet())
    query:Update("bank", self:GetBank())
    query:Update("organization", 0)
    query:Update("model", self:GetModel())
    query:Update("modeldata", "[]")
    query:Update("playtime", self:GetPlayTime())
    query:Update("nick", self:Nick())
    query:Execute()

    Fusion.inventory:Save(self)
    //Fusion.vehicles:Save(self)
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
