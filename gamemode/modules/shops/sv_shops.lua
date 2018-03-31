
Fusion.shops = Fusion.shops or {}

util.AddNetworkString("Fusion.shops.purchase")
util.AddNetworkString("Fusion.shops.sell")

function Fusion.shops:Purchase(pPlayer, id, item)
	if not self:HasItem(id, item) then return end

	local data = Fusion.inventory:GetItem(item)

	if not data then return end
	
	if not pPlayer:CanAfford(data.price) then
		pPlayer:Notify("You can't afford this item.")
	end


	Fusion.inventory:Add(pPlayer, item, 1)
	pPlayer:TakeMoney(data.price)
end

function Fusion.shops:Sell(pPlayer, id)

end