/* A huge list of console commands to help our poor asses out during development */

concommand.Add("fs_printvars", function(ply, cmd, args)
    print(ply:GetRPName())
end)

concommand.Add("fs_xp_add", function(ply, cmd, args)
    ply:AddXP(tonumber(args[1]))
    ply:ChatPrint(ply:GetLevel())
    ply:ChatPrint(ply:GetXP())
end)

concommand.Add("fs_xp_print", function(ply, cmd, args)
    for i = 1, 10 do
        ply:ChatPrint("Level: " .. i .. ", XP: " .. Fusion.XP:XPForLevel(i))
    end
end)

concommand.Add("fs_doorprint", function(ply, cmd, args)
    ply:ChatPrint(Fusion.property.cache[tonumber(args[1])].name)
end)
