
Fusion.cosmetic = Fusion.cosmetic or {}
Fusion.cosmetic.slots = {
	["Head"] = { Type = "Head"},
	["Face"] = { Type = "Face",
	["Eyes"] = { Type = "Eyes"},
	["Neck"] = { Type = "Neck"},
	["Back"] = { Type = "Back"},
}

function Fusion.cosmetic.IsValid(slot)
	return Fusion.cosmetic[slot] and true or false
end

function Fusion.cosmetic.HasSlot(pPlayer, slot)
	local data = pPlayer:getChar():getWearables()

	return data[slot] and true or false
end


if CLIENT then
	function Fusion.cosmetic.EquipSlot(slot, itemid)
		if !Fusion.cosmetic.IsValid(slot) then return end

		local wearables = LocalPlayer():getChar():getWearables()

		// Just assign the item to the slot.
		// Let the item-table do the work on vectors/data
		wearables[slot] = itemid
	end

	function Fusion.cosmetic.RemoveSlot(slot)

		local char = LocalPlayer():getChar()
		local wearables = char:getWearables()


		// Nil the table index. Draw function will remove clientside model
		// Maybe better to find the cl model and remove it here?
		if wearables[slot] then
			wearables[slot] = nil
		end

	end

	function Fusion.cosmetic.Draw(ply)

	end
	

	
end
