function PLAYER:GetRPName()
    if !IsValid(self) then return end

    return self:GetNetworkedString("rp_first", "John") .. " " .. self:GetNetworkedString("rp_last", "Doe")
end

function PLAYER:GetFirstName()
    if !IsValid(self) then return end

    return self:GetNetworkedString("rp_first", "John")
end

function PLAYER:GetLastName()
    if !IsValid(self) then return end

    return self:GetNetworkedString("rp_last", "Doe")
end

function PLAYER:GetPlayTime()
    if !IsValid(self) then return end

    return 0
end
