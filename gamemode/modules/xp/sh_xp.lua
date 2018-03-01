function PLAYER:GetXP()
    if !IsValid(self) then return end

    return self:GetNW2Int("xp", 0)
end

function PLAYER:GetLevel()
    if !IsValid(self) then return end

    return self:GetNW2Int("level", 1)
end
