
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

		pPlayer:SetNoDraw(true)
		pPlayer:SetNotSolid(true)
		pPlayer:Lock(true)

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

	Fusion.inventory.LoadPlayer(client)
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

