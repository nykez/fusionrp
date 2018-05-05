AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


local fil, fol = file.Find(GM.FolderName .. "/gamemode/modules/*", "LUA")

for _, Dir in pairs(fol) do
	for cl, File in pairs(file.Find(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/cl_*.lua", "LUA")) do
		AddCSLuaFile(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/" .. File)
	end

	for sh, File in pairs(file.Find(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/sh_*.lua", "LUA")) do
		AddCSLuaFile(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/" .. File)
		include(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/" .. File)
	end

	for sv, File in pairs(file.Find(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/sv_*.lua", "LUA")) do
		include(GM.FolderName .. "/gamemode/modules/" .. Dir .. "/" .. File)
	end
end

Fusion.util:Font("BebasNeue-Regular")
