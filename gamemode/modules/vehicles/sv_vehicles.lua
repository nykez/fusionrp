Fusion.vehicles = Fusion.vehicles or {}
Fusion.vehicles.cache = Fusion.vehicles.cache or {}

util.AddNetworkString("Fusion.vehicles.sync")

function Fusion.vehicles:Purchase(ply, id, color)
	if not ply then return end
	if not id then return end

	local veh = Fusion.vehicles:GetTable(id)

	if not veh then return end

	if ply.vehicles[id] then return end

	if ply:GetWallet() < veh.price then return end

	ply.vehicles[id] = {
		color = Color(255, 255, 255),
		skin = 0,
		bodygroups = {}
	}

	self:Sync(pPlayer)
	self:Save(pPlayer)
end

function Fusion.vehicles:Sell(ply, id)
	if !IsValid(ply) then return end
	if !id then return end

	local veh = Fusion.vehicles:GetTable(id)
	if !veh then return end

	if ply.vehicles[id] then return end

	ply:AddBank(math.Round(veh.price / 2))

	ply.vehicles[id] = nil

	self:Sync(ply)
	self:Save(ply)
end

function Fusion.vehicles:Sync(pPlayer)
	net.Start("Fusion.vehicles.sync")
		net.WriteTable(pPlayer.vehicles or {})
	net.Send(pPlayer)
end
hook.Add("Fusion.PlayerLoaded", function(ply)
	Fusion.vehicles:Sync(ply)
end)

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
