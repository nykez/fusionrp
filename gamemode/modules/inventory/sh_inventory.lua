Fusion.inventory = Fusion.inventory or {}
Fusion.inventory.cache = Fusion.inventory.cache or {}

Fusion.inventory.slots = {
	weapon = "equip",
	misc = "misc",
	cosmetic = "cosmetic",
}

Fusion.inventory.maxslots = {
	["equip"] = 2,
	["misc"] = 3,
	["cosmetic"] = 5
}

Fusion.inventory.maxerrors = {
	["equip"] = "Your weapon slots are full.",
	["misc"] = "Your misc slots are full.",
	["cosmetic"] = "Your cosmetics slots are full."
}

function Fusion.inventory:LoadItems()
	local cars = file.Find(GAMEMODE.FolderName.."/gamemode/modules/inventory/items/*.lua", "LUA")

	for k, v in pairs(cars) do
		local path = GAMEMODE.FolderName.."/gamemode/modules/inventory/items/"..v


		if SERVER then
			AddCSLuaFile(path)
		end

		include(path)
	end

	local cars = file.Find(GAMEMODE.FolderName.."/gamemode/modules/shops/shop/*.lua", "LUA")

	for k, v in pairs(cars) do
		local path = GAMEMODE.FolderName.."/gamemode/modules/shops/shop/"..v


		if SERVER then
			AddCSLuaFile(path)
		end

		include(path)
	end

	MsgN("[Fusion RP] Loaded all items")
end
hook.Add("PostGamemodeLoaded", "FusionRP.LoadItems", Fusion.inventory.LoadItems)

function Fusion.inventory:RegisterItem(itemTable)
	if !itemTable or !itemTable.id then return end

	// ENABLE THIS TO DISABLE LUA ITEM REFRESHING //
	
	//if Fusion.inventory.cache[itemTable.id] then return end

	Fusion.inventory.cache[itemTable.id] = itemTable
end

function Fusion.inventory:GetItem(id)
	return Fusion.inventory.cache[id]
end

function Fusion.inventory:GetMaxSlots(slot)
	return Fusion.inventory.maxslots[slot] or false
end


concommand.Add("refresh_inventory", function()
	Fusion.inventory:LoadItems()
end)
