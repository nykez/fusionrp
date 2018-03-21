// Nykez
// Alpha Inventory 1.0
// TODO: Rewrite with classes/meta
//
if not SERVER then return end


Fusion.inventory = Fusion.inventory or {}
Fusion.inventory.cache = Fusion.inventory.cache or {}

util.AddNetworkString("Fusion.inventory.sync")
util.AddNetworkString("Fusion.inventory.syncid")
util.AddNetworkString("Fusion.inventory.spawn")
util.AddNetworkString("Fusion.inventory.edit")
util.AddNetworkString("Fusion.inventory.equip")
util.AddNetworkString("Fusion.inventory.unequip")
util.AddNetworkString("Fusion.inventory.cosmetic")
util.AddNetworkString("Fuson.inventory.inventory_slots")

local MAX_WEAPONS = 2
local MAX_MISC = 4

net.Receive('Fusion.inventory.unequip', function(len, pPlayer)
	local type = net.ReadString()
	local slot = net.ReadInt(16)

	local item = Fusion.inventory:GetSlot(pPlayer, type, slot)

	item = Fusion.inventory:GetItem(item)

	if not item then return end

	if item.weapon then
		if pPlayer:HasWeapon(item.weapon) then
			pPlayer:StripWeapon(item.weapon)
		end
	end

	pPlayer.inventory[type][slot] = nil

	net.Start('Fusion.inventory.unequip')
		net.WriteString(type)
		net.WriteInt(slot, 16)
	net.Send(pPlayer)

	Fusion.inventory:Add(pPlayer, item.id, 1)
end)


net.Receive('Fusion.inventory.equip',function (len, pPlayer)
	local item = net.ReadInt(16)

	if not item then return end
	
	local data = Fusion.inventory:GetItem(item)
	if not data then return end

	if not pPlayer.inventory[data.equipslot] then
		pPlayer.inventory[data.equipslot] = {}
	end

	if table.HasValue(pPlayer.inventory[data.equipslot], item) then
		pPlayer:Notify("That is already equipped.")
		return
	end

	local count = #pPlayer.inventory[data.equipslot]


	if count >= Fusion.inventory:GetMaxSlots(data.equipslot) then
		pPlayer:Notify(Fusion.inventory.maxerrors[data.equipslot])
		return
	end

	pPlayer.inventory[data.equipslot][count + 1] = item

	if data.weapon then
		pPlayer:Give(data.weapon)
	end

	net.Start("Fusion.inventory.equip")
		net.WriteString(data.equipslot)
		net.WriteInt(count + 1, 16)
		net.WriteInt(data.id, 16)
	net.Send(pPlayer)

	Fusion.inventory:Remove(pPlayer, data.id)
end)

function Fusion.inventory:GetSlot(pPlayer, type, slot)
	return pPlayer.inventory[type][slot] or false
end


function Fusion.inventory:AddQuantity(pPlayer, id, amount)
	if not amount then
		amount = 1
	end

	if not amount then amount = 1 end

	if pPlayer.inventory[id] then
		if pPlayer.inventory[id].quantity then
			pPlayer.inventory[id].quantity = pPlayer.inventory[id].quantity + amount
		else
			pPlayer.inventory[id].quantity = 1 + amount
		end
	else
		pPlayer.inventory[id] = {
			quantity = amount,
		}
	end

	self:FullSync(pPlayer)
end

function Fusion.inventory:Add(pPlayer, id, amount)
	if not IsValid(pPlayer) then return end

	local item = Fusion.inventory.cache[id]
	if not item then return end

	if not amount then
		amount = 1
	end

	self:AddQuantity(pPlayer, id, amount)
	self:FullSync(pPlayer)
end

function Fusion.inventory:Remove(pPlayer, id)
	if not IsValid(pPlayer) then return end

	local item = Fusion.inventory.cache[id]
	if not item then return end

	if pPlayer.inventory[id].quantity and pPlayer.inventory[id].quantity > 1 then
		pPlayer.inventory[id].quantity = pPlayer.inventory[id].quantity - 1
	else
		pPlayer.inventory[id] = nil
	end

	// Will fix this
	// Atm we will just send the whole player inventory until further development
	self:FullSync(pPlayer)
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

hook.Add("Fusion.PlayerLoaded", function(ply)
	Fusion.inventory.LoadPlayer(ply)
end)

function Fusion.inventory:Save(pPlayer)
	if not IsValid(pPlayer) then return end

	local tbl = Fusion.util:JSON(pPlayer.inventory or {})


	local updateObj = mysql:Update("player_data");
	updateObj:Update("inventory", tbl);
	updateObj:Where("steam_id", pPlayer:SteamID());
	updateObj:Execute();
	MsgN('saved')
end

function Fusion.inventory.LoadPlayer(pPlayer)
	local queryObj = mysql:Select("player_data");
	queryObj:Where("steam_id", pPlayer:SteamID())
	queryObj:Callback(function(result, status, lastID)
		if (type(result) == "table" and #result > 0) then
			local inventory = result[1].inventory
			local compiled = util.JSONToTable(inventory or {})
			pPlayer.inventory = compiled
			net.Start("Fusion.inventory.sync")
				net.WriteTable(pPlayer.inventory or {})
			net.Send(pPlayer)
		end
	end)
	queryObj:Execute();
end


net.Receive("Fusion.inventory.spawn", function(len, pPlayer)
	local id = net.ReadInt(16)

	if not id then return end

	Fusion.inventory:Spawn(pPlayer, id)
end)

function Fusion.inventory:Spawn(pPlayer, itemID)
	if not pPlayer then return end
	if not itemID then return end

	MsgN("Inventory ID: " .. itemID)

	if not pPlayer.inventory[itemID] then return end

	local item = Fusion.inventory:GetItem(itemID)



	local ent = ents.Create("ent_item")
	ent:SetModel(item.model)
	ent:Spawn()
	ent.canedit = true
	ent.id = item.id

	local tr = util.TraceEntity({
		start = pPlayer:EyePos(),
		endpos = pPlayer:EyePos() + pPlayer:GetAimVector() * 150,
		filter = pPlayer
	}, ent)

	local spawnPos = tr.HitPos

	ent:SetPos(spawnPos)

	self:Remove(pPlayer, item.id)
end

local PLAYER = FindMetaTable("Player")
function PLAYER:GetInventory()
	return self.inventory or {}
end

concommand.Add("inventory", function(pPlayer)
	if not pPlayer.inventory then pPlayer.inventory = {} end

	-- Fusion.inventory:Add(pPlayer, 1, 5)
	-- Fusion.inventory:Add(pPlayer, 2, 5)
	-- pPlayer.inventory = {}
	Fusion.inventory:Add(pPlayer, 3, 5)
	Fusion.inventory:Add(pPlayer, 4, 5)
	Fusion.inventory:Add(pPlayer, 5, 5)
	Fusion.inventory:Add(pPlayer, 7, 5)
	pPlayer:StripWeapons()

	print('loading inventory')
	-- Fusion.inventory.LoadPlayer(pPlayer)

	//print(Fusion.inventory:GetSlot(pPlayer, "equip", 1))
end)
