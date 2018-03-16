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
	Fusion.inventory:FullSync(ply)
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
	MsgN(pPlayer:SteamID())

	local queryObj = mysql:Select("player_data");
		queryObj:WhereEqual("steam_id", pPlayer:SteamID())
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

	Fusion.inventory:Add(pPlayer, 1, 5)
	Fusion.inventory:Add(pPlayer, 2, 5)

	print('loading inventory')
	Fusion.inventory.LoadPlayer(pPlayer)
end)
