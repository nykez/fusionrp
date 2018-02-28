// Nykez
// Alpha Inventory 1.0
// TODO: Rewrite with classes/meta

Fusion.inventory = Fusion.inventory or {}

util.AddNetworkString("Fusion.inventory.sync")
util.AddNetworkString("Fusion.inventory.syncid")
function Fusion.inventory:AddQuantity(pPlayer, id, amount)
	if not amount then amount = 1

	if pPlayer.inventory[id].quanity then
		pPlayer.inventory[id].quanity + amount
	else
		pPlayer.inventory[id].quanity = 1
	end
end


function Fusion.inventory:Add(pPlayer, id)
	if not IsValid(pPlayer) then return end
	
	local item = Fusion.Inventory.cache[id]
	if not item then return end
	
	self:AddQuantity(pPlayer, id)
	self:Sync(pPlayer, id)
end

function Fusion.inventory:Remove(pPlayer, id)
	if not IsValid(pPlayer) then return end

	local item = Fusion.Inventory.cache[id]
	if not item then return end

	if pPlayer.inventory[id].quanity and pPlayer.inventory[id].quanity > 1 then
		pPlayer.inventory[id].quanity = pPlayer.inventory[id].quanity - 1
	else
		pPlayer.inventory[id] = nil
	end

	// Will fix this
	// Atm we will just send the whole player inventory until further development
	self:FullSync(pPlayer, id, true)
end

function Fusion.inventory:Sync(pPlayer, id, boolRemove)
	if not id then return end

	net.Start("Fusion.inventory.syncid")
		net.WriteString(id)
		// Used to remove 1 id from the client
		if boolRemove then
			net.WriteBool(boolRemove)
		end
	net.Send(pPlayer)
end

function Fusion.inventory:FullSync(pPlayer)
	net.Start("Fusion.inventory.sync")
		net.WriteTable(pPlayer.inventory or {})
	net.Send(pPlayer)
end

function Fusion.inventory:Save(pPlayer)
	if not IsValid(pPlayer) then return end
	
	local tbl = Fusion.util:JSON(pPlayer.inventory)

	local updateObj = mysql:Update("player_data");
	updateObj:Update("inventory", tbl);
	updateObj:Where("steam_id", pPlayer:SteamID());
	updateObj:Execute();
	MsgN('saved')
end