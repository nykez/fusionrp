Fusion.vehicles = Fusion.vehicles or {}
Fusion.vehicles.cache = Fusion.vehicles.cache or {}


util.AddNetworkString("Fusion.vehicles.sync")
function Fusion.vehicles:PurchaseCar(pPlayer, id, color)
	if not pPlayer then return end

	if not id then return end


	local car = Fusion.vehicles:GetCarByID(id)

	if not car then return end

	if pPlayer.vehicles[id] then return end

	if pPlayer:GetWallet() < car.price then return end

	pPlayer.vehicles[id] = {
		color = Color(255, 255, 255),
		skin = 0,
		bodygroups = {}
	}

	self:Sync(pPlayer)
	self:Save(pPlayer)
end

function Fusion.vehicles:SellCar(ply, id)
	if !IsValid(ply) then return end
	if !id then return end

	local car = Fusion.vehicles:GetCarByID(id)
	if !car then return end

	if ply.vehicles[id] then return end

	ply:AddBank(math.Round(car.price / 2))

	ply.vehicles[id] = nil

	self:Sync(ply)
	self:Save(ply)
end

function Fusion.vehicles:Sync(pPlayer)
	net.Start("Fusion.vehicles.sync")
		net.WriteTable(pPlayer.vehicles or {})
	net.Send(pPlayer)
end

function Fusion.vehicles:Save(pPlayer)
	if not pPlayer.vehicles then
		pPlayer.vehicles = {}
	end

	local data = Fusion.util:JSON(pPlayer.vehicles or {})

	local updateObj = mysql:Update("player_data");
		updateObj:Update("vehicles", data)
		updateObj:Where("steam_id", pPlayer:SteamID())
	updateObj:Execute();
end