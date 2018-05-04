Fusion.vehicles = Fusion.vehicles or {}
Fusion.vehicles.cache = Fusion.vehicles.cache or {}
Fusion.vehicles.make = Fusion.vehicles.make or {}

util.AddNetworkString("Fusion.vehicles.sync")
util.AddNetworkString("Fusion.vehicles.buy")

netstream.Hook("FusionVehicleSync", function(pPlayer, id, color, type)
	if type == "buy" then
		Fusion.vehicles.Purchase(pPlayer, id, color)
	elseif type == "sell" then
		Fusion.vehicles.Sell(pPlayer, id)
	end
end)

function Fusion.vehicles.Purchase(pPlayer, id, color)
	if not IsValid(pPlayer) then return end
	
	local character = pPlayer:getChar()
	if not character then return end
	
	local veh = Fusion.vehicles:GetTable(id)
	if not veh then return end

	local price = veh.price

	if !character:hasMoney(price) then 
		pPlayer:Notify("You can't afford this vehicle.")
		return 
	end

	if pPlayer:HasVehicle(id) then
		pPlayer:Notify("You already own this vehicle!")
		return
	end
	
	local vehicle_data = character:getData('vehicles', {})
	vehicle_data[id] = {
		color = color,
		skin = 0,
		bodygroups = {}
	}
	character:setData("vehicles", vehicle_data)

	character:takeMoney(price)

	pPlayer:Notify("You bought the " .. veh.name .. " for $" .. price .. "!")

	character:Save()
end

function Fusion.vehicles.Sell(pPlayer, id)
	if not IsValid(pPlayer) then return end

	local character = pPlayer:getChar()
	if not character then return end

	local veh = Fusion.vehicles:GetTable(id)
	if not veh then return end

	local data = character:getData("vehicles", {})
	if not data[id] then return end
	
	// 30%
	character:AddMoney(veh.price * 0.30)
	data[id] = nil

	character:setData("vehicles", data)

	pPlayer:Notify("You have sold your vehicle.")

end


concommand.Add("printcars", function(ply, cmd, args)
	PrintTable(ply.vehicles)
end)
