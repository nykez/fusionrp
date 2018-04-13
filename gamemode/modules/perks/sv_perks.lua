
Fusion.perks = Fusion.perks or {}
Fusion.perks.database = Fusion.perks.database or {}


function Fusion.perks:GetPerk(type, id)
	return Fusion.perks.database[type][id] or false
end

function Fusion.perks:GetPlayerPerk(pPlayer, type, id)
	if pPlayer.perks[type][id] then
		return self:GetPerk(type, id)
	end

	return false
end

