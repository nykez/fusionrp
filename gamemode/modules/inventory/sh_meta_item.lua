
local ITEM = Fusion.meta.item or {}
ITEM.__index = ITEM
ITEM.name = "Undefined"
ITEM.desc = ITEM.desc or "An item that is undefined."
ITEM.id = ITEM.id or 0
ITEM.uniqueID = "undefined"

function ITEM:__eq(other)
	return self:getID() == other:getID()
end

function ITEM:__tostring()
	return "item["..self.uniqueID.."]["..self.id.."]"
end

function ITEM:getID()
	return self.id
end

function ITEM:getName()
	return (CLIENT and (self.name) or self.name)
end

function ITEM:getDesc()
	if (!self.desc) then return "ERROR" end
	
	return (self.desc or "noDesc")
end

-- Dev Buddy. You don't have to print the item data with PrintData();
function ITEM:print(detail)
	if (detail == true) then
		print(Format("%s[%s]: >> [%s](%s,%s)", self.uniqueID, self.id, self.owner, self.gridX, self.gridY))
	else
		print(Format("%s[%s]", self.uniqueID, self.id))
	end
end

-- Dev Buddy, You don't have to make another function to print the item Data.
function ITEM:printData()
	self:print(true)
	print("ITEM DATA:")
	for k, v in pairs(self.data) do
		print(Format("[%s] = %s", k, v))
	end
end

function ITEM:call(method, client, entity, ...)
	local oldPlayer, oldEntity = self.player, self.entity

	self.player = client or self.player
	self.entity = entity or self.entity

	if (type(self[method]) == "function") then
		local results = {self[method](self, ...)}

		self.player = nil
		self.entity = nil

		return unpack(results)
	end

	self.player = oldPlayer
	self.entity = oldEntity
end

function ITEM:getOwner()
	local inventory = Fusion.item.inventories[self.invID]

	if (inventory) then
		return (inventory.getReceiver and inventory:getReceiver())
	end

	local id = self:getID()

	for k, v in ipairs(player.GetAll()) do
		local character = v:getChar()

		if (character and character:getInv():getItemByID(id)) then
			return v
		end
	end
end

function ITEM:setData(key, value, receivers, noSave, noCheckEntity)
	self.data = self.data or {}
	self.data[key] = value

	if (SERVER) then
		if (!noCheckEntity) then
			local ent = self:getEntity()

			if (IsValid(ent)) then
				local data = ent:getNetVar("data", {})
				data[key] = value

				ent:setNetVar("data", data)
			end
		end
	end

	if (receivers != false) then
		if (receivers or self:getOwner()) then
			netstream.Start(receivers or self:getOwner(), "invData", self:getID(), key, value)
		end
	end

	if (!noSave) then
		local update = mysql:Update("fusion_items")
		update:Update("_data", self.data)
		update:Where("_itemID", self:getID())
		update:Execute()
	end	
end

function ITEM:getData(key, default)
	self.data = self.data or {}

	if (self.data) then
		if (key == true) then
			return self.data
		end

		local value = self.data[key]

		if (value != nil) then
			return value
		elseif (IsValid(self.entity)) then
			local data = self.entity:getNetVar("data", {})
			local value = data[key]

			if (value != nil) then
				return value
			end
		end
	else
		self.data = {}
	end

	if (default != nil) then
		return default
	end

	return
end


function ITEM:hook(name, func)
	if (name) then
		self.hooks[name] = func
	end
end

function ITEM:postHook(name, func)
	if (name) then
		self.postHooks[name] = func
	end
end

function ITEM:remove()
	local inv = Fusion.item.inventories[self.invID]
	local x2, y2

	if (self.invID > 0 and inv) then
		local failed = false
		for x = self.gridX, self.gridX + (self.width - 1) do
			if (inv.slots[x]) then
				for y = self.gridY, self.gridY + (self.height - 1) do
					local item = inv.slots[x][y]

					if (item and item.id == self.id) then
						inv.slots[x][y] = nil
					else
						failed = true
					end
				end
			end
		end

		if (failed) then
			local items = inv:getItems()

			inv.slots = {}
			for k, v in pairs(items) do
				if (v.invID == inv:getID()) then
					for x = self.gridX, self.gridX + (self.width - 1) do
						for y = self.gridY, self.gridY + (self.height - 1) do
							inv.slots[x][y] = v.id
						end
					end
				end
			end

			if (IsValid(inv.owner) and inv.owner:IsPlayer()) then
				inv:sync(inv.owner, true)
			end

			return false
		end
	else
		local inv = Fusion.item.inventories[self.invID]

		if (inv) then
			Fusion.item.inventories[self.invID][self.id] = nil
		end
	end

	if (SERVER and !noReplication) then
		local entity = self:getEntity()

		if (IsValid(entity)) then
			entity:Remove()
		end
		
		local receiver = inv.getReceiver and inv:getReceiver()

		if (self.invID != 0) then
			if (IsValid(receiver) and receiver:getChar() and inv.owner == receiver:getChar():getID()) then
				netstream.Start(receiver, "invRm", self.id, inv:getID())
			else
				netstream.Start(receiver, "invRm", self.id, inv:getID(), inv.owner)
			end
		end

		if (!noDelete) then
			local item = Fusion.item.instances[self.id]

			if (item and item.onRemoved) then
				item:onRemoved()
			end
			
			mysql:RawQuery("DELETE FROM fusion_items WHERE _itemID = "..self.id)
			Fusion.item.instances[self.id] = nil
		end
	end

	return true
end

if (SERVER) then
	function ITEM:getEntity()
		local id = self:getID()

		for k, v in ipairs(ents.FindByClass("ent_item")) do
			if (v.fusionItemID == id) then
				return v
			end
		end
	end
	-- Spawn an item entity based off the item table.
	function ITEM:spawn(position, angles)
		-- Check if the item has been created before.
		if (Fusion.item.instances[self.id]) then
			local client

			-- If the first argument is a player, then we will find a position to drop
			-- the item based off their aim.
			if (type(position) == "Player") then
				client = position
				position = position:getItemDropPos()
			end

			-- Spawn the actual item entity.
			local entity = ents.Create("ent_item")
			entity:Spawn()
			entity:SetPos(position)
			entity:SetAngles(angles or Angle(0, 0, 0))
			-- Make the item represent this item.
			entity:setItem(self.id)

			if (IsValid(client)) then
				entity.fusionSteamID = client:SteamID()
				entity.fusionCharID = client:getChar():getID()
			end

			-- Return the newly created entity.
			return entity
		end
	end

	-- Transfers an item to a specific inventory.
	function ITEM:transfer(invID, x, y, client, noReplication, isLogical)		
		invID = invID or 0
		
		if (self.invID == invID) then
			return false, "same inv"
		end
		
		local inventory = Fusion.item.inventories[invID]
		local curInv = Fusion.item.inventories[self.invID or 0]

		if (hook.Run("CanItemBeTransfered", self, curInv, inventory) == false) then
			return false, "notAllowed"
		end

		local authorized = false

		if (curInv and !IsValid(client)) then
			client = (curInv.getReceiver and curInv:getReceiver() or nil)
		end

		if (inventory and inventory.onAuthorizeTransfer and inventory:onAuthorizeTransfer(client, curInv, self)) then
			authorized = true
		end

		if (!authorized and self.onCanBeTransfered and self:onCanBeTransfered(curInv, inventory) == false) then
			return false, "notAllowed"
		end

		if (curInv) then
			if (invID and invID > 0 and inventory) then
				local targetInv = inventory
				local bagInv

				if (!x and !y) then
					x, y, bagInv = inventory:findEmptySlot(self.width, self.height)
				end

				if (bagInv) then
					targetInv = bagInv
				end

				if (!x or !y) then
					return false, "noSpace"
				end

				local prevID = self.invID
				local status, result = targetInv:add(self.id, nil, nil, x, y, noReplication)

				if (status) then
					if (self.invID > 0 and prevID != 0) then
						curInv:remove(self.id, false, true)
						self.invID = invID

						if (self.onTransfered) then
							self:onTransfered(curInv, inventory)
						end
						hook.Run("OnItemTransfered", self, curInv, inventory)

						return true
					elseif (self.invID > 0 and prevID == 0) then
						local inventory = Fusion.item.inventories[0]
						inventory[self.id] = nil

						if (self.onTransfered) then
							self:onTransfered(curInv, inventory)
						end
						hook.Run("OnItemTransfered", self, curInv, inventory)

						return true
					end
				else
					return false, result
				end
			elseif (IsValid(client)) then
				self.invID = 0

				curInv:remove(self.id, false, true)
				mysql:RawQuery("UPDATE fusion_items SET _invID = 0 WHERE _itemID = "..self.id)

				if (isLogical != true) then
					return self:spawn(client)	
				else
					local inventory = Fusion.item.inventories[0]
					inventory[self:getID()] = self

					if (self.onTransfered) then
						self:onTransfered(curInv, inventory)
					end
					hook.Run("OnItemTransfered", self, curInv, inventory)
						
					return true
				end
			else
				return false, "noOwner"
			end
		else
			return false, "invalidInventory"
		end
	end
end

Fusion.meta.item = ITEM


if SERVER then
	concommand.Add("nigger2", function(pPlayer)

		local char = pPlayer:getChar()
		Fusion.item.spawn("357", pPlayer:GetPos(), nil, Angle(0, 90, 0), {})
	end)
end