AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

/* Load core components */
local root = GM.FolderName .. "/gamemode/core/"
local cl_files = file.Find(root .. "cl_*.lua", "LUA")
local sh_files = file.Find(root .. "sh_*.lua", "LUA")
local sv_files = file.Find(root .. "sv_*.lua", "LUA")

for k, v in pairs(cl_files) do
    AddCSLuaFile(root .. v)
end

for k, v in pairs(sh_files) do
    AddCSLuaFile(root .. v)
    include(root .. v)
end

for k, v in pairs(sv_files) do
    include(root .. v)
end
