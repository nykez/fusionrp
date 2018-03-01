Fusion.XP = Fusion.XP or {}
Fusion.XP.MaxLevel = 100

/*
    PLAYER:SetLevel(int)
    Only to be used internally..
    If you want to set someone's level, see PLAYER:CheatLevel(int)
*/

function PLAYER:SetLevel(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNW2Int("level", int)
end

function PLAYER:CheatLevel(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNW2Int("level", int)
    self:SetNW2Int("xp", Fusion.XP.XPForLevel(int))
end

function PLAYER:SetXP(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNW2Int("xp", int)
end

function PLAYER:AddXP(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    local currentXP = self:GetXP()
    self:SetXP(math.Clamp((currentXP + int), 0, 999999999))

    currentXP = self:GetXP()

    local bLoop = true
    while (bLoop) do
        if currentXP >= Fusion.XP:XPForLevel(self:GetLevel() + 1) then
            self:SetLevel(self:GetLevel() + 1)
            hook.Run("OnPlayerLeveledUp", self:GetXP(), self:GetLevel())
        else
            bLoop = false
        end
    end
end

function PLAYER:GiveXP(int) return self:AddXP(int) end

function PLAYER:GetXPNeeded()
    if !IsValid(self) then return end

    // If this is negative, then gg
    return Fusion.XP:XPForLevel(self:GetLevel() + 1) - self:GetXP()
end

function Fusion.XP:XPForLevel(intLvl)
    return math.Round((10 * intLvl * (math.log((intLvl), 2) + 3)) - 30)
end
