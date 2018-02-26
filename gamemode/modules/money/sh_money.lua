local PLAYER = FindMetaTable("Player")

function PLAYER:GetWallet()
	return self:self:GetNW2Int("money", 0)
end

function PLAYER:GetBank()
	return self:self:GetNW2Int("bank", 0)
end

function PLAYER:GetMoney(strType)
	if strType == "wallet" then
		return self:GetWallet()
	else
		return self:GetBank()
	end
end

function PLAYER:CanAfford(intPrice)
	return self:GetWallet() >= intPrice and true or false
end