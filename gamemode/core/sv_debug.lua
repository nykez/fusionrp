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

concommand.Add("fs_b_a", function(ply, cmd, args)
    ply:AddBank(tonumber(args[1]))
end)

concommand.Add("fs_p_b", function(ply, cmd, args)
    Fusion.property:Purchase(ply, tonumber(args[1]))
end)

concommand.Add("fs_p_s", function(ply, cmd, args)
    Fusion.property:Sell(ply, tonumber(args[1]))
end)

concommand.Add("fs_save", function(ply, cmd, args)
	ply:SaveProfile()
end)

concommand.Add("fs_invprint", function(ply, cmd, args)
    PrintTable(ply:GetInventory())
end)

concommand.Add("fs_setteam", function(ply, cmd, args)
    Fusion.jobs:Join(ply, tonumber(args[1]))
end)

concommand.Add("fs_printteam", function(ply, cmd, args)
    ply:ChatPrint(Fusion.jobs:Get(ply:Team()).name)
end)

concommand.Add("fs_quitjob", function(ply, cmd, args)
    Fusion.jobs:Quit(ply)
end)

concommand.Add("fs_b_print", function(ply, cmd, args)
    ply:ChatPrint("Bank: " .. ply:GetBank())
end)
