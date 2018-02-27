function PLAYER:SetAccountLevel(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNetworkedInt("account_level", int)
end
