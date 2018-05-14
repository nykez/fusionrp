Fusion.orgs = Fusion.orgs or {}
Fusion.orgs.cache = Fusion.orgs.cache or {}

netstream.Hook("fusion_createorg", function(pPlayer, tableData)
    Fusion.orgs.Create(pPlayer, tableData)
end)

netstream.Hook("fusion_flushinvites", function(pPlayer)
    Fusion.orgs.FlushInvites(pPlayer)
end)

netstream.Hook("fusion_orgkick", function(pPlayer)
    Fusion.orgs.FlushInvites(pPlayer)
end)

netstream.Hook("fusion_invite", function(pPlayer, character, strRank)
    Fusion.orgs.InvitePlayer(pPlayer, character, strRank)
end)

netstream.Hook("fusion_cinvite", function(pPlayer, id)
    Fusion.orgs.CancelInvite(pPlayer, id)
end)

netstream.Hook("fusion_createrank", function(pPlayer, strRank, tblFlags)
    local org = pPlayer:OrgObject()

    if not org then return end 

    local character = pPlayer:getChar()

    org:CreateRank(character, strRank, tblFlags)
end)

netstream.Hook("fusion_editrank", function(pPlayer, strRank, tblFlags)
    local org = pPlayer:OrgObject()

    if not org then return end 

    local character = pPlayer:getChar()

    org:EditRank(character, strRank, tblFlags)
end)

netstream.Hook("fusion_deletrank", function(pPlayer, strRank)
    local org = pPlayer:OrgObject()

    if not org then return end 

    local character = pPlayer:getChar()

    org:DeletRank(character, strRank)
end)

netstream.Hook("fusion_setmotd", function(pPlayer, strText)
    local org = pPlayer:OrgObject()

    local char = pPlayer:getChar()

    if !org:HasPermissions(char, "m") then
        pPlayer:Notify("You don't have permisisons to do this.")
        return
    end

    org:setData("motd", strText)

    pPlayer:Notify("Message of the day updated.")
end)

function Fusion.orgs.CancelInvite(pPlayer, id)
    local org = pPlayer:OrgObject()

    local char = pPlayer:getChar()

    if !org:HasPermissions(char, "f") then
        pPlayer:Notify("You don't have permisisons to do this.")
        return
    end

    local invites = org:getData("invites")

    if !invites and !invites[id] then
        pPlayer:Notify("Invite doesn't exist")
        return 
    end

    invites[id] = nil

    org:setData("invites", invites)

    pPlayer:Notify("Invite to player has been canceled.")
end

function Fusion.orgs.FlushInvites(pPlayer)
    local org = pPlayer:OrgObject()

    local char = pPlayer:getChar()

    if !org:HasPermissions(char, "f") then
        pPlayer:Notify("You don't have permisisons to do this.")
        return
    end

    pPlayer:Notify("All org invites have been flushed.")

    org:setData("invites", {})
end

function Fusion.orgs.DoInvite(pPlayer, playerinvited, strName, char, id, rank)

    playerinvited:Notify("You have been invited to join " .. strName .. " by " .. char:getName() .. " as the rank of " .. rank .. "!")
    
    netstream.Start(playerinvited, "fusion_orginvite", strName, id)

    local invites = playerinvited:getChar():getData("invites") or {}
    invites[id] = {
        name = strName,
        invitedby = char:getName(),
        id = id,
        steamid = playerinvited:SteamID64(),
        rank = rank,
    }


    playerinvited:getChar():setData("invites", invites)
end

function Fusion.orgs.AcceptInvite(pPlayer, id, name)
    local char = pPlayer:getChar()

    local invites = char:getData("invites")

    if not invites[id] then return end
    
    invites = invites[id]

    if char:getOrg(false) then
        pPlayer:Notify("You must leave your current org first.")
        return
    end

    char:setOrg(id)

    local org = Fusion.orgs.cache[invites]
    if not org then return end 

    org:AddUser(pPlayer, invites.rank)

    pPlayer:Notify("You have joined the organization.")
end

function Fusion.orgs.InvitePlayer(pPlayer, character, strRank)

    local org = pPlayer:OrgObject()

    local char = pPlayer:getChar()

    if !org:HasPermissions(char, "i") then
        pPlayer:Notify("You don't have permisisons to do this.")
        return
    end

    local invited = nil
    for k,v in pairs(player.GetAll()) do
        if v == character then 
            invited = v
        end
    end

    if !invited then
        pPlayer:Notify("Can't find person to invite.")
        return
    end

    Fusion.orgs.DoInvite(pPlayer, invited, org:getName(), char, org:getID(), strRank)

    local invites = org:getData("invites")
    table.insert(invites, {
        name = invited:getChar():getName(),
        rank = strRank,
    })

    org:setData("invites", invites)

    pPlayer:Notify("Invite has been sent to the player.")
end


function Fusion.orgs.Create(pPlayer, tableData)
    local character = pPlayer:getChar()

    if character:getOrg(false) then 
        pPlayer:Notify("You must leave/disband your current org.")
        return 
    end 

    local members = {}
    members[pPlayer:SteamID()] = {name = character:getName(), rank = "owner"}

    local insertObj = mysql:Insert("fusion_orgs");
    insertObj:Insert("owner", character:getPlayer():SteamID());
    insertObj:Insert("owner_id", character.id);
    insertObj:Insert("name", tableData.name);
    insertObj:Insert("data", "[]");
    insertObj:Insert("members", util.TableToJSON(members));
    insertObj:Callback(function(result, status, orgID)
        if orgID then

            character:setOrg(orgID)

            Fusion.orgs.cache[orgID] = Fusion.orgs.New(tableData.name, "Your MOTD", members, 0, orgID)

            netstream.Start(nil, "Fusion_CreateOrg", orgID, tableData.name, members)

            pPlayer:Notify("You succesfully created your org.")

            character:Save()
        end
    end);
    insertObj:Execute();
end

function Fusion.orgs.Leave(pPlayer)
    if not pPlayer then return end

    local character = pPlayer:getChar() 

    if !character:getOrg()['id'] then 
        pPlayer:Notify("You're not in a org.")
        return 
    end 

    if character:getOrg()['rank'] == "owner" then
        // Disband the entire org //

        local data = character:getOrg()


        Fusion.orgs.cache[data.id] = nil
        character:setOrg(nil)

        local insertObj = mysql:Delete("fusion_orgs")
        insertObj:Where("id", data.id)
        insertObj:Execute();

        for k,v in pairs(player.GetAll()) do
            if v:getChar() then
                local ourChar = v:getChar()
                if ourChar:getOrg()["id"] and ourChar:getOrg()["id"] == data.id then
                    pPlayer:Notify("The owner has disbaned your org.")
                    ourChar:setOrg(nil)
                end
            end
        end

        pPlayer:Notify('Your org has been disbanded.')

    else
        character:setOrg(nil)

        pPlayer:Notify("You have left your org.")
    end
end



concommand.Add("org", function(pPlayer)
    local tableData = {}
    tableData.name = "Gang Shit Only"
    
    //Fusion.orgs.Create(pPlayer, tableData)
    


   local org = pPlayer:OrgObject()



  org:setData("money", 5000)

   -- org:CreateRank(pPlayer:getChar(), "Private", {"r", "c", "e"})

end)


hook.Add("PostGamemodeLoaded", "Fusion_LoadOrgs", function()
    timer.Simple(1, function()
        local queryObj = mysql:Select("fusion_orgs");
        queryObj:Callback(function(result, status, lastID)
            if (type(result) == "table" and #result > 0) then
                for k,v in pairs(result) do
                    if v.id then
                        local members = util.JSONToTable(v.members)
                        local data = util.JSONToTable(v.data)
                        Fusion.orgs.cache[v.id] = Fusion.orgs.New(v.name, "Your MOTD", members, 0, v.id, data)
                        netstream.Start(nil, "Fusion_CreateOrg", v.id, v.name, members, data)

                    end
                end
            end
        end)
        queryObj:Execute();
    end)
end)


// Check to make sure the players org still exists 
hook.Add("PlayerLoadedChar", "Fusion_CheckOrg", function(pPlayer, character, currentChar)
    local currentChar = pPlayer:getChar()
    if currentChar:getOrg(false)then
        local id = tonumber(currentChar:getOrg())

        if !Fusion.orgs.cache[id] then
            pPlayer:Notify("Your organization has been disbaned by its leader.")
            currentChar:setOrg(nil)

            currentChar:Save()
        end
    end

    timer.Simple(1, function()
        local queryObj = mysql:Select("fusion_orgs");
        queryObj:Callback(function(result, status, lastID)
            if (type(result) == "table" and #result > 0) then
                
                for k,v in pairs(result) do
                    if v.id then
                        local members = util.JSONToTable(v.members)
                        local data = util.JSONToTable(v.data)
                        netstream.Start(pPlayer, "Fusion_CreateOrg", v.id, v.name, members, data)
                    end
                end
            end
        end)
        queryObj:Execute();
    end)
end)
