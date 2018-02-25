include("shared.lua")

/* Load core componenets */
local root = GM.FolderName .. "/gamemode/core/"
local cl_files = file.Find(root .. "cl_*.lua", "LUA")
local sh_files = file.Find(root .. "sh_*.lua", "LUA")

for k, v in pairs(cl_files) do
    include(root .. v)
end

for k, v in pairs(sh_files) do
    include(root .. v)
end
