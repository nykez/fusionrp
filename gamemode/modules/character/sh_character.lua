

Fusion.character = Fusion.character or {}
Fusion.character.cache = Fusion.character.cache or {}
Fusion.character.loaded = Fusion.character.loaded or {}
Fusion.character.vars = Fusion.character.vars or {}


Fusion.util.Shared("sh_meta.lua")

if (SERVER) then
	function Fusion.character.Create(tblData, callback)
		local timeStamp = math.floor(os.time())

		tblData.money = tblData.money or 7500

		if tblData.data then
			tblData.data = util.TableToJSON(tblData.data)
		else
			tblData.data = "[]"
		end

		local ourCharacterID = nil

		local insertObj = mysql:Insert("fusion_characters");
		insertObj:Insert("steamid", tblData.steamid)
		insertObj:Insert("model", tblData.model)
		insertObj:Insert("money", tblData.money)
		insertObj:Insert("create_time", timeStamp)
		insertObj:Insert("data", tblData.data)
		insertObj:Insert("name", tblData.name)
		insertObj:Insert("whitelist", "[]")
		insertObj:Insert("inventory", "[]")
		insertObj:Insert("vehicles", "[]")
		insertObj:Insert("description", tblData.desc or "nil")
		insertObj:Callback(function(result, status, charID)
			print("character ID: " .. charID)
			local client = nil

			for k,v in pairs(player.GetAll()) do
				if v:SteamID() == tblData.steamid then
					client = v
				end
			end

			ourCharacterID = charID
			local character = Fusion.character.New(tblData, charID, client, tblData.steamid)

			Fusion.character.loaded[charID] = character

			Fusion.character.cache[tblData.steamid] = charID

			PrintTable(Fusion.character.cache)

			if ourCharacterID and callback then
				callback(ourCharacterID)
			end

		end);
		insertObj:Execute();
	end


	function Fusion.character.BuildCharacters(pPlayer, func, noCache, id)
		local steamid = pPlayer:SteamID64()

		local cache = Fusion.character.cache[steamid]

		// this prolly won't work since we clear their character tables on disconnect //
		// but oh well, let's try it anyways
		if (cache and noCache and noCache == true) then
			for k,v in pairs(cache) do
				local character = Fusion.character.loaded[v]

				if (character and !IsValid(character.player)) then
					character.player = pPlayer
				end

				if func then
					func(cache)
				end

				// we found all their characters, so stop it there //
				return
			end
		end


		// This function needs to be revisted after profile results. Could be a bit heavy //
		local queryObj = mysql:Select("fusion_characters");
		queryObj:Where("steamid", pPlayer:SteamID64());
		// only find the character by its id
		if id then
			queryObj:Where("id", id)
		end
		queryObj:Callback(function(result, status, lastID)
			if (type(result) == "table" and #result > 0) then
				local characters = {}

				for k,v in pairs(result or {}) do
					local ourID = tonumber(v.id)


					if (ourID) then
						local data = {}

						for k2, v2 in pairs(Fusion.character.vars) do
							if (v2.field and v[v2.field]) then
								local value = tostring(v[v2.field])
								if (type(v2.default) == "number") then
									value = tonumber(value) or v2.default
								elseif (type(v2.default) == "boolean") then
									value = tobool(value)
								elseif (type(v2.default) == "table") then
									value = util.JSONToTable(value)
								end

								data[k2] = value
							end
						end

						characters[#characters + 1] = ourID


						local character = Fusion.character.New(data, ourID, pPlayer)

						Fusion.character.loaded[ourID] = character
					end

				end

				if func then
					func(characters)
				end

				Fusion.character.cache[steamid] = characters
			else
				func({})
			end

		end)
		queryObj:Execute()
	end

// end serverside code
end

function Fusion.character.New(tblData, id, pPlayer, steamID)

	if (tblData.name) then
		tblData.name = tblData.name:gsub("#", "#​")
	end

	if (tblData.desc) then
		tblData.desc = tblData.desc:gsub("#", "#​")
	end

	local character = setmetatable({vars = {}}, Fusion.meta.character)

	for k,v in pairs(tblData) do
		if (v != nil) then
			//print(k, "->", v)
			character.vars[k] = v
		end
	end

	character.id = id
	character.player = pPlayer
	if (IsValid(pPlayer) or steamID) then
		character.steamid = IsValid(pPlayer) and pPlayer:SteamID64() or steamID
		character.steamID = IsValid(pPlayer) and pPlayer:SteamID64() or steamID
	end

	return character

end

// Overwrite _R metamethods //
local PLAYER = FindMetaTable("Player")

function PLAYER:getChar()
	return Fusion.character.loaded[self.getNetVar(self, "char")] or false
end

function PLAYER:Name()
	local char = self.getChar(self)

	return character and character.getName(char)
end

-- PLAYER.Nick = PLAYER.Name

if SERVER then
	concommand.Add("test", function(pPlayer)
		local char = pPlayer:getChar()

		char:setData("license", true)
		char:Save()
	end)
end