Fusion.inventory = Fusion.inventory or {}
Fusion.inventory.cache = Fusion.inventory.cache or {}

function Fusion.inventory:LoadItems()
	local cars = file.Find(GAMEMODE.FolderName.."/gamemode/modules/inventory/items/*.lua", "LUA")

	for k, v in pairs(cars) do
		local path = GAMEMODE.FolderName.."/gamemode/modules/inventory/items/"..v


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
	if Fusion.inventory.cache[itemTable.id] then return end

	Fusion.inventory.cache[itemTable.id] = itemTable
end

function Fusion.inventory:GetItem(id)
	return Fusion.inventory.cache[id]
end

concommand.Add("refresh_inventory", function()
	Fusion.inventory:LoadItems()
end)
