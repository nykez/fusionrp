GM.Name = "Fusion RP"
GM.Author = "Dark Fusion Gaming"
GM.Version = "0.1"

/* You must change this in order to use a different folder name throughout the gamemode. */
GM.FolderName = "fusionrp"

PLAYER = FindMetaTable("Player")
ENTITY = FindMetaTable("Entity")

FUSION = FUSION or {}


local function client(file)
	if SERVER then AddCSLuaFile(file) end

	if CLIENT then
		return include(file)
	end
end

local function server(file)
	if SERVER then
		return include(file)
	end
end

local function shared(file)
	return client(file) or server(file)
end


// Usage:
// shared("myfile/myfile.lua")
