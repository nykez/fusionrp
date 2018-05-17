
Fusion.net = Fusion.net or {}
Fusion.net.global = Fusion.net.global or {}


// Network something to the client only //
netstream.Hook("fusion_Local", function(key, value)
	Fusion.net[LocalPlayer():EntIndex()] = Fusion.net[LocalPlayer():EntIndex()] or {}
	Fusion.net[LocalPlayer():EntIndex()][key] = value
end)

// Delete the net table/data //
netstream.Hook("fusion_Delete", function(index)
	Fusion.net[index] = nil
end)

netstream.Hook("fusion_Variable", function(index, key, value)
	Fusion.net[index] = Fusion.net[index] or {}
	Fusion.net[index][key] = value
end)

netstream.Hook("fusion_Global", function(key, value)
	Fusion.net.global[key] = value
end)

netstream.Hook("fusion_CharAuth", function(vault, ...)
	if type(vault) == "table" then
		Fusion.characters = vault
	end

	vgui.Create("CharacterMainMenu")
end)

netstream.Hook('fusion_OpenMain', function(characters)
	if characters then
		Fusion.characters = characters
	end

	print("opening main character menuuuu")
	vgui.Create("CharacterMainMenu")
end)

netstream.Hook("characterInfo", function(data, id, client)
	Fusion.character.loaded[id] = Fusion.character.New(data, id, client == nil and LocalPlayer() or client)
end)

netstream.Hook("characterSet", function(key, value, id)
	id = id or (LocalPlayer():getChar() and LocalPlayer():getChar().id)
			
	local character = Fusion.character.loaded[id]

	if (character) then
		character.vars[key] = value
	end
end)

netstream.Hook("characterVar", function(key, value, id)
	id = id or (LocalPlayer():getChar() and LocalPlayer():getChar().id)

	local character = Fusion.character.loaded[id]

	if (character) then
		local oldVar = character:getVar()[key]
		character:getVar()[key] = value
	end
end)

netstream.Hook("characterData", function(id, key, value)
	local character = Fusion.character.loaded[id]

	if (character) then
		character.vars.data = character.vars.data or {}
		character:getData()[key] = value
	end
end)

function getNetVar(key, default)
	local value = Fusion.net.global[key]

	return value != nil and value or default
end

local PLAYER = FindMetaTable('Player')
local ENTITY = FindMetaTable('Entity')

function PLAYER:getNetVar(key, default)
	local index = self:EntIndex()

	if Fusion.net[index] and Fusion.net[index][key] then
		return Fusion.net[index][key]
	end

	return default
end

ENTITY.getNetVar = PLAYER.getNetVar
PLAYER.getLocalVar = ENTITY.getNetVar


// Config management //
netstream.Hook("fusion_setConfig", function(key, value)
	local config = Fusion.config.cache[key]

	print('changing local var', key, "->", value)
	if config then
		if config.callback then
			config.callback(config.value, value)
		end

		config.value = value

		//Fusion.config.cache[key] = value
	end

end)

netstream.Hook("fusion_configSync", function(data)
	for k, v in pairs(data) do
		if (Fusion.config.cache[k]) then
			Fusion.config.cache[k].value = v
		end
	end
end)