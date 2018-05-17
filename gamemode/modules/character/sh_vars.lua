

Fusion.character:CharVariable("model", {
	field = "model",
	default = "models/error.mdl",
	onSet = function(character, value)
		local client = character:getPlayer()

		client:SetModel(value)

		character.vars.model = value
	end,
	onGet = function(character, default)
		return character.vars.model or default
	end,
	index = 1,
})

Fusion.character:CharVariable("money", {
	field = "money",
	default = 5000,
	index = 2,
	noDisplay = true,
})

Fusion.character:CharVariable("name", {
	field = "name",
	index = 3,
})

// this will only network to the client, not broadcast //
Fusion.character:CharVariable("data", {
	default = {},
	field = "data",
	index = 4,
	isLocal = true,
	onSet = function(character, key, value, noReplication, receiver)
		local data = character:getData()
		local client = character:getPlayer()

		data[key] = value

		if (!noReplication and IsValid(client)) then
			netstream.Start(receiver or client, "characterData", character:getID(), key, value)
		end

		character.vars.data = data
	end,
	
	onGet = function(character, key, default)
		local data = character.vars.data or {}

		if key then
			if !data then
				return default
			end

			local value = data[key]

			return value == nil and default or value
		else
			return default or data
		end
	end,

})

Fusion.character:CharVariable("description", {
	field = "description",
})

Fusion.character:CharVariable("vehicles", {
	field = "vehicles",
	default = {},
	isLocal = true,
})

Fusion.character:CharVariable("skills", {
	field = "skills",
	default = {},
	isLocal = true,
})


Fusion.character:CharVariable("levels", {
	field = "levels",
	default = {},
	isLocal = true,
})

Fusion.character:CharVariable("org", {
	field = "org",
	isLocal = true,
})

Fusion.character:CharVariable("inv", {
	noNetworking = true,
	noDisplay = true,
	onGet = function(character, index)
		if (index and type(index) != "number") then
			return character.vars.inv or {}
		end

		return character.vars.inv and character.vars.inv[index or 1]
	end
})
