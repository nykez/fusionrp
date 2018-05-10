Fusion.orgs = Fusion.orgs or {}
Fusion.orgs.cache = Fusion.orgs.cache or {}

netstream.Hook("fusion_createorg", function(pPlayer, tableData)
    Fusion.orgs.Create(pPlayer, tableData)
end)

netstream.Hook("fusion_addrank", function(pPlayer, tableData)

end)

function Fusion.orgs.Create(pPlayer, tableData)
    local character = pPlayer:getChar()

    if character:getOrg()['id'] then 
        pPlayer:Notify("You must leave/disband your current org.")
        return 
    end 

    local insertObj = mysql:Insert("fusion_orgs");
    insertObj:Insert("owner", character:getPlayer():SteamID64());
    insertObj:Insert("owner_id", character.id);
    insertObj:Insert("name", tableData.name);
    insertObj:Insert("data", "[]");
    insertObj:Callback(function(result, status, orgID)
        if orgID then
            local data = {}
            data.name = tableData.name
            data.id = orgID
            data.rank = "owner"

            character:setOrg(data)
            Fusion.orgs.cache[orgID] = tableData

            pPlayer:Notify("You succesfully created your org.")
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

function Fusion.orgs.NewRank(pPlayer, strName, tableData)
    local character = pPlayer:getChar()
    if not character then return end

    local org = Fusion.orgs.GetPlayerOrg(pPlayer)

    local rankName = tostring(strName)

    if !org then
        pPlayer:Notify("Umm... you're not in a org.")
        return
    end

    if !Fusion.orgs.HasPerms(character, "r") then
        pPlayer:Notify("You don't have the correct permissions to do this.")
        return
    end

    local data = Fusion.orgs.GetOrg(character:getOrg()["id"])
    if !data then return end

    if data.ranks then
        if data.ranks[rankName] then
            pPlayer:Notify("A rank already exists with that name!")
            return
        end

        data.ranks[rankName] = tableData

    else
        data.ranks = data.ranks or {}
        data.ranks[rankName] = tableData
    end 

    local updateObj = mysql:Update("fusion_orgs");
    updateObj:Update("data", util.TableToJSON(data.ranks))
    updateObj:Where("id", character:getOrg()["id"])
    updateObj:Execute();

    netstream.Start(nil, "Fusion_UpdateOrgs", character:getOrg()["id"], data)

    
    pPlayer:Notify("Your rank has been added.")

end

concommand.Add("org", function(pPlayer)
    local tableData = {}
    tableData.name = "My org"
    
    //Fusion.orgs.Create(pPlayer, tableData)
    
    //Fusion.orgs.Leave(pPlayer)

    Fusion.orgs.NewRank(pPlayer, "2nd Owner", {flags = {"r", "c"}})
end)


hook.Add("PostGamemodeLoaded", "Fusion_LoadOrgs", function()
    timer.Simple(1, function()
        local queryObj = mysql:Select("fusion_orgs");
        queryObj:Callback(function(result, status, lastID)
            if (type(result) == "table" and #result > 0) then
                
                for k,v in pairs(result) do
                    if v.id then
                        Fusion.orgs.cache[v.id] = {
                            data = util.JSONToTable(v.data),
                            name = v.name,
                        }
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
    if currentChar:getOrg() and currentChar:getOrg()['id'] then
        local id = currentChar:getOrg()['id']

        if !Fusion.orgs.cache[id] then
            pPlayer:Notify("Your organization has been disbaned by its leader.")
            currentChar:setOrg(nil)
        end
    end
end)