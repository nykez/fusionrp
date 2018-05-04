
local character = Fusion.meta.character

function character:hasMoney(amount)
	if (amount < 0) then return end
	
	return self:getMoney() >= amount
end
character.CanAfford = character.HasMoney

if SERVER then

	function character:giveMoney(amount)
		self:setMoney(self:getMoney() + amount)

		return true
	end
	characeter.AddMoney = character.giveMoney

	function character:takeMoney(amount)
		amount = math.abs(amount)
		self:giveMoney(-amount)
	end

	function Fusion.util.SpawnMoney(position, angle, amount)
		if (!pos) then return end
		if (!amount or amount < 0) then return end
		
		

	end

end