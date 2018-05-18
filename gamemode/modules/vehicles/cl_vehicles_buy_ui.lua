local PANEL = {}

surface.CreateFont("Fusion_Dealer_Title", {
    font = "Bebas Neue",
    size = ScreenScale(13),
    weight = 500,
    antialias = true
})

surface.CreateFont("Fusion_Dealer_Button", {
    font = "GeosansLight",
    size = ScreenScale(8),
    weight = 400,
    antialias = true
})

hook.Add("InitPostEntity", "Fusion.SetAnglesCD", function()
    local vPos = LocalPlayer():EyePos()
    local vAng = LocalPlayer():GetAngles()
end)

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.selected = nil
    self.vehicle = nil

    vPos = LocalPlayer():EyePos()
    vAng = LocalPlayer():GetAngles()

    self.details = self:Add("DPanel")
    self.details:SetSize(ScrW() * .156, ScrH() * .555)
    self.details:SetPos(-self.details:GetWide(), ScrH() - self.details:GetTall())
    self.details:TDLib():Background(Color(30, 30, 30))
    self.details:MoveTo(0, ScrH() - self.details:GetTall(), 0.4, 0, 0.2, function() end)

    self.title = self.details:Add("DLabel")
    self.title:SetFont("Fusion_Dealer_Title")
    self.title:SetText("Vehicle Dealership")
    self.title:SetTextColor(color_white)
    self.title:SetContentAlignment(5)
    self.title:SizeToContents()
    self.title:Dock(TOP)
    self.title:DockMargin(5, 7, 5, 0)

    self.panel = self.details:Add("DScrollPanel")
    self.panel:Dock(FILL)
    self.panel:DockMargin(5, 8, 5, 5)
    self.panel:TDLib():Background(Color(20, 20, 20))
    self.panel:HideVBar()

    self:Load()
end

function PANEL:Load()
    if !Fusion.vehicles.make or !Fusion.vehicles.cache then
        self:Remove()
        return
    end

    isViewingCar = true

    if IsValid(self.vehicle) then
        self.vehicle:Remove()
        self.vehicle = nil
    end

    self.cat = {}

    self.title:SetText("Vehicle Dealership")

    for k, v in SortedPairs(Fusion.vehicles.make) do
        self.cat[k] = self.panel:Add("DButton")
        self.cat[k]:TDLib():ClearPaint()
        self.cat[k]:SetTall(ScrH() * .027)
        self.cat[k]:Dock(TOP)
        self.cat[k]:DockMargin(5, 5, 5, 0)
        self.cat[k]:Background(Color(30, 30, 30)):BarHover(Color(64, 160, 255))
        self.cat[k]:Text(k, "Fusion_Dealer_Button")
        self.cat[k].category = v
        self.cat[k]:On("DoClick", function(s)
            self.details:MoveTo(-self.details:GetWide(), ScrH() - self.details:GetTall(), 0.4, 0, 0.2, function()
                self:ShowCategory(s.category, k)

                self.details:MoveTo(0, ScrH() - self.details:GetTall(), 0.4, 0, 0.2, function() end)
            end)
        end)
    end
end

function PANEL:ShowCategory(tbl, name)
    self.veh = {}

    self.title:SetText(name)

    for k, v in pairs(self.cat) do
        v:Remove()
    end

    self.back = self.details:Add("DButton")
    self.back:TDLib():ClearPaint()
    self.back:SetTall(ScrH() * .021)
    self.back:Dock(BOTTOM)
    self.back:DockMargin(5, 0, 5, 5)
    self.back:Background(Color(37, 37, 37)):FadeHover(Color(44, 44, 44))
    self.back:Text("Back", "Fusion_Dealer_Button")
    self.back:On("DoClick", function(s)
        if IsValid(self.cust) then
            self.cust:MoveTo(ScrW(), ScrH() - self.cust:GetTall(), 0.4, 0, 0.2, function()
                self.cust:Remove()
            end)
        end

        if IsValid(self.confirm) then
            self.confirm:MoveTo(ScrW() / 2 - self.confirm:GetWide() / 2, ScrH(), 0.4, 0, 0.2, function()
                self.confirm:Remove()
            end)
        end

        self.details:MoveTo(-self.details:GetWide(), ScrH() - self.details:GetTall(), 0.4, 0, 0.2, function()
            for k, v in pairs(self.veh) do
                v:Remove()
            end

            s:Remove()

            self:Load()

            self.details:MoveTo(0, ScrH() - self.details:GetTall(), 0.4, 0, 0.2, function() end)
        end)
    end)

    for k, v in pairs(tbl) do
        //if (LocalPlayer():HasVehicle(v.id)) then continue end
        self.veh[k] = self.panel:Add("DButton")
        self.veh[k]:TDLib():ClearPaint()
        self.veh[k]:SetTall(ScrH() * .027)
        self.veh[k]:Dock(TOP)
        self.veh[k]:DockMargin(5, 5, 5, 0)
        self.veh[k]:Background(Color(30, 30, 30)):FadeHover(Color(37, 37, 37))
        self.veh[k]:Text(v.name, "Fusion_Dealer_Button")
        self.veh[k].vehicle = v
        self.veh[k]:On("DoClick", function(s)
            self.selected = v
            self:MakeVehicle(self.selected)
            self:ShowCustomization()
            self:ShowBuy(s.vehicle.price)
        end)
    end
end

function PANEL:ShowCustomization()
    if IsValid(self.cust) then
        self.cust:Remove()
    end

    self.cust = self:Add("DPanel")
    self.cust:TDLib():ClearPaint()
    self.cust:SetSize(ScrW() * .156, ScrH() * .277)
    self.cust:SetPos(ScrW(), ScrH() - self.cust:GetTall())
    self.cust:Background(Color(30, 30, 30))
    self.cust:MoveTo(ScrW() - self.cust:GetWide(), ScrH() - self.cust:GetTall(), 0.4, 0, 0.2, function() end)
    self.cust.bodygroups = {}

    self.c_title = self.cust:Add("DLabel")
    self.c_title:Dock(TOP)
    self.c_title:DockMargin(5, 5, 5, 0)
    self.c_title:SetFont("Fusion_Dealer_Title")
    self.c_title:SetText("Customization")
    self.c_title:SetTextColor(color_white)
    self.c_title:SizeToContents()

    self.c_panel = self.cust:Add("DScrollPanel")
    self.c_panel:TDLib():ClearPaint()
    self.c_panel:Dock(FILL)
    self.c_panel:DockMargin(5, 5, 5, 5)
    self.c_panel:Background(Color(20, 20, 20))
    self.c_panel:HideVBar()

    self.paint = self.c_panel:Add("DColorMixer")
    self.paint:Dock(TOP)
    self.paint:DockMargin(5, 5, 5, 5)
    self.paint:SetAlphaBar(false)
    self.paint:SetColor(Color(255, 255, 255))

    /*
    if IsValid(self.vehicle) then
        local bodygroups = self.vehicle:GetBodyGroups()

        self.bodybuttons = {}

        for k, v in pairs(bodygroups) do
            if v.num <= 1 then continue end

            self.bodybuttons[k] = self.c_panel:Add("DComboBox")
            self.bodybuttons[k]:Dock(TOP)
            self.bodybuttons[k]:DockMargin(5, 5, 5, 0)
            self.bodybuttons[k]:SetValue(v.name)
            self.bodybuttons[k]:AddChoice("Default")
            self.bodybuttons[k].bg = v.id

            for a, b in pairs(v.submodels) do
                self.bodybuttons[k]:AddChoice(b)
            end

            self.bodybuttons[k].OnSelect = function(panel, index, value)
                self.bodybuttons[k].selected = index - 2

                local ourBodygroups = {}

                for k, v in pairs(self.bodybuttons) do
                    if !v.selected or !v.bg then continue end

                    ourBodygroups[v.bg] = v.selected
                end

                for k, v in pairs(ourBodygroups) do
                    self.vehicle:SetBodygroup(k, v)
                end

                self.cust.bodygroups = ourBodygroups
            end
        end
    end
    */
end

function PANEL:ShowBuy(price)
    if IsValid(self.confirm) then
        self.confirm:Remove()
    end

    self.confirm = self:Add("DPanel")
    self.confirm:SetSize(ScrW() * .078, ScrH() * .069)
    self.confirm:SetPos(ScrW() / 2 - self.confirm:GetWide() / 2, ScrH())
    self.confirm:TDLib():ClearPaint():Background(Color(30, 30, 30))
    self.confirm:MoveTo(ScrW() / 2 - self.confirm:GetWide() / 2, ScrH() - self.confirm:GetTall(), 0.4, 0, 0.2, function() end)

    self.buy = self.confirm:Add("DButton")
    self.buy:Dock(FILL)
    self.buy:DockMargin(5, 5, 5, 5)
    self.buy:SetText("")
    self.buy:TDLib():ClearPaint():Background(Color(20, 20, 20)):FadeHover(Color(25, 25, 25))
    self.buy.color = Color(80, 255, 80)

    if LocalPlayer():getChar():getMoney() < price then
        self.buy.color = Color(255, 80, 80)
        self.buy:SetEnabled(false)
    end

    self.buy:DualText("Purchase", "Fusion_Dealer_Title", Color(255, 255, 255), "$" .. price, "Fusion_Dealer_Button", self.buy.color, TEXT_ALIGN_CENTER)
    self.buy:On("DoClick", function(s)
        local color = Color(255, 255, 255)
        if IsValid(self.paint) then
            color = self.paint:GetColor()
        end

        netstream.Start("FusionVehicleSync", self.selected.id, color, "buy")

        self:Close()
    end)
end

function PANEL:MakeVehicle(tbl)
    if !Fusion.vehicles.cache[tbl.id] then return end
    if !isViewingCar then return end

    if IsValid(self.vehicle) then
        self.vehicle:Remove()
        self.vehicle = nil
    end

    self.vehicle = ents.CreateClientProp()
    self.vehicle:SetModel(tbl.model)
    self.vehicle:SetPos(Fusion.vehicles.config.vehicle_pos)
    self.vehicle:SetAngles(Fusion.vehicles.config.vehicle_ang)
    self.vehicle:SetColor(Color(255, 255, 255))
    self.vehicle:Spawn()
end

hook.Add("CalcView", "ViewCarView", function(ply, pos, angles, fov)
	if isViewingCar then
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

function PANEL:Clear()
    for k, v in pairs(self.cat) do
        v:Remove()
    end

    self.cat = {}
end

function PANEL:Think()
    if IsValid(self.vehicle) then
        local Sin = math.sin(CurTime() * 0.7) * 75
       // vAngle = Angle(0, 45 + Sin, 0)
        self.vehicle:SetAngles(Angle(0, 90 + Sin, 0))
        self.vehicle:SetColor(self.paint:GetColor())
    end

	if (input.IsKeyDown(KEY_F1)) then
		self:Close()
	end
end

function PANEL:Close()
    self:Remove()
    Fusion.vehicles.panel = nil
    isViewingCar = nil

    if IsValid(self.vehicle) then
        self.vehicle:Remove()
        self.vehicle = nil
    end
end

vgui.Register("FusionVehicles", PANEL, "EditablePanel")
