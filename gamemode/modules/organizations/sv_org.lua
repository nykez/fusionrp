function PLAYER:SetOrganization(int)
    if !IsValid(self) then return end
    if type(int) != "number" then return end

    self:SetNetworkedInt("organization", int)
end
