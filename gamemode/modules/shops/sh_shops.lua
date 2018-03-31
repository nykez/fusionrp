Fusion.shops = Fusion.shops or {}
Fusion.shops.database = Fusion.shops.database or {}

function Fusion.shops:Register(tblData)
	self.database[tblData.id] = tblData
end

function Fusion.shops:GetItems(ID)
	return self.database[ID].items or false
end

function Fusion.shops:Get(ID)
	return self.database[ID] or false
end

function Fusion.shops:HasItem(ID, item)
	return self.database[ID].items[item] and true or false
end

if CLIENT then
	function Fusion.shops:OpenShop(id)
		if not self.database[id] then return end
		
		if IsValid(shopmenu) then
			shopmenu:Remove()
			shopmenu = nil
		end

		shopmenu = vgui.Create("FusionShopMenu")
		shopmenu.id = id
	end
end

