Fusion.inventory = Fusion.inventory or {}

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
		Fusion.inventory:Sync(LocalPlayer(), tbl)
	else
		Fusion.inventory:Sync(LocalPlayer(), tbl, true)
	end
	
end)

function Fusion.inventory:FullSync(pPlayer, tbl)
	if not IsValid(pPlayer) then return end
	
	pPlayer.inventory = tbl

	PrintTable(pPlayer.inventory)
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

	PrintTable(pPlayer.inventory)
end