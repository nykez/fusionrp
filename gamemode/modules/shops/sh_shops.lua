Fusion.shops = {}
Fusion.shops.database = Fusion.shops.database or {}

function Fusion.shops:Register(tblData)
	self.database[tblData.id] = tblData
end

function Fusion.shops:GetItems(ID)
	return self.database[ID].items
end

function Fusion.shops:Get(ID)
	return self.database[ID] or false
end

function Fusion.shops:HasItem(ID, item)
	return self.database[ID].items[item] and true or false
end

