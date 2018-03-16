GM.Name = "Fusion RP"
GM.Author = "Dark Fusion Gaming"
GM.Version = "0.1"

/* You must change this in order to use a different folder name throughout the gamemode. */
GM.FolderName = "fusionrp"

PLAYER = FindMetaTable("Player")
ENTITY = FindMetaTable("Entity")

Fusion = Fusion or {}

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

/* Load modules */
/* Note: all module files must contain a cl, sh, or sv prefix in order to be recognized */

-- root = GM.FolderName .. "/gamemode/modules/"
-- local _, folders = file.Find(root .. "*", "LUA")

-- print("[Fusion RP] Initializing modules...")

-- for _, folder in SortedPairs(folders, true) do
--     if folder == "." or folder == ".." then continue end

--     for _, temp in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
--         client(root .. folder .. "/" .. temp)
--     end

--     for _, temp in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
--         shared(root .. folder .. "/" .. temp)
--     end

--     for _, temp in SortedPairs(file.Find(root .. folder .. "/sv_*.lua", "LUA"), true) do
--         server(root .. folder .. "/" .. temp)
--     end

-- 	print("\t-> " .. folder)
-- end

-- print("[Fusion RP] Completed!")
