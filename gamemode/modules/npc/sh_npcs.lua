Fusion.npcs = Fusion.npcs or {}
Fusion.npcs.cache = Fusion.npcs.cache or {}

function Fusion.npcs:LoadNPC()
	local cars = file.Find(GAMEMODE.FolderName.."/gamemode/modules/npc/npcs/*.lua", "LUA")

	for k, v in pairs(cars) do
		local path = GAMEMODE.FolderName.."/gamemode/modules/npc/npcs/"..v

		if SERVER then
			AddCSLuaFile(path)
		end

		include(path)
	end

	MsgN("[Fusion RP] Loaded all NPCs")
end
hook.Add("PostGamemodeLoaded", "FusionRP.LoadNPCs", Fusion.npcs.LoadNPC)

function Fusion.npcs:RegisterNPC(tblNPC)
	if Fusion.npcs.cache[tblNPC.id] then
		return
	end

	Fusion.npcs.cache[tblNPC.id] = tblNPC

	print('loaded npc ->' .. tblNPC.name)

	if SERVER then
		timer.Simple(5, function()
			local spawnPos = tblNPC.spawn[game.GetMap()][1]
			local angles = tblNPC.angle[game.GetMap()][1]

			if not spawnPos then
				MsgN("No spawn postion for -> " ..tblNPC.name)
				return
			end

			local ent = ents.Create("npc_vendor")
			ent:SetModel(tblNPC.model)
			ent:SetPos(spawnPos)
			ent:SetAngles(angles)
			ent:Spawn()
			ent.id = tblNPC.id

			ent:SetourName(tblNPC.name)
		end)
	end
end

hook.Add("OnReloaded", "Fusion.NPCReload", function()
	Fusion.npcs.cache = {}

	if SERVER then
		local ents = ents.FindByClass("npc_vendor")

		for k,v in pairs(ents) do
			v:Remove()
		end
	end

	Fusion.npcs:LoadNPC()
end)

concommand.Add("flushnpc", function()
	Fusion.npcs.cache = {}

	local ents = ents.FindByClass("npc_vendor")

	for k,v in pairs(ents) do
		v:Remove()
	end

	Fusion.npcs:LoadNPC()
end)
