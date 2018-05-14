
Fusion.license = Fusion.license or {}

netstream.Hook("license_purchase", function(pPlayer, stringUnique)
	Fusion.license.Purchase(stringUnique, pPlayer)
end)

function Fusion.license.Purchase(unique, pPlayer)
	if not IsValid(pPlayer) then return end

	local character = pPlayer:getChar()
	if not character then return end
	
	local license = Fusion.license.Get(unique)

	if not license then return end

	if !character:hasMoney(license.price) then
		pPlayer:Notify("You can't afford this license!")
		return
	end
	
	if !license.canPurchase(pPlayer) then
		pPlayer:Notify("You don't meet the requirements to purchase this license")
		return
	end


	local license_data = character:getData("license", {})

	if license_data[license.unique] then 
		pPlayer:Notify("You already have this license.")
		return 
	end 

	license_data[license.unique] = true
	character:setData("license", license_data)
	character:takeMoney(license.price)

	pPlayer:Notify("You successfully purchased your license.")
end

function Fusion.license.Revoke(unique, pPlayer, revoker)
	if not IsValid(pPlayer) then return end

	local character = pPlayer:getChar()
	if not character then return end

	local license = Fusion.license.Get(unique)

	if not license then return end

	local license_data = character:getData("license", {})

	if license_data[license.unique] then 
		license_data[license.unique] = nil
		character:setData("license", license_data)
		pPlayer:Notify("Your ".. license.name .. " license has been revoked.")
	else
		print("doesnt have license to revoke.")
	end

end

concommand.Add("purchaselicense", function(pPlayer)
	Fusion.license.Purchase("license_road", pPlayer)

	//print(Fusion.license.Has("license_road", pPlayer))

	//Fusion.license.Revoke("license_road", pPlayer, revoker)
end)