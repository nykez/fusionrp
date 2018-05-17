

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn_Insert", function(pPlayer)
	local queryObj = mysql:Select("fusion_players");
	queryObj:Where("steam_id", pPlayer:SteamID());
	queryObj:Callback(function(result, status, lastID)
		if (type(result) == "table" and #result > 0) then

			local updateObj = mysql:Update("fusion_players");
				updateObj:Update("nick", pPlayer:Nick());
				updateObj:Update("currentip", pPlayer:IPAddress())
				if result[1].currentip != pPlayer:IPAddress() then
					updateObj:Update("lastip", result[1].currentip)
				end
				updateObj:Where("steam_id", pPlayer:SteamID());
			updateObj:Execute();

		else

			local insertObj = mysql:Insert("fusion_players");
				insertObj:Insert("nick", pPlayer:Nick());
				insertObj:Insert("steam_id", pPlayer:SteamID());
				insertObj:Insert("playtime", 0)
				insertObj:Insert("currentip", pPlayer:IPAddress())
				insertObj:Insert("lastip", "[]")
			insertObj:Execute();

		end;
	end);
	queryObj:Execute();
end)

hook.Add('PlayerInitialSpawn', "fusionplayer_inital", function(pPlayer)
	timer.Simple(5, function()
		pPlayer.loadTime = SysTime()


		Fusion.character.BuildCharacters(pPlayer, 
			function(tblCharacter)
				if not IsValid(pPlayer) then
					hook.Run("fusionplayer_inital", pPlayer)
					return
				end
				
				if !tblCharacter then
					print("no characters")
					netstream.Start(pPlayer, "fusion_OpenMain")
					return
				end

				for k,v in pairs(tblCharacter) do
					Fusion.character.loaded[v]:Sync(pPlayer)
				end

				for k,v in pairs(player.GetAll()) do
					if (v:getChar()) then
						v:getChar():Sync(pPlayer)
					end
				end

				pPlayer.charlist = tblCharacter
				netstream.Start(pPlayer, "fusion_OpenMain", tblCharacter)
			end, false, nil
		)

		pPlayer:SetNoDraw(true)
		pPlayer:SetNotSolid(true)
		pPlayer:Lock(true)

		timer.Simple(1, function()
			pPlayer:KillSilent()
			pPlayer:StripAmmo()
		end)


	end)
end)

hook.Add("PlayerDisconnected", "fusion_player_disconnect", function(pPlayer)
	if not pPlayer.loadTime then return end
	local updateObj = mysql:Update("fusion_players");
	updateObj:Update("playtime", SysTime() - pPlayer.loadTime);
	updateObj:Where("steam_id", pPlayer:SteamID());
	updateObj:Execute();

end)

function GM:PlayerLoadedChar(client, character, lastCharacter)
	hook.Run("PlayerLoadout", client)

end

function GM:PostPlayerLoadout(client)
	client.inventory = {}

end

function GM:PlayerLoadout(client)

	local char = client:getChar()

	if char then
		client:SetupHands()
		
		hook.Run("PostPlayerLoadout", client)
	else
		client:SetNoDraw(true)
		client:Lock()
		client:SetNotSolid(true)
	end
end

function GM:PlayerSpawn(client)
	client:SetNoDraw(false)
	client:UnLock()
	client:SetNotSolid(false)

	hook.Run("PlayerLoadout", client)
end


function GM:PlayerUse(client, entity)
	if (client:getNetVar("restricted")) then
		return false
	end

	if (entity:IsDoor()) then
		local result = hook.Run("CanPlayerUseDoor", client, entity)

		if (result == false) then
			return false
		else
			hook.Run("PlayerUseDoor", client, entity)
		end
	end

	return true
end

function GM:KeyPress(client, key)
	if (key == IN_RELOAD) then

	elseif (key == IN_USE) then
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local entity = util.TraceLine(data).Entity

		if (IsValid(entity) and entity:IsDoor() or entity:IsPlayer()) then
			hook.Run("PlayerUse", client, entity)
		end
	end
end


function GM:CanPlayerInteractItem(client, action, item)
	if (client:getNetVar("restricted")) then
		return false
	end

	if (action == "drop" and hook.Run("CanPlayerDropItem", client, item) == false) then
		return false
	end

	if (action == "take" and hook.Run("CanPlayerTakeItem", client, item) == false) then
		return false
	end

	return client:Alive()
end

function GM:CanPlayerTakeItem(client, item)
	if (type(item) == "Entity") then
		local char = client:getChar()
		
		if (item.fusionSteamID and item.fusionSteamID == client:SteamID() and item.fusionCharID != char:getID()) then
			client:Notify("You cant pick this up.")

			return false
		end
	end
end

for k,v in pairs(weapons.GetList()) do
	print(v.ClassName, v.WorldModel)
end