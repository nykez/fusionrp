GM.Name = "Fusion RP"
GM.Author = "Dark Fusion Gaming"
GM.Version = "0.1"

/* You must change this in order to use a different folder name throughout the gamemode. */
GM.FolderName = "fusionrp"

PLAYER = FindMetaTable("Player")
ENTITY = FindMetaTable("Entity")

Fusion = Fusion or {}
Fusion.util = Fusion.util or {}

function Fusion.util.Client(file)
	if SERVER then AddCSLuaFile(file) end

	if CLIENT then
		return include(file)
	end
end

function Fusion.util.Server(file)
	if SERVER then
		return include(file)
	end
end

function Fusion.util.Shared(file)
	return Fusion.util.Client(file) or Fusion.util.Server(file)
end


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

/* Load core components */
/* Note: all core files must contain a cl, sh, or sv prefix in order to be recognized */

local root = GM.FolderName .. "/gamemode/core/"
local cl_files = file.Find(root .. "cl_*.lua", "LUA")
local sh_files = file.Find(root .. "sh_*.lua", "LUA")
local sv_files = file.Find(root .. "sv_*.lua", "LUA")

for k, v in pairs(cl_files) do
    client(root .. v)
end

for k, v in pairs(sh_files) do
    shared(root .. v)
end

for k, v in pairs(sv_files) do
    server(root .. v)
end
