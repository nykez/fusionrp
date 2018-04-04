
net.Receive("Fusion.skills.sync", function()
	local type = net.ReadString()
	local amount = net.ReadInt(32)

	
	LocalPlayer().skills[type] = amount
end)