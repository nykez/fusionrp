Fusion.vehicles = Fusion.vehicles or {}
Fusion.vehicles.cache = Fusion.vehicles.cache or {}
Fusion.vehicles.make = Fusion.vehicles.make or {}
Fusion.vehicles.Spawns = {
	["rp_rockford_v2b"] = {
		Vector(-5536.057617, -7347.047852, 64.031250),
		Vector(-5526.431152, -7597.670410, 64.031250),
	}
}

netstream.Hook("FusionVehicleSync", function(pPlayer, id, color, type)
	if type == "buy" then
		Fusion.vehicles.Purchase(pPlayer, id, color)
	elseif type == "sell" then
		Fusion.vehicles.Sell(pPlayer, id)
	end
end)

netstream.Hook("FusionVehicleSpawn", function(pPlayer, id )
	Fusion.vehicles.Spawn(pPlayer, id)
end)

netstream.Hook("FusionVehicleModify", function(pPlayer, id, bodygroups, color)
	if color then
		Fusion.vehicles.Modify(pPlayer, id, bodygroups, color)
	else
		Fusion.vehicles.Modify(pPlayer, id, bodygroups)
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
	
	local vehicle_data = character:getVehicles({})
	vehicle_data[id] = {
		color = color,
		skin = 0,
		bodygroups = {}
	}
	character:setVehicles(vehicle_data)

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

	local data = character:getVehicles({})
	if not data[id] then return end
	
	// 30%
	character:AddMoney(veh.price * 0.30)
	data[id] = nil

	character:setData(data)

	pPlayer:Notify("You have sold your vehicle.")

end

function Fusion.vehicles.Spawn(pPlayer, id)
	if !IsValid(pPlayer) then return end 
	local character = pPlayer:getChar()
	if not character then return end

	local veh = Fusion.vehicles:GetTable(id)
	if not veh then return end

	local Vectors = Fusion.vehicles.Spawns[game.GetMap()]
	if not Vectors then return end

	if !pPlayer:HasVehicle(id) then
		return
	end
	
	local spawnPos = nil
	for k,v in pairs(Vectors) do
		local hasEnt = false

		for _, ent in pairs(ents.FindInSphere(v, 25)) do
			if ent and ent:IsVehicle() or ent:IsPlayer() then
				continue
			end

			if !hasEnt then
				spawnPos = v
				break
			end
		end
	end

	if (!spawnPos) then
		pPlayer:Notify('All spots are taken. Try again later.')
		return//
	end

	if pPlayer.vehicle and IsValid(pPlayer.vehicle) then
		pPlayer.vehicle:Remove()
	end


	local ent = ents.Create("prop_vehicle_jeep")
	ent:SetPos(spawnPos)
	ent:SetAngles(Angle(0, 90, 0))
	ent:SetModel(veh.model)
	ent:SetKeyValue("vehiclescript", veh.script)
	ent:Spawn()
	ent.Owner = pPlayer
	pPlayer.vehicle = ent

	local data = pPlayer:getChar():getVehicles({})

	if data[id] then
		
		if data[id].bodygroups then
			for k,v in pairs(data[id].bodygroups) do
				ent:SetBodygroup(k, v)
			end
		end

		if data[id].color then
			ent:SetColor(data[id].color)
		end
	end

	hook.Call("PlayerSpawnedVehicle", GAMEMODE, pPlayer, ent)

end

function Fusion.vehicles.Modify(pPlayer, id, bodygroups, color)
	if not IsValid(pPlayer) then return end

	local character = pPlayer:getChar()
	if not character then return end

	local veh = Fusion.vehicles:GetTable(id)
	if not veh then return end

	local data = character:getVehicles({})
	if not data[id] then return end

	if bodygroups then
		data[id].bodygroups = bodygroups
	end

	if color then
		data[id].color = color
	end

	character:setVehicles(data)

	pPlayer:Notify("You succesfully modified your vehicle.")

	character:Save()
end