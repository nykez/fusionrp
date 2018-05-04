Fusion.vehicles = Fusion.vehicles or {}
Fusion.vehicles.cache = Fusion.vehicles.cache or {}
Fusion.vehicles.make = Fusion.vehicles.make or {}

Fusion.vehicles.config = {
	camera_pos = Vector(-3693.711426, -1038.656372, 193.258728),
	camera_ang = Angle(24.879337, 33.847637, 0.000000),
	vehicle_pos = Vector(-3393.162598, -843.089294, 16),
	vehicle_ang = Angle(0, 33, 0),
	paint_price = 1000
}

function Fusion.vehicles:Load()
	local vehs = file.Find(GAMEMODE.FolderName.."/gamemode/modules/vehicles/vehicles/*.lua", "LUA")

	for k, v in pairs(vehs) do
		local path = GAMEMODE.FolderName.."/gamemode/modules/vehicles/vehicles/"..v


		if SERVER then
			AddCSLuaFile(path)
		end

		include(path)
	end

	MsgN("[Fusion RP] Loaded all vehicles")
end
hook.Add("PostGamemodeLoaded", "FusionRP.LoadVehicles", Fusion.vehicles.Load)

function Fusion.vehicles:Register(tbl)
	if !tbl.id then return end
	Fusion.vehicles.cache[tbl.id] = tbl

	local make = string.lower(tbl.make)

	if !Fusion.vehicles.make[make] then
		Fusion.vehicles.make[make] = {}
	end

	Fusion.vehicles.make[make][tbl.id] = tbl

	util.PrecacheModel(tbl.model)
end

function Fusion.vehicles:GetTable(id)
	return Fusion.vehicles.cache[id]
end

function Fusion.vehicles:GetAll()
	return Fusion.vehicles.cache or {}
end

function PLAYER:HasVehicle(id)
	local character = self:getChar()
	local data = character:getData('vehicles', {})

	return data and data[id] and true or false
end

function ENTITY:GetVehicleOwner()
	if !IsValid(self) then return end
	if !self:IsVehicle() then return end

	return self:GetNetworkedEntity("owner", nil)
end

hook.Add("OnReloaded", "Fusion.ReloadVehicles", Fusion.vehicles.Load)
