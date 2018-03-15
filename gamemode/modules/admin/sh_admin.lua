function PLAYER:GetAccountLevel()
    if !IsValid(self) then return end

    return self:GetNetworkedInt("account_level", 0)
end
