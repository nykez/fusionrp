include("shared.lua")
include("config.lua")

local fil, fol = file.Find(GM.FolderName .. "/gamemode/modules/*", "LUA")

for _, Dir in pairs(fol) do
	for sh, File in pairs(file.Find(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/sh_*.lua", "LUA")) do
		include(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/" .. File)
	end

	for cl, File in pairs(file.Find(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/cl_*.lua", "LUA")) do
		include(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/" .. File)
	end
end
