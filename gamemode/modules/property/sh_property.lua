Fusion.property = Fusion.property or {}
Fusion.property.cache = Fusion.property.cache or {}
Fusion.property.owners = Fusion.property.owners or {}

function Fusion.property:Load()
	local files, folders = file.Find(GAMEMODE.FolderName.."/gamemode/modules/property/properties/*", "LUA")

	for k, v in pairs(folders) do
		//if string.lower(v) != string.lower(game.GetMap()) then continue end
		local dir = GAMEMODE.FolderName .. "/gamemode/modules/property/properties/" .. v .. "/*.lua"

		for _, file in pairs(file.Find(dir, "LUA")) do
			local path = GAMEMODE.FolderName .. "/gamemode/modules/property/properties/" .. v .. "/" .. file

			if SERVER then
				AddCSLuaFile(path)
			end

			include(path)
		end
	end

	MsgN("[Fusion RP] Loaded all properties")
end
hook.Add("PostGamemodeLoaded", "Fusion.LoadProperties", Fusion.property.Load)

function Fusion.property:Register(tbl)
    if !tbl or !tbl.id then return end
    if !Fusion.property.cache then return end

    PrintTable(tbl)

    if !Fusion.property.cache[tbl.id] then
        Fusion.property.cache[tbl.id] = tbl
    end
end

function Fusion.property:Get(id)
    return Fusion.property.cache[id]
end

function Fusion.property:GetOwner(id)
    return Fusion.property.owners[id]
end

function Fusion.property:IsOwned(id)
	return Fusion.property.owners[id] and true or false
end