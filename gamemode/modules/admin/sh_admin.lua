FUSION_RANKS = {
    Color(60, 60, 60),
    Color(10, 10, 10),
    Color(1, 1, 1),
    Color(100, 255, 100),
    Color(255, 100, 100)
}

function PLAYER:GetAccountLevel()
    if !IsValid(self) then return end

    return self:GetNetworkedInt("account_level", 0)
end

function PLAYER:GetRankColor()
    if !IsValid(self) then return end

    return FUSION_RANKS[self:GetAccountLevel()]
end

function PLAYER:IsStaff()
    if !IsValid(self) then return end

    return self:GetAccountLevel() >= 4
end
