
surface.CreateFont( "SerialFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 128,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local plate_material = Material("gui/plate.png", "noclamp smooth")
local pwidth = 512
local pheight = 256


hook.Add("PostDrawTranslucentRenderables","FusionDrawPlates", function(sky, deep)

	if sky then return end
	if deep then return end

	render.SuppressEngineLighting( true )
	surface.SetMaterial( plate_material )
	surface.SetDrawColor(Color(255, 255, 255, 255))
	for k, v in ipairs(ents.FindByClass("prop_vehicle_*")) do
		if !v:IsVehicle() then continue end

		if (v:GetPos():Distance(LocalPlayer():GetPos()) > 1300) then continue end


		local id = v:getNetVar("id", false)

		if not id then continue end

		local data = Fusion.vehicles:GetTable(id)
		if not data then continue end 

		if not data.lplate then continue end 

		if v:getNetVar("license", false) then
			local strLicense = v:getNetVar("license", false)
			cam.Start3D2D( v:LocalToWorld( data.lplate.Vec ), v:LocalToWorldAngles( data.lplate.Ang ), 0.028)
				surface.DrawTexturedRect(-pwidth / 2 - 6, -pheight / 2 - 6, pwidth + 12, pheight + 12 )
				draw.SimpleText(strLicense, "SerialFont", 0, 0, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
			
		end
	end
	render.SuppressEngineLighting( false )
end)
