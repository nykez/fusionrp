/* A huge list of console commands to help our poor asses out during development */

concommand.Add("fusion_printvars", function(ply, cmd, args)
    print(ply:GetFirstName())
end)
