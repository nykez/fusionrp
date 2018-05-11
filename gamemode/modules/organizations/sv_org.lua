Fusion.orgs = Fusion.orgs or {}
Fusion.orgs.cache = Fusion.orgs.cache or {}

netstream.Hook("fusion_createorg", function(pPlayer, tableData)
    Fusion.orgs.Create(pPlayer, tableData)
end)



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

    PrintTable(Fusion.orgs.cache)
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

   PrintTable(org)

   -- PrintTable(org:getMembers())

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
                        Fusion.orgs.cache[v.id] = Fusion.orgs.New(v.name, "Your MOTD", members, 0, v.id)
                        netstream.Start(nil, "Fusion_CreateOrg", v.id, v.name, members)
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

    for k,v in pairs(Fusion.orgs.cache) do
        netstream.Start(pPlayer, "Fusion_CreateOrg", v.id, v.name, v.members)
    end
end)


concommand.Add("getcurrentorg", function(pPlayer)
    local char = pPlayer:getChar()

    print(char:getOrg())
    

    PrintTable(Fusion.orgs.cache[tonumber(char:getOrg())])

end)