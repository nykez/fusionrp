Fusion.shops = Fusion.shops or {}
Fusion.shops.database = Fusion.shops.database or {}

-- function Fusion.shops.LoadShops()
-- 	local cars = file.Find(GAMEMODE.FolderName.."/gamemode/modules/shops/shop/*.lua", "LUA")

-- 	for k, v in pairs(cars) do
-- 		local path = GAMEMODE.FolderName.."/gamemode/modules/shops/shop/"..v


-- 		if SERVER then
-- 			AddCSLuaFile(path)
-- 		end

-- 		include(path)
-- 	end

-- 	MsgN("[Fusion RP] Loaded all shops")
-- end
-- hook.Add("PostGamemodeLoaded", "FusionRP.LoadShopsss", Fusion.inventory.LoadShops)

function Fusion.shops:Register(tblData)
	Fusion.shops.database[tblData.id] = tblData
end

function Fusion.shops:GetItems(ID)
	return Fusion.shops.database[ID].items or false
end

function Fusion.shops:Get(ID)
	return Fusion.shops.database[ID] or false
end

function Fusion.shops:HasItem(ID, item)
	return Fusion.shops.database[ID].items[item] and true or false
end

if CLIENT then
	function Fusion.shops:OpenShop(id)
		if not Fusion.shops.database[id] then return end
		
		if IsValid(shopmenu) then
			shopmenu:Remove()
			shopmenu = nil
		end

		shopmenu = vgui.Create("FusionShopMenu")
		shopmenu.id = id
	end
end

-- Fusion.shops:LoadShops()


