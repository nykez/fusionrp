Fusion.XP = Fusion.XP or {}
Fusion.XP.Max = 999999999

function PLAYER:SetXP(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNW2Int("xp", int)
end

function PLAYER:AddXP(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    local currentXP = self:GetNW2Int("xp", 0)

    self:SetXP(math.Clamp((currentXP + int), 0, Fusion.XP.Max))
end

function PLAYER:TakeXP(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    local currentXP = self:GetNW2Int("xp", 0)

    self:SetXP(math.Clamp((currentXP - int), 0, Fusion.XP.Max))
end
