// Don't autoinclude this file //

Fusion.meta = Fusion.meta or {}

local char = Fusion.meta.character or {}
debug.getregistry().Character = Fusion.meta.character

char.__index = char
char.id = char.id or 0
char.vars = char.vars or {}

function char:__tostring()
	return "character["..(self.id or 0).."]"
end

function char:__eq(other)
	return self:getID() == other:getID()
end

function char:getID()
	return self.id
end

function char.__eq(calling)
	return self:getID() == calling:getID()
end


if SERVER then

	function char:Save(callback)
		
		local data = {}

		for k,v in pairs(Fusion.character.vars) do
			if (v.field and self.vars[k] != nil) then
				data[v.field] = self.vars[k]
				if (type(v.field) == "table") then
				end
			end
		end


		local updateObj = mysql:Update("fusion_characters");
			for k, v in pairs(data) do
				if type(v) == "table" then
					v = util.TableToJSON(v)
				end
				updateObj:Update(k, v)
			end
		updateObj:Where("id", self.id)
		updateObj:Execute();

	end

	function char:Sync(rec)
		--print('syncing')
		if (rec == nil) then
			for k,v in pairs(player.GetAll()) do
				self:Sync(v)
			end
		elseif (rec == self.player) then
			local data = {}

			for k,v in pairs(self.vars) do
				if (Fusion.character.vars[k] != nil and !Fusion.character.vars.noNetworking) then
					data[k] = v
				end
			end
			netstream.Start(self.player, "characterInfo", data, self:getID())
		else
			local data = {}

			for k,v in pairs(Fusion.character.vars) do
				if (!v.noNetworking and !v.isLocal) then
					data[k] = self.vars[k]
				end
			end
			netstream.Start(rec, "characterInfo", data, self:getID(), self.player)
		end

	end

	function char:Start(boolNetwork)
		local client = self:getPlayer()

		if not client then return end

		client:SetModel(self:getModel())
		//client:SetTeam(self:getTeam())
		client:setNetVar("char", self:getID())


		//client:SetSkin(self:getData("skin", 0))

		local bodygroups = self:getData("bodygroups", {})
		if bodygroups then
			for k,v in pairs(bodygroups) do
				client:SetBodygroup(k, v)
			end
		end

		self:Sync()

		hook.Run("fusion_CharacterLoaded", self:getID(), client)
	end

	function char:kick()
		local client = self:getPlayer()
		client:KillSilent()

		local steamid = client:SteamID64()
		local id = self:getID()
		local isCurrentChar = self and self:getID() == id

		if (self and self.steamID == steamID) then
			netstream.Start(client, "charKick", id, isCurrentChar)

			if (isCurrentChar) then
				client:setNetVar("char", nil)
				client:Spawn()
			end
		end
	end
end

function char:getPlayer()
	if IsValid(self.player) then
		return self.player
	elseif (self.steamid) then
		for k,v in pairs(player.GetAll()) do
			if v:SteamID64() == self.steamid then
				return v
			end
		end
	end
end

function Fusion.character:CharVariable(key, data)
	Fusion.character.vars[key] = data

	data.index = data.index or #Fusion.character.vars

	local upperName = key:sub(1, 1):upper()..key:sub(2)

	if (SERVER and !data.strict) then
		if (data.onSet) then
			char["set"..upperName] = data.onSet
		elseif (data.noNetwork) then
			char["set"..upperName] = function(self, value)
				self.vars[key] = value
			end
		elseif (data.isLocal) then
			char["set"..upperName] = function(self, value)
				local currentCharacter = self:getPlayer() and self:getPlayer():getChar()

				// send character ID?
				local sendID = true

				if (currentCharacter and currentCharacter == self) then
					sendID = false
				end

				self.vars[key] = value

				netstream.Start(self.player, "characterSet", key, value, sendID and self:getID() or nil)
			end
		else
			char["set"..upperName] = function(self, value)

				self.vars[key] = value


				netstream.Start(nil, "characterSet", key, value, self:getID())
				// broadcast network var //
			end
		end
	end

	// get functions are always shared
	// just for easy use on states

	if (data.onGet) then
		char['get'..upperName] = data.onGet
	else
		char['get'..upperName] = function(self, default)
			local value = self.vars[key]

			if (value != nil) then
				return value
			end

			if (default == nil) then
				return Fusion.character.vars[key] and Fusion.character.vars[key].default or nil
			end

			return default
		end
	end
	
	char.vars[key] = data.default
end


Fusion.meta.character = char