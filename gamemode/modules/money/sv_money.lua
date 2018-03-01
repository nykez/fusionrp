Fusion.Money = Fusion.Money or {}
Fusion.Money.Currency = "$"

//

local PLAYER = FindMetaTable("Player")

function PLAYER:SetMoney(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNW2Int("money", int)
end

function PLAYER:AddMoney(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    local currentMoney = self:GetNW2Int("money", 15000)

    self:SetMoney(currentMoney + int)
end

function PLAYER:TakeMoney(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    local currentMoney = self:GetNW2Int("money", 15000)

    self:SetMoney(currentMoney - int)
end

function PLAYER:SetBank(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNW2Int("bank", int)
end

function PLAYER:AddBank(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    local currentBank = self:GetNW2Int("bank", 0)

    self:SetBank(currentBank + int)
end

function PLAYER:TakeBank(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    local currentBank = self:GetNW2Int("bank", 0)

    self:SetBank(currentBank - int)
end