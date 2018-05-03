Fusion.license = Fusion.license or {}
Fusion.license.cache = Fusion.license.cache or {}


function Fusion.license.Register(tblData)
	Fusion.license.cache[tblData.unique] = tblData
end

function Fusion.license.Get(unique)
	return Fusion.license.cache[unique] or false
end

function Fusion.license.GetAll()
	return Fusion.license.cache
end

function Fusion.license.Has(unique, pPlayer)
	local character = pPlayer:getChar()
	if not character then return end

	if not Fusion.license.cache[unique] then return false end 
	
	local license = character:getData("license", {})

	return license[unique] and true or false
end

Fusion.license.Register({
	name = "Roadcrew",
	unique = "license_road",
	desc = "Allows you to purchase a tow truck, and become roadcrew. Also gives you access to roadcrew tools.",
	price = 0,
	renew = 250,
	canPurchase = function(pPlayer)
		return true
	end
})

Fusion.license.Register({
	name = "Private Security",
	unique = "license_security",
	desc = "Allows you to purchase supreme weapons to be used in security details. Police can revoke.",
	price = 15000,
	renew = 250,
	canPurchase = function(pPlayer)
		return true
	end
})