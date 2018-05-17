
Fusion.item = Fusion.item or {}
Fusion.item.list = Fusion.item.list or {}
Fusion.item.base = Fusion.item.base or {}
Fusion.item.instances = Fusion.item.instances or {}
Fusion.item.inventories = Fusion.item.inventories or {
	[0] = {}
}
Fusion.item.inventoryTypes = Fusion.item.inventoryTypes or {}

Fusion.util.include("fusionrp/gamemode/modules/inventory/sh_meta_item.lua")

-- Declare some supports for logic inventory
local zeroInv = Fusion.item.inventories[0]
function zeroInv:getID()
	return 0
end

-- WARNING: You have to manually sync the data to client if you're trying to use item in the logical inventory in the vgui.
function zeroInv:add(uniqueID, quantity, data)
	quantity = quantity or 1

	if (quantity > 0) then
		if (!isnumber(uniqueID)) then
			if (quantity > 1) then
				for i = 1, quantity do
					self:add(uniqueID, 1, data)
				end

				return
			end

			local itemTable = Fusion.item.list[uniqueID]

			if (!itemTable) then
				return false, "invalidItem"
			end

			Fusion.item.instance(0, uniqueID, data, x, y, function(item)
				self[item:getID()] = item
			end)

			return nil, nil, 0
		end
	else
		return false, "notValid"
	end
end

//
function Fusion.item.instance(index, uniqueID, itemData, x, y, callback)
	if (!uniqueID or Fusion.item.list[uniqueID]) then
		local query = mysql:Insert("fusion_items")
		query:Insert("_invID", index)
		query:Insert("_uniqueID", uniqueID)
		query:Insert("_data", itemData)
		query:Insert("_x", x)
		query:Insert("_y", y)
		query:Callback(function(result, status, lastID)
			local item = Fusion.item.new(uniqueID, lastID)

			if (item) then
				item.data = itemData or {}
				item.invID = index

				if (callback) then
					callback(item)
				end

				if (item.OnInstanced) then
					item:OnInstanced(index, x, y, item)
				end
			end
		end)
	query:Execute()
	else
		ErrorNoHalt("[Fusion] Attempt to give an invalid item! ("..(uniqueID or "nil")..")\n")
	end

	//
end

function Fusion.item.registerInv(invType, w, h, isBag)
	Fusion.item.inventoryTypes[invType] = {w = w, h = h}

	if (isBag) then
		Fusion.item.inventoryTypes[invType].isBag = invType
	end

	return Fusion.item.inventoryTypes[invType]
end

function Fusion.item.newInv(owner, invType, callback)
	local invData = Fusion.item.inventoryTypes[invType] or {w = 1, h = 1}
	local query = mysql:Insert("fusion_inventories")
	query:Insert("_invType", invType)
	query:Insert("_charID", owner)
	query:Callback(function(result, status, lastID)
		local inventory = Fusion.item.createInv(invData.w, invData.h, lastID)

		if (invType) then
			inventory.vars.isBag = invType
		end

		if (owner and owner > 0) then
			for k, v in ipairs(player.GetAll()) do
				if (v:getChar() and v:getChar():getID() == owner) then
					inventory:setOwner(owner)
					inventory:sync(v)

					break
				end
			end
		end

		if (callback) then
			callback(inventory)
		end
	end)
	query:Execute()
end

function Fusion.item.get(identifier)
	return Fusion.item.base[identifier] or Fusion.item.list[identifier]
end

function Fusion.item.getInv(invID)
	return Fusion.item.inventories[invID]
end

function Fusion.item.load(path, baseID, isBaseItem)
	local uniqueID = path:match("sh_([_%w]+)%.lua")

	if (uniqueID) then
		uniqueID = (isBaseItem and "base_" or "")..uniqueID
		Fusion.item.register(uniqueID, baseID, isBaseItem, path)
	else
		if (!path:find(".txt")) then
			ErrorNoHalt("[Fusion] Item at '"..path.."' follows invalid naming convention!\n")
		end
	end
end

function Fusion.item.register(uniqueID, baseID, isBaseItem, path, luaGenerated)
	local meta = Fusion.meta.item

	if (uniqueID) then
		print(uniqueID)
		ITEM = (isBaseItem and Fusion.item.base or Fusion.item.list)[uniqueID] or setmetatable({}, meta)
			ITEM.desc = "noDesc"
			ITEM.uniqueID = uniqueID
			ITEM.base = baseID
			ITEM.isBase = isBaseItem
			ITEM.hooks = ITEM.hooks or {}
			ITEM.postHooks = ITEM.postHooks or {}
			ITEM.functions = ITEM.functions or {}
			ITEM.functions.drop = ITEM.functions.drop or {
				tip = "dropTip",
				icon = "icon16/world.png",
				onRun = function(item)
					item:transfer()

					return false
				end,
				onCanRun = function(item)
					return (!IsValid(item.entity) and !item.noDrop)
				end
			}
			ITEM.functions.take = ITEM.functions.take or {
				tip = "takeTip",
				icon = "icon16/box.png",
				onRun = function(item)
					local status, result = item.player:getChar():getInv():add(item.id)

					if (!status) then
						item.player:notify(result)

						return false
					else
						if (item.data) then -- I don't like it but, meh...
							for k, v in pairs(item.data) do
								item:setData(k, v)
							end
						end
					end
				end,
				onCanRun = function(item)
					return IsValid(item.entity)
				end
			}

			local oldBase = ITEM.base

			if (ITEM.base) then
				local baseTable = Fusion.item.base[ITEM.base]

				if (baseTable) then
					for k, v in pairs(baseTable) do
						if (ITEM[k] == nil) then
							ITEM[k] = v
						end

						ITEM.baseTable = baseTable
					end

					local mergeTable = table.Copy(baseTable)
					ITEM = table.Merge(mergeTable, ITEM)
				else
					ErrorNoHalt("[Fusion] Item '"..ITEM.uniqueID.."' has a non-existent base! ("..ITEM.base..")\n")
				end
			end

			if (PLUGIN) then
				ITEM.plugin = PLUGIN.uniqueID
			end

			if (!luaGenerated and path) then
				Fusion.util.include(path)
			end

			if (ITEM.base and oldBase != ITEM.base) then
				local baseTable = Fusion.item.base[ITEM.base]

				if (baseTable) then
					for k, v in pairs(baseTable) do
						if (ITEM[k] == nil) then
							ITEM[k] = v
						end

						ITEM.baseTable = baseTable
					end

					local mergeTable = table.Copy(baseTable)
					ITEM = table.Merge(mergeTable, ITEM)
				else
					ErrorNoHalt("[Fusion] Item '"..ITEM.uniqueID.."' has a non-existent base! ("..ITEM.base..")\n")
				end
			end

			ITEM.width = ITEM.width or 1
			ITEM.height = ITEM.height or 1
			ITEM.category = ITEM.category or "misc"

			if (ITEM.onRegistered) then
				ITEM:onRegistered()
			end

			(isBaseItem and Fusion.item.base or Fusion.item.list)[ITEM.uniqueID] = ITEM
		if (luaGenerated) then
			return ITEM
		else
			ITEM = nil
		end
	else
		ErrorNoHalt("[Fusion] You tried to register an item without uniqueID!\n")
	end
end


function Fusion.item.loadFromDir(directory)
	local files, folders

	files = file.Find(directory.."/base/*.lua", "LUA")

	for k, v in ipairs(files) do
		Fusion.item.load(directory.."/base/"..v, nil, true)
	end

	files, folders = file.Find(directory.."/*", "LUA")

	for k, v in ipairs(folders) do
		if (v == "base") then
			continue
		end

		for k2, v2 in ipairs(file.Find(directory.."/"..v.."/*.lua", "LUA")) do
			Fusion.item.load(directory.."/"..v .. "/".. v2, "base_"..v)
		end
	end

	for k, v in ipairs(files) do
		Fusion.item.load(directory.."/"..v)
	end
end

function Fusion.item.new(uniqueID, id)
	if (Fusion.item.instances[id] and Fusion.item.instances[id].uniqueID == uniqueID) then
		return Fusion.item.instances[id]
	end

	local stockItem = Fusion.item.list[uniqueID]

	if (stockItem) then
		local item = setmetatable({}, {__index = stockItem})
		item.id = id
		item.data = {}

		Fusion.item.instances[id] = item

		return item
	else
		ErrorNoHalt("[Fusion] Attempt to index unknown item '"..uniqueID.."'\n")
	end
end

do
	Fusion.util.include("fusionrp/gamemode/modules/inventory/sh_meta_inventory.lua")

	function Fusion.item.createInv(w, h, id)
		print("inventory id:", id)
		local inventory = setmetatable({w = w, h = h, id = id, slots = {}, vars = {}}, Fusion.meta.inventory)
			Fusion.item.inventories[id] = inventory

		return inventory
	end

	function Fusion.item.restoreInv(invID, w, h, callback)
		if (type(invID) != "number" or invID < 0) then
			error("Attempt to restore inventory with an invalid ID!")
		end

		local inventory = Fusion.item.createInv(w, h, invID)

		mysql:RawQuery("SELECT _itemID, _uniqueID, _data, _x, _y FROM fusion_items WHERE _invID = "..invID, function(data)
			local badItemsUniqueID = {}

			if (data) then
				local slots = {}
				local badItems = {}

				for _, item in ipairs(data) do
					local x, y = tonumber(item._x), tonumber(item._y)
					local itemID = tonumber(item._itemID)
					local data = util.JSONToTable(item._data or "[]")

					if (x and y and itemID) then
						if (x <= w and x > 0 and y <= h and y > 0) then
							local item2 = Fusion.item.new(item._uniqueID, itemID)

							if (item2) then
								item2.data = {}
								if (data) then
									item2.data = data
								end

								item2.gridX = x
								item2.gridY = y
								item2.invID = invID

								for x2 = 0, item2.width - 1 do
									for y2 = 0, item2.height - 1 do
										slots[x + x2] = slots[x + x2] or {}
										slots[x + x2][y + y2] = item2
									end
								end

								if (item2.onRestored) then
									item2:onRestored(item2, invID)
								end
							else
								badItemsUniqueID[#badItemsUniqueID + 1] = item._uniqueID
								badItems[#badItems + 1] = itemID
							end
						else
							badItemsUniqueID[#badItemsUniqueID + 1] = item._uniqueID
							badItems[#badItems + 1] = itemID
						end
					end
				end

				inventory.slots = slots

				if (table.Count(badItems) > 0) then
					mysql:RawQuery("DELETE FROM fusion_items WHERE _itemID IN ("..table.concat(badItems, ", ")..")")
				end
			end

			if (callback) then
				callback(inventory, badItemsUniqueID)
			end
		end)
	end

	if (CLIENT) then
		netstream.Hook("item", function(uniqueID, id, data, invID)
			local stockItem = Fusion.item.list[uniqueID]
			local item = Fusion.item.new(uniqueID, id)

			item.data = {}
			if (data) then
				item.data = data
			end

			item.invID = invID or 0
		end)

		netstream.Hook("inv", function(slots, id, w, h, owner, vars)
			local character

			print('doing networking')

			if (owner) then
				character = Fusion.character.loaded[owner]
			else
				character = LocalPlayer():getChar()
			end

			if (character) then
				print('got a character')
				local inventory = Fusion.item.createInv(w, h, id)
				inventory:setOwner(character:getID())
				inventory.slots = {}
				inventory.vars = vars

				local x, y

				for k, v in ipairs(slots) do
					x, y = v[1], v[2]

					inventory.slots[x] = inventory.slots[x] or {}

					local item = Fusion.item.new(v[3], v[4])

					item.data = {}
					if (v[5]) then
						item.data = v[5]
					end

					item.invID = item.invID or id
					inventory.slots[x][y] = item
				end

				character.vars.inv = character.vars.inv or {}

				for k, v in ipairs(character:getInv(true)) do
					if (v:getID() == id) then
						character:getInv(true)[k] = inventory

						return
					end
				end

				table.insert(character.vars.inv, inventory)
			end
		end)

		netstream.Hook("invData", function(id, key, value)
			local item = Fusion.item.instances[id]

			if (item) then
				item.data = item.data or {}
				item.data[key] = value

				local panel = item.invID and Fusion.gui["inv"..item.invID] or Fusion.gui.inv1

				if (panel and panel.panels) then
					local icon = panel.panels[id]

					if (icon) then
						icon:SetToolTip(
							Format(Fusion.config.itemFormat,
							item.getName and item:getName() or (item.name), item:getDesc() or "")
						)
					end
				end
			end
		end)

		netstream.Hook("invSet", function(invID, x, y, uniqueID, id, owner, data, a)
			local character = LocalPlayer():getChar()

			if (owner) then
				character = Fusion.character.loaded[owner]
			end

			if (character) then
				local inventory = Fusion.item.inventories[invID]

				if (inventory) then
					local item = uniqueID and id and Fusion.item.new(uniqueID, id) or nil
					item.invID = invID

					item.data = {}
					-- Let's just be sure about it kk?
					if (data) then
						item.data = data
					end

					inventory.slots[x] = inventory.slots[x] or {}
					inventory.slots[x][y] = item

					local panel = Fusion.gui["inv"..invID] or Fusion.gui.inv1

					if (IsValid(panel)) then
						local icon = panel:addIcon(item.model or "models/props_junk/popcan01a.mdl", x, y, item.width, item.height)

						if (IsValid(icon)) then
							icon:SetToolTip(
								Format(Fusion.config.itemFormat,
								item.getName and item:getName() or (item.name), item:getDesc() or "")
							)
							icon.itemID = item.id

							panel.panels[item.id] = icon
						end
					end
				end
			end
		end)

		netstream.Hook("invMv", function(invID, itemID, x, y)
			local inventory = Fusion.item.inventories[invID]
			local panel = Fusion.gui["inv"..invID]

			if (inventory and IsValid(panel)) then
				local icon = panel.panels[itemID]

				if (IsValid(icon)) then
					icon:move({x2 = x, y2 = y}, panel, true)
				end
			end
		end)

		netstream.Hook("invRm", function(id, invID, owner)
			local character = LocalPlayer():getChar()

			if (owner) then
				character = Fusion.character.loaded[owner]
			end

			if (character) then
				local inventory = Fusion.item.inventories[invID]

				if (inventory) then
					inventory:remove(id)

					local panel = Fusion.gui["inv"..invID] or Fusion.gui.inv1

					if (IsValid(panel)) then
						local icon = panel.panels[id]

						if (IsValid(icon)) then
							for k, v in ipairs(icon.slots or {}) do
								if (v.item == icon) then
									v.item = nil
								end
							end

							icon:Remove()
						end
					end
				end
			end
		end)
	else
		function Fusion.item.loadItemByID(itemIndex, recipientFilter)
			local range
			if (type(itemIndex) == "table") then
				range = "("..table.concat(itemIndex, ", ")..")"
			elseif (type(itemIndex) == "number") then
				range = "(".. itemIndex ..")"
			else
				return
			end

			mysql:RawQuery("SELECT _itemID, _uniqueID, _data FROM fusion_items WHERE _itemID IN "..range, function(data)
				if (data) then
					for k, v in ipairs(data) do
						local itemID = tonumber(v._itemID)
						local data = util.JSONToTable(v._data or "[]")
						local uniqueID = v._uniqueID
						local itemTable = Fusion.item.list[uniqueID]

						if (itemTable and itemID) then
							local item = Fusion.item.new(uniqueID, itemID)

							item.data = data or {}
							item.invID = 0
						end
					end
				end
			end)
		end

		netstream.Hook("invMv", function(client, oldX, oldY, x, y, invID, newInvID)
			oldX, oldY, x, y, invID = tonumber(oldX), tonumber(oldY), tonumber(x), tonumber(y), tonumber(invID)
			if (!oldX or !oldY or !x or !y or !invID) then return end

			local character = client:getChar()

			if (character) then
				local inventory = Fusion.item.inventories[invID]

				if (!inventory or inventory == nil) then
					inventory:sync(client)
				end

				if ((!inventory.owner or (inventory.owner and inventory.owner == character:getID())) or (inventory.onCheckAccess and inventory:onCheckAccess(client))) then
					local item = inventory:getItemAt(oldX, oldY)

					if (item) then
						if (newInvID and invID != newInvID) then
							local inventory2 = Fusion.item.inventories[newInvID]

							if (inventory2) then
								item:transfer(newInvID, x, y, client)
							end

							return
						end

						if (inventory:canItemFit(x, y, item.width, item.height, item)) then
							item.gridX = x
							item.gridY = y

							for x2 = 0, item.width - 1 do
								for y2 = 0, item.height - 1 do
									local oldX = inventory.slots[oldX + x2]

									if (oldX) then
										oldX[oldY + y2] = nil
									end
								end
							end

							for x2 = 0, item.width - 1 do
								for y2 = 0, item.height - 1 do
									inventory.slots[x + x2] = inventory.slots[x + x2] or {}
									inventory.slots[x + x2][y + y2] = item
								end
							end

							local receiver = inventory:getReceiver()

							if (receiver and type(receiver) == "table") then
								for k, v in ipairs(receiver) do
									if (v != client) then
										netstream.Start(v, "invMv", invID, item:getID(), x, y)
									end
								end
							end

							if (!inventory.noSave) then
								mysql:RawQuery("UPDATE fusion_items SET _x = "..x..", _y = "..y.." WHERE _itemID = "..item.id)
							end
						end
					end
				end
			end
		end)

		netstream.Hook("invAct", function(client, action, item, invID, data)
			local character = client:getChar()

			if (!character) then
				return
			end

			local inventory = Fusion.item.inventories[invID]

			if (type(item) != "Entity") then
				if (!inventory or !inventory.owner or inventory.owner != character:getID()) then
					return
				end
			end

			if (hook.Run("CanPlayerInteractItem", client, action, item, data) == false) then
				return
			end

			if (type(item) == "Entity") then
				if (IsValid(item)) then
					local entity = item
					local itemID = item.fusionItemID
					item = Fusion.item.instances[itemID]

					if (!item) then
						return
					end

					item.entity = entity
					item.player = client
				else
					return
				end
			elseif (type(item) == "number") then
				item = Fusion.item.instances[item]

				if (!item) then
					return
				end

				item.player = client
			end

			if (item.entity) then
				if (item.entity:GetPos():Distance(client:GetPos()) > 96) then
					return
				end
			elseif (!inventory:getItemByID(item.id)) then
				return
			end

			local callback = item.functions[action]
			if (callback) then
				if (callback.onCanRun and callback.onCanRun(item, data) == false) then
					item.entity = nil
					item.player = nil

					return
				end

				local entity = item.entity
				local result

				if (item.hooks[action]) then
					result = item.hooks[action](item, data)
				end

				if (result == nil) then
					result = callback.onRun(item, data)
				end

				if (item.postHooks[action]) then
					-- Posthooks shouldn't override the result from onRun
					item.postHooks[action](item, result, data)
				end

				hook.Run("OnPlayerInteractItem", client, action, item, result, data)

				if (result != false) then
					if (IsValid(entity)) then
						entity.fusionIsSafe = true
						entity:Remove()
					else
						item:remove()
					end
				end

				item.entity = nil
				item.player = nil
			end
		end)
	end

	-- Instances and spawns a given item type.
	function Fusion.item.spawn(uniqueID, position, callback, angles, data)
		Fusion.item.instance(0, uniqueID, data or {}, 1, 1, function(item)
			local entity = item:spawn(position, angles)

			if (callback) then
				callback(item, entity)
			end
		end)
	end
end


Fusion.item.loadFromDir("fusionrp/gamemode/modules/inventory/items")