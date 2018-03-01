/* A huge list of console commands to help our poor asses out during development */

concommand.Add("fs_printvars", function(ply, cmd, args)
    print(ply:GetRPName())
end)

concommand.Add("fs_xp_add", function(ply, cmd, args)
    ply:AddXP(tonumber(args[1]))
    print(ply:GetLevel())
end)
