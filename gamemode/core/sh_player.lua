function PLAYER:GetRPName()
    return self:GetNetworkedString("rp_first", "John") .. " " .. self:GetNetworkedString("rp_last", "Doe")
end
