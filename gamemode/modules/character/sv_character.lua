Fusion.character = Fusion.character or {}
Fusion.character.cache = Fusion.character or {}

util.AddNetworkString("Fusion.character.create")
util.AddNetworkString("Fusion.new.character")

net.Receive("Fusion.character.create",function(len, pPlayer)
	local data = net.ReadTable()

	if not data then return end
	if not pPlayer.IsNew then return end

	PrintTable(data)

	Fusion.character:CreateCharacter(pPlayer, data)

	pPlayer.IsNew = false
end)

function Fusion.character:CreateCharacter(pPlayer, tblData)
	if not IsValid(pPlayer) then return end

	print("creating character")

	local fname = tblData.fname
	local lname = tblData.lname
	local model = tblData.model

	tblData.fname = nil
	tblData.lname = nil
	tblData.model = nil

	local validModel = false

	if table.HasValue(Fusion.config.models[tblData.gender], model) then
		validModel = true
	end

	if !validModel then
		MsgN("Player tried creating a character with a model that doesn't exist in config. Exploit?")
		return
	end

	// Ready JSON
	local ourModelData = "[]"
	if tblData.bodygroups then
		ourModelData = util.TableToJSON(tblData.bodygroups)
	end

	local updateObj = mysql:Update("player_data");
		updateObj:Where("steam_id", pPlayer:SteamID());
		updateObj:Update("model", model);
		updateObj:Update("rp_first", fname);
		updateObj:Update("rp_last", lname);
		updateObj:Update("modeldata", ourModelData);
	updateObj:Execute();

	print("finished character")

	self:PostCreation(pPlayer, tblData, fname, lname, model)
end

function Fusion.character:PostCreation(pPlayer, data, fname, lname, model)
	pPlayer:SetFirstName(fname)
	pPlayer:SetLastName(lname)

	pPlayer:SetModel(model)

	if data.bodygroups then
		Fusion.character:BodyGroups(pPlayer, data.bodygroups)
		pPlayer.character = {
			bodygroups = data.bodygroups
		}
	end

	// Setup spawns


	// Setup team


	// Do loadout

	// Most of these should be functions that are called to use across the gamemode
end


function Fusion.character:BodyGroups(pPlayer, data)
	if not data then return end

	for k,v in pairs(data) do
		pPlayer:SetBodygroup(k, v)
	end

end
