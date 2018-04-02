Fusion.vehicles = Fusion.vehicles or {}
Fusion.vehicles.cache = Fusion.vehicles.cache or {}
Fusion.vehicles.make = Fusion.vehicles.make or {}

util.AddNetworkString("Fusion.vehicles.sync")
util.AddNetworkString("Fusion.vehicles.buy")

function Fusion.vehicles:Purchase(ply, id, color)
	if not ply then return end
	if not id then return end

	local veh = Fusion.vehicles:GetTable(id)
	if not veh then return end

	local price = veh.price

	if color != Color(255, 255, 255) then
		price = price + self.config.paint_price
	end

	if ply:HasVehicle(id) then return end

	if ply:GetBank() < price then return end

	ply.vehicles[id] = {
		color = color,
		skin = 0,
		bodygroups = {}
	}

	ply:TakeBank(price)

	ply:Notify("You bought the " .. veh.name .. " for $" .. price .. "!")

	self:Sync(ply)
	self:Save(ply)
end

function Fusion.vehicles:Sell(ply, id)
	if !IsValid(ply) then return end
	if !id then return end

	local veh = Fusion.vehicles:GetTable(id)
	if !veh then return end

	if !ply:HasVehicle(id) then return end

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

net.Receive("Fusion.vehicles.buy", function(len, ply)
	Fusion.vehicles:Purchase(ply, net.ReadString(), net.ReadColor())
end)

net.Receive("Fusion.vehicles.sell", function(len, ply)
	Fusion.vehicles:Sell(ply, net.ReadInt(16))
end)
