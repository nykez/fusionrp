
Fusion.shops = Fusion.shops or {}

util.AddNetworkString("Fusion.shops.purchase")
util.AddNetworkString("Fusion.shops.sell")

net.Receive("Fusion.shops.purchase", function(len, pPlayer)
	local tbl = net.ReadTable()
	local id = net.ReadInt(16)


	Fusion.shops:Purchase(pPlayer, tbl, id)
end)

function Fusion.shops:Purchase(pPlayer, tblData, shopID)
 	if !Fusion.shops:ValidItems(tblData, shopID) then
 		print("invalid shop item")
 		return
 	end

	local ourPrice = self:TotalPrice(tblData)

	if !ourPrice then return end
	
	
	if not pPlayer:CanAfford(ourPrice) then
		pPlayer:Notify("You can't afford these items.")
	end

	pPlayer:TakeMoney(ourPrice)

	Fusion.shops:GiveCart(pPlayer, tblData)
	pPlayer:Notify("Purchased successful.")
end

// Protects against hackers attempting to send items that don't exist
function Fusion.shops:ValidItems(tblData, shopID)
	local bool = true

	for k,v in pairs(tblData) do
		if !Fusion.shops:HasItem(shopID, v) then
			bool = false
			break
		end
	end

	return bool
end

function Fusion.shops:TotalPrice(tblData)
	local count = 0

	for k,v in pairs(tblData) do
		local item = Fusion.inventory:GetItem(v)

		if !item.price then
			count = false
			break
		end

		count = count + item.price
	end

	return count
end

function Fusion.shops:GiveCart(pPlayer, tblData)
	if not tblData then return end

	for k,v in pairs(tblData) do
		Fusion.inventory:Add(pPlayer, v, 1)
	end
end