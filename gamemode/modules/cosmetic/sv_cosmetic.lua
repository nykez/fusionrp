Fusion.cosmetic = Fusion.cosmetic or {}

util.AddNetworkString("fusion.net.cosmetic")



function Fusion.cosmetic:Sync(pPlayer)
	if not IsValid(pPlayer) then return end
	

	local data = pPlayer.cosmetic

	if not data then return end


	net.Start("fusion.net.cosmetic")
		net.WriteTable(data)
	net.Send(pPlayer)

	print('sync data')

	pPlayer:SetModel("models/Humans/Group01/Female_04.mdl")

end