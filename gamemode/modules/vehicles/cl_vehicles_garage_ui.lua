local PANEL = {}

function PANEL:Init()

	self:SetWide(ScrW() * 0.5)
	self:SetTall(ScrH() * 0.6)
	self:Center()
	self:MakePopup()

	self:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0))

	self.navbar = self:Add("DPanel")
	self.navbar:Dock(TOP)
	self.navbar:SetTall(self:GetTall() * 0.1)
	self.navbar:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	self.navbar:Text("Vehicle Spawn")

	self.exit = self:Add("DButton")
	self.exit:SetSize(32, 32)
	self.exit:SetPos(self:GetWide() - 38, 2)
	self.exit:SetText('X')
	self.exit:TDLib():Background(Color(231, 76, 60)):FadeHover()
	self.exit:SetTextColor(color_white)
	self.exit:On('DoClick', function()
		self:Remove()
	end)

	self.container = self:Add("DScrollPanel")
	self.container:Dock(FILL)

	local vehicles = LocalPlayer():getChar():getVehicles({})

	for k,v in pairs(vehicles) do
		local ourVehicle = Fusion.vehicles:GetTable(k)
		if not ourVehicle then continue end
		
		local ourLicense = self.container:Add("DPanel")
		ourLicense:Dock(TOP)
		ourLicense:DockMargin(5, 5, 5, 0)
		ourLicense:SetTall(65)
		ourLicense:TDLib():Background(Color(40, 40, 40)):Outline(Color(65, 65, 65))
		:SideBlock(Color(math.random(0, 255),math.random(0, 255),math.random(0, 255)), 4, LEFT)
		:DualText(ourVehicle.make .." " ..ourVehicle.name, nil, color_white, "", nil, Color(100, 100, 100))
		:FadeHover()

		local model = ourLicense:Add("DModelPanel")
		model:Dock(LEFT)
		model:SetWide(130)
		model:DockMargin(5, 0, 0, 0)
		model:SetModel(ourVehicle.model)
		local mn, mx = model.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

		model:SetFOV( 70 )
		model:SetCamPos( Vector( size, size, size ) )
		model:SetLookAt( ( mn + mx ) * 0.5 )

		local purchase = ourLicense:Add("DButton")
		purchase:Dock(RIGHT)
		purchase:DockMargin(0, 10, 5, 10)
		purchase:SetText("Spawn")
		local color = Color(231, 76, 60)

		purchase:TDLib():Background(color):FadeHover()
		purchase:SetTextColor(color_white)
		purchase.unique = k
		purchase:On("DoClick", function(s)
			netstream.Start("FusionVehicleSpawn", purchase.unique)

			self:Remove()
			Fusion.vehicles.panel:Remove()
			Fusion.vehicles.panel = nil 
		end)
	end

end

vgui.Register("FusionGarage", PANEL, "EditablePanel")