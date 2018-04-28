if not CLIENT then return end

Fusion.cosmetic = Fusion.cosmetic or {}

net.Receive('fusion.net.cosmetic', function()
	local data = net.ReadTable()

	if not data then return end

	Fusion.cosmetic:Process(LocalPlayer(), data)
end)


function Fusion.cosmetic:Process(pPlayer, tblData)
	if not IsValid(pPlayer) then return end

	pPlayer.cosmetic = tblData
end

local function DrawMe(ply)
	if not IsValid( ply ) then return end

	if not ply.cosmetic then return end


	for k,v in pairs(ply.cosmetic) do
		local draw = Fusion.inventory:GetItem(v[1])

		local ourData = draw.data
		if not ourData then return end

		local class = k

		if (draw) then
			ply.drawcos = ply.drawcos or {}

			if (!ply.drawcos[class] or !IsValid(ply.drawcos[class])) then
				ply.drawcos[class] = ClientsideModel(draw.model, RENDERGROUP_TRANSLUCENT)
				if ply.drawcos[class] then
					ply.drawcos[class]:SetNoDraw(true)
				end
			end


			local infoModel = ply.drawcos[class]
			local infoBone = ply:LookupBone(ourData.bone)


			if (infoBone and infoBone > 0) then

				local bonePos, boneAng = ply:GetBonePosition(infoBone)

				if (plywep_class != class and infoModel and IsValid(infoModel)) then
					local Right 	= boneAng:Right()
					local Up 		= boneAng:Up()
					local Forward 	= boneAng:Forward()

					boneAng:RotateAroundAxis(Right, ourData.ang[1])
					boneAng:RotateAroundAxis(Up, ourData.ang[2])
					boneAng:RotateAroundAxis(Forward, ourData.ang[3])

					bonePos = bonePos + ourData.pos[1] * Right
					bonePos = bonePos + ourData.pos[2] * Forward
					bonePos = bonePos + ourData.pos[3] * Up

					infoModel:SetRenderOrigin(bonePos)
					infoModel:SetRenderAngles(boneAng)
					infoModel:DrawModel()
				end
			end
		end
	end

	if ply.drawcos then
		for k,v in pairs(ply.drawcos) do
			if not ply.cosmetic then return end

			if not ply.cosmetic[k] then
				print("removing ent")
				ply.drawcos[k] = nil
				v:Remove()
			end
		end
	end

end
hook.Add( "PostPlayerDraw", "DrawName", DrawMe )
