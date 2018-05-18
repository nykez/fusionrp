
function GM:CanItemBeTransfered(itemObject, curInv, inventory)
	if (itemObject and itemObject.isBag) then
		if (inventory.id != 0 and curInv.id != inventory.id) then
			if (inventory.vars and inventory.vars.isBag) then
				return false 
			end
		end

		local inventory = Fusion.item.inventories[itemObject:getData("id")]

		if (inventory) then
			for k, v in pairs(inventory:getItems()) do
				if (v:getData("equip") == true) then
					local owner = itemObject:getOwner()
					
					if (owner and IsValid(owner)) then
						if (SERVER) then
							owner:Notify("Bag already equipped.")
						end
					end

					return false
				end
			end
		end
	end
end