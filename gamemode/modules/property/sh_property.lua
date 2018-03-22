Fusion.property = Fusion.property or {}
Fusion.property.cache = Fusion.property.cache or {}
Fusion.property.owners = Fusion.property.owners or {}
Fusion.property.categories = Fusion.property.categories or {}

Fusion.property.categories = {
	apartment = {
		id = 1,
		name = "Downtown Apartments"
	},

	sub_house = {
		id = 2,
		name = "Suburban Houses"
	},

	downtown = {
		id = 3,
		name = "Downtown"
	},

	uptown = {
		id = 4,
		name = "Uptown"
	},

	industrial = {
		id = 5,
		name = "Industrial"
	},

	club = {
		id = 6,
		name = "Night Clubs"
	},

	uptown_business = {
		id = 7,
		name = "Uptown Businesses"
	},

	downtown_business = {
		id = 8,
		name = "Downtown Businesses"
	},

	mesa = {
		id = 9,
		name = "Mesa Apartments"
	},

	country = {
		id = 10,
		name = "Country Houses"
	},

	country_business = {
		id = 11,
		name = "Country Businesses"
	}
}

function Fusion.property:Load()
	local files, folders = file.Find(GAMEMODE.FolderName.."/gamemode/modules/property/properties/*", "LUA")

	for k, v in pairs(folders) do
		if string.lower(v) != string.lower(game.GetMap()) then continue end
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
    if !tbl then return end
    if !Fusion.property.cache then return end

	local id = #self.cache + 1
	tbl.id = id

    if !Fusion.property.cache[id] then
        Fusion.property.cache[id] = tbl
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

function ENTITY:IsDoor()
	if self:GetClass() == "func_door" or self:GetClass() == "func_door_rotating" or self:GetClass() == "prop_door" or self:GetClass() == "prop_door_rotating" then
		return true
	end

	return false
end

hook.Add("InitPostEntity", "Fusion.InitPropertyDoors", function()
	if SERVER then
		timer.Simple(5, function()
			for k, v in pairs(Fusion.property.cache) do
				if !v.government then
					for _, door in pairs(v.doors) do
						for _, ent in pairs(ents.GetAll()) do
							if ent:IsDoor() and ent:GetPos() == door then
								ent:Fire("lock")
							end
						end
					end
				end
			end
		end)
	end
end)
