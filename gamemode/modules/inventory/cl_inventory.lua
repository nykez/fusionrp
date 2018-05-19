Fusion.inventory = Fusion.inventory or {}
Fusion.inventory.cache = Fusion.inventory.cache or {}


net.Receive("Fusion.inventory.sync", function()
	local tbl = net.ReadTable()

	if not tbl then return end

	Fusion.inventory:FullSync(LocalPlayer(), tbl)
end)

net.Receive("Fusion.inventory.syncid", function()
	local id = net.ReadString()
	local bool = net.ReadBool()

	if not tbl then return end

	if bool then
		Fusion.inventory:Sync(LocalPlayer(), tbl, true)
	else
		Fusion.inventory:Sync(LocalPlayer(), tbl)
	end

end)

net.Receive("Fusion.inventory.equip", function()
	local type = net.ReadString()
	local slot = net.ReadInt(16)
	local item = net.ReadInt(16)
	if not LocalPlayer().inventory[type] then
		LocalPlayer().inventory[type] = {}
	end
	LocalPlayer().inventory[type][slot] = item
end) 

net.Receive("Fusion.inventory.cosmetic", function()
	local slot = net.ReadInt(16)
	local item = net.ReadInt(16)

	LocalPlayer().inventory.cosmetic[slot] = item
end)

net.Receive("Fuson.inventory.inventory_slots", function()
	local x = net.ReadInt(16)
	local y = net.ReadInt(16)
	local item = net.ReadInt(16)

	LocalPlayer().inventory.items[x][y] = item
end)

net.Receive('Fusion.inventory.unequip', function()
	local type = net.ReadString()
	local slot = net.ReadInt(16)

	print(type)
	print(slot)

	LocalPlayer().inventory[type][slot] = nil

	if type == "cosmetic" then
		LocalPlayer().draw = nil
	end
end)

function Fusion.inventory:FullSync(pPlayer, tbl)
	if not IsValid(pPlayer) then return end

	pPlayer.inventory = tbl

end

function Fusion.inventory:GetInventory(pPlayer)
	return pPlayer.inventory or {}
end

function Fusion.inventory:Sync(pPlayer, id, bool)
	if not IsValid(pPlayer) then return end

	if bool then
		if pPlayer.inventory[id].quantity then
			pPlayer.inventory[id].quantity = pPlayer.inventory[id].quantity - 1
		else
			pPlayer.inventory[id] = nil
		end
	else
		if pPlayer.inventory[id].quantity then
			pPlayer.inventory[id].quantity = pPlayer.inventory[id].quantity + 1
		else
			pPlayer.inventory[id].quantity = 1
		end
	end
end
