net.Receive("Fusion.vehicles.sync",function()
	local tbl = net.ReadTable()

	if tbl then
		LocalPlayer().vehicles = tbl
	end
end)
