

Fusion.net = Fusion.net or {}
Fusion.net.global = Fusion.net.global or {}

// Check to see if a function is passed if so then null it //
local function CheckType(name, obj)
	local objType = type(obj)

	if objType == "function" then
		return true
	elseif objType == "table" then
		for k,v in pairs(obj) do
			if CheckType(name, k) or CheckType(name, v) then
				return true
			end
		end
	end

	return false
end

function setNetVar(key, value, rec)
	if CheckType(key, value) then return end
	
	Fusion.net.global[key] = value

	netstream.Start(rec, "fusion_Global", key, value)
end


local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")

function PLAYER:SyncVars()
	for k,v in pairs(Fusion.net) do
		if (k == "global") then
			for i, data in pairs(v) do
				netstream.Start(self, "fusion_Global", i, data)
			end
		elseif IsValid(k) then
			for i, data in pairs(v) do
				netstream.Start(self, "fusion_Variable", k:EntIndex(), i, data)
			end
		end
	end
end

function ENTITY:sendNetVar(key, rec)
	netstream.Start(rec, "fusion_Variable", self:EntIndex(), key, Fusion.net[self] and Fusion.net[self][key])
end

function ENTITY:clearNetVars(rec)
	Fusion.net[self] = nil
	netstream.Start(rec, "fusion_Delete", self:EntIndex())
end

function ENTITY:setNetVar(key, value, receiver)
	if (CheckType(key, value)) then return end
		
	Fusion.net[self] = Fusion.net[self] or {}

	if (Fusion.net[self][key] != value) then
		Fusion.net[self][key] = value
	end

	self:sendNetVar(key, receiver)
end

function ENTITY:getNetVar(key, default)
	if (Fusion.net[self] and Fusion.net[self][key] != nil) then
		return Fusion.net[self][key]
	end

	return default
end

function PLAYER:setLocalVar(key, value)
	if (CheckType(key, value)) then return end
	
	Fusion.net[self] = Fusion.net[self] or {}
	Fusion.net[self][key] = value

	netstream.Start(self, "fusion_Local", key, value)
end

PLAYER.getLocalVar = ENTITY.getNetVar

hook.Add("EntityRemoved", "EntityCleanUp", function(entity)
	entity:clearNetVars()
end)

hook.Add("PlayerInitialSpawn", "PlayerSync", function(client)
	client:SyncVars()
end)

hook.Add("PlayerDisconnected", "PlayerDesync", function(client)
	client:clearNetVars()
end)

// Config menu networking ////
netstream.Hook("fusion_setConfig", function(client, key, value)
	if !Fusion.config.canopen(client) then
		client:PrintMessage(HUD_PRINTTALK, "You can't edit config files!!")
		return
	end

	Fusion.config.set(key, value)
end)

netstream.Hook("fusion_spawnChar", function(client, id)
	local character = Fusion.character.loaded[id]

	if (client:getChar() and client:getChar():getID() == id) then
		return
	end
	
	if character and character:getPlayer() == client then
		local currentChar = client:getChar()

		if currentChar then
			currentChar:Save()
		end

		// clear skins/bodygroups //
		client:SetBodyGroups("000000000")
		client:SetSkin(0)

		character:Start()
		client:Spawn()
	end
end)