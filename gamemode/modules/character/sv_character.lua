Fusion.character = Fusion.character or {}
Fusion.character.cache = Fusion.character or {}

util.AddNetworkString("fusion.character.create")

net.Receive("fusion.character.create",function(len, pPlayer)
	local data = net.ReadTable()

	if not data then return end

	PrintTable(data)
	
	Fusion.character:CreateCharacter(pPlayer, data)
end)

function Fusion.character:CreateCharacter(pPlayer, tblData)
	if not IsValid(pPlayer) then return end
	
	print("creating character")

	local fname = tblData.fname
	local lname = tblData.fname
	local model = tblData.model

	tblData.fname = nil
	tblData.fname = nil
	tblData.model = nil

	local validModel = true

	-- for k,v in pairs(fusion.config.models) do
	-- 	if v == model then
	-- 		validModel = true
	-- 	end
	-- end

	if !validModel then
		MsgN("Player tried creating a character with a model that doesn't exist in config. Exploit?")
		return
	end

	// Ready JSON
	//local ourModelData = util.TableToJSON(table table,boolean prettyPrint=false)

	local updateObj = mysql:Update("player_data");
		updateObj:Where("steam_id", pPlayer:SteamID());
		updateObj:Update("model", model);
		updateObj:Update("rp_first", "nigger");
		updateObj:Update("rp_last", lname);
		//updateObj:Update("modeldata", ourModelData);
	updateObj:Execute();

	print("finishec character")

	//self:PostCreation(pPlayer, data)
end

function Fusion.character:PostCreation(pPlayer, data)




end