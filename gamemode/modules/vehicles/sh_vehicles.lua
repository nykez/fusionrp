Fusion.vehicles = Fusion.vehicles or {}
Fusion.vehicles.cache = Fusion.vehicles.cache or {}


function Fusion.vehicles:LoadVehicles()
	local cars = file.Find(GAMEMODE.FolderName.."/gamemode/modules/vehicles/cars/*.lua", "LUA")

	for k, v in pairs(cars) do
		local path = GAMEMODE.FolderName.."/gamemode/modules/vehicles/cars/"..v


		if SERVER then
			AddCSLuaFile(path)
		end

		include(path)
	end
	
	MsgN("[Fusion RP] Loaded all vehicles")
end
hook.Add("PostGamemodeLoaded", "FusionRP.LoadVehicles", Fusion.vehicles.LoadVehicles)

function Fusion.vehicles:RegisterVehicle(tblCar)
	Fusion.vehicles.cache[tblCar.id] = tblCar
end

function Fusion.vehicles:GetCarByID(ID)
	return Fusion.vehicles.cache[id]
end

function Fusion.vehicles:GetAllCars()
	return Fusion.vehicles.cache
end