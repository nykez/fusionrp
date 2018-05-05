
local PANEL = {}

function PANEL:Init()

	self:SetWide(ScrW() * 0.3)
	self:SetTall(ScrH() * 0.6)
	self:Center()
	self:MakePopup()

	self:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0))

	self.navbar = self:Add("DPanel")
	self.navbar:Dock(TOP)
	self.navbar:SetTall(self:GetTall() * 0.1)
	self.navbar:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	self.navbar:Text("Select a vehicle to modify")

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
		purchase:SetText("Select")
		local color = Color(231, 76, 60)

		purchase:TDLib():Background(color):FadeHover()
		purchase:SetTextColor(color_white)
		purchase.unique = k
		purchase:On("DoClick", function(s)
			local menu = vgui.Create("FusionVehicleModify")
			menu:LoadCar(purchase.unique)
			self:Remove()
		end)
	end


end


vgui.Register("FusionVehicleModSelect", PANEL, "EditablePanel")



local PANEL = {}

function PANEL:SetID(ID)
	self.id = ID
end

function PANEL:UseColor(bool)
	print("using color")
	self.useColor = true
end

function PANEL:Close()
	if IsValid(self.vehicle) then
		self.vehicle:Remove()
	end

	self:Remove()
end

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.exit = self:Add("DButton")
	self.exit:SetSize(32, 32)
	self.exit:SetPos(self:GetWide() - 38, 2)
	self.exit:SetText('X')
	self.exit:TDLib():Background(Color(231, 76, 60)):FadeHover()
	self.exit:SetTextColor(color_white)
	self.exit:On('DoClick', function()
		if IsValid(self.vehicle) then
			self.vehicle:Remove()
		end
		isViewingCarModify = nil
		self:Remove()
	end)

	vPos = LocalPlayer():EyePos()
    vAng = LocalPlayer():GetAngles()
end

function PANEL:LoadCar(id)
	if not id then print("no car") return end
	local car = Fusion.vehicles:GetTable(id)

	self.ourID = id

	isViewingCarModify = true

	if IsValid(self.vehicle) then
		self.vehicle:Remove()
	end
	self.ourPaintColor = nil

	self.vehicle = ents.CreateClientProp()
    self.vehicle:SetModel(car.model)
    self.vehicle:SetPos(Fusion.vehicles.config.vehicle_pos)
    self.vehicle:SetAngles(Fusion.vehicles.config.vehicle_ang)
    self.vehicle:SetColor(Color(255, 255, 255))
    self.vehicle:Spawn()

	self.docker = self:Add("DPanel")
	self.docker:SetSize(self:GetWide()*0.2, self:GetTall()*0.4)
	self.docker:SetPos(5, self:GetTall()*0.58)
	self.docker:TDLib():Background(Color(34, 34, 34))

	self.navbar = self.docker:Add("DPanel")
	self.navbar:Dock(TOP)
	self.navbar:SetTall(self.docker:GetTall() * 0.07)
	self.navbar:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	self.navbar:Text("Color Picker")

	self.paint = self.docker:Add("DColorCombo")
	self.paint:Dock(FILL)
	self.paint:DockMargin(5, 5, 5, 5)


	local select = self.docker:Add("DButton")
	select:Dock(BOTTOM)
	select:DockMargin(5, 5, 5, 5)
	select:SetText("Select Color")
	select:SetTextColor(color_white)
	select:TDLib():Background(Color(50, 50, 50)):Outline(Color(24, 24, 24)):FadeHover()
	select:On('DoClick', function(s)
		self:UseColor(true)
	end)

	self.docker_right = self:Add("DScrollPanel")
	self.docker_right:SetSize(self:GetWide()*0.2, self:GetTall()*0.4)
	self.docker_right:SetPos(self:GetWide()*0.78, self:GetTall()*0.58)
	self.docker_right:TDLib():Background(Color(34, 34, 34))

	self.navbar = self.docker_right:Add("DPanel")
	self.navbar:Dock(TOP)
	self.navbar:SetTall(self.docker:GetTall() * 0.07)
	self.navbar:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	self.navbar:Text("Bodygroups")

	local bodygroups = self.vehicle:GetBodyGroups() 

	self.Bodygroups = {}
	self.data = {}

	for k,v in pairs(bodygroups) do
		if ( v.num <= 1 ) then continue end

		self.Bodygroups[k] = self.docker_right:Add("DComboBox")
		local pnl = self.Bodygroups[k]
		pnl:Dock(TOP)
		pnl:DockMargin(10, 5, 10, 0)
		pnl:SetValue(v.name)
		pnl:AddChoice("Default");
		pnl.Bodygroup = v.id
		for a, b in pairs (v.submodels) do
			pnl:AddChoice(b);
		end
		pnl.OnSelect = function(panel, index, value)
			pnl.SelectedLine = index-2

			local ourBodygroups = {}

	    	for k,v in pairs(self.Bodygroups) do
	    		if (!v.SelectedLine || !v.Bodygroup) then continue; end

	    		ourBodygroups[v.Bodygroup] = v.SelectedLine
	    	end

	    	for k,v in pairs(ourBodygroups) do
	    		self.vehicle:SetBodygroup(k, v)
	    	end

	    	self.data = ourBodygroups

	    	SortBodygroups()
		end
		function SortBodygroups()
	    	local ourBodygroups = {}

	    	for k,v in pairs(self.Bodygroups) do
	    		if (!v.SelectedLine || !v.Bodygroup) then continue; end

	    		ourBodygroups[v.Bodygroup] = v.SelectedLine
	    	end

	    	self.data = ourBodygroups

	    end
	end

	local finish = self.docker_right:Add("DButton")
	finish:Dock(TOP)
	finish:DockMargin(5, 5, 5, 5)
	finish:SetText("Finish Editting")
	finish:SetTextColor(color_white)
	finish:TDLib():Background(Color(50, 50, 50)):Outline(Color(24, 24, 24)):FadeHover()
	self.panel = self
	finish:On('DoClick', function(s)
		if (self.useColor == true) then
			print(self.ourPaintColor)
			netstream.Start("FusionVehicleModify", self.ourID, self.data, self.ourPaintColor)
			self:Remove()
		else
			netstream.Start("FusionVehicleModify", self.ourID, self.data)
			self:Remove()
		end
	end)

end

function PANEL:Think()
    if IsValid(self.vehicle) then
        local Sin = math.sin(CurTime() * 0.7) * 75

        self.vehicle:SetAngles(Angle(0, 90 + Sin, 0))
        self.vehicle:SetColor(self.paint:GetColor())
        self.ourPaintColor = self.paint:GetColor()
    end

end

hook.Add("CalcView", "ViewCarModify", function(ply, pos, angles, fov)
	if isViewingCarModify then
		local view = {}

        vPos = LerpVector(FrameTime() * 3, vPos, Fusion.vehicles.config.camera_pos)
        vAng = LerpAngle(FrameTime() * 3, vAng, Fusion.vehicles.config.camera_ang)

		view.origin = vPos
	   	view.angles = vAng
	   	view.fov = 75
	   	view.drawviewer = true

		return view
	end
end)


vgui.Register("FusionVehicleModify", PANEL, "EditablePanel")

