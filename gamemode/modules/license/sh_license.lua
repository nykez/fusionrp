Fusion.license = Fusion.license or {}
Fusion.license.cache = Fusion.license.cache or {}


function Fusion.license.Register(tblData)
	Fusion.license.cache[tblData.unique] = tblData
	if CLIENT and tblData.mat then
		tblData.mat = Material(tblData.mat, "noclamp smooth")
	end
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
	//mat = "gui/tow-truck.png",4
	canPurchase = function(pPlayer)
		return true
	end
})

Fusion.license.Register({
	name = "Medical Marijuana",
	unique = "license_weed",
	desc = "Allows you to purchase a license to grow medical Marijuana legally.",
	price = 0,
	renew = 250,
	canPurchase = function(pPlayer)
		local can = pPlayer:getLevel() >= 50

		if !can then
			pPlayer:Notify("You need player level 50 for this license.")
			return false
		end

		return true
	end
})