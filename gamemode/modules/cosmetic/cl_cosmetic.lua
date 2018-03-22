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
	if not IsValid( ply ) or not ply:Alive() then return end

	if not ply.cosmetic then return end

	local attach_id = ply:LookupAttachment( 'eyes' )
	if not attach_id then return end

	local attach = ply:GetAttachment( attach_id )

	if not attach then return end

	local data = ply.cosmetic

	for k,v in pairs(data) do
		local draw = Fusion.inventory:GetItem(v[1])

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
			local infoBone = ply:LookupBone('ValveBiped.Bip01_Head1')


			if (infoBone and infoBone > 0) then

				local bonePos, boneAng = ply:GetBonePosition(infoBone)

				if (plywep_class != class and infoModel and IsValid(infoModel)) then
					local Right 	= boneAng:Right()
					local Up 		= boneAng:Up()
					local Forward 	= boneAng:Forward()

					boneAng:RotateAroundAxis(Right, 0)
					boneAng:RotateAroundAxis(Up, 90)
					boneAng:RotateAroundAxis(Forward, 0)

					bonePos = bonePos + 5 * Right
					bonePos = bonePos + 5 * Forward
					bonePos = bonePos + 5 * Up

					infoModel:SetRenderOrigin(bonePos)
					infoModel:SetRenderAngles(boneAng)
					infoModel:DrawModel()
				end
			end
		end
	end


	if ply.draw then
		for k,v in pairs(ply.draw) do
			if not ply.cosmetic then return end
			
			if not ply.cosmetic[k] then
				print("removing ent")
				v:Remove()
			end
		end
	end

end
hook.Add( "PostPlayerDraw", "DrawName", DrawMe )


-- function GM:PostPlayerDraw(ply ) 
-- 	DrawMe(ply)
-- end

local function MyCalcView( ply, pos, angles, fov )
	local view = {}

	view.origin = pos-( angles:Forward()*100 )
	view.angles = angles
	view.fov = fov
	view.drawviewer = true

	return view
end

hook.Add( "CalcView", "MyCalcView", MyCalcView )