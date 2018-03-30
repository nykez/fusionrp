Fusion.vehicles = Fusion.vehicles or {}
Fusion.vehicles.cache = Fusion.vehicles.cache or {}
Fusion.vehicles.make = Fusion.vehicles.make or {}

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

	if !Fusion.vehicles.make[tbl.make] then
		Fusion.vehicles.make[tbl.make] = {}
	end
	
	Fusion.vehicles.make[tbl.make][tbl.id] = tbl
end

function Fusion.vehicles:GetTable(id)
	return Fusion.vehicles.cache[id]
end

function Fusion.vehicles:GetAll()
	return Fusion.vehicles.cache or {}
end

function ENTITY:GetVehicleOwner()
	if !IsValid(self) then return end
	if !self:IsVehicle() then return end

	return self:GetNetworkedEntity("owner", nil)
end

hook.Add("OnReloaded", "Fusion.ReloadVehicles", Fusion.vehicles.Load)
