local PANEL = {}

surface.CreateFont("Fusion_Dealer_Title", {
    font = "Bebas Neue",
    size = 48,
    weight = 500,
    antialias = true
})

surface.CreateFont("Fusion_Dealer_Button", {
    font = "Bebas Neue",
    size = 30,
    weight = 500,
    antialias = true
})

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.details = self:Add("DPanel")
    self.details:SetSize(ScrW() * .156, ScrH() * .555)
    self.details:SetPos(-self.details:GetWide(), ScrH() - self.details:GetTall())
    self.details:TDLib():Background(Color(30, 30, 30))
    self.details:MoveTo(0, ScrH() - self.details:GetTall(), 0.4, 0, 0.2, function() end)

    self.title = self.details:Add("DLabel")
    self.title:SetFont("Fusion_Dealer_Title")
    self.title:SetText("Vehicle Dealership")
    self.title:SetTextColor(color_white)
    self.title:SizeToContents()
    self.title:Dock(TOP)
    self.title:DockMargin(5, 5, 5, 0)

    self.panel = self.details:Add("DScrollPanel")
    self.panel:Dock(FILL)
    self.panel:DockMargin(5, 8, 5, 5)
    self.panel:TDLib():Background(Color(20, 20, 20))
    self.panel:HideVBar()

    self.selected = nil

    self:Load()
end

function PANEL:Load()
    if !Fusion.vehicles.make or !Fusion.vehicles.cache then
        self:Remove()
        return
    end

    self.cat = {}

    self.title:SetText("Vehicle Dealership")

    for k, v in pairs(Fusion.vehicles.make) do
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
        self.veh[k] = self.panel:Add("DButton")
        self.veh[k]:TDLib():ClearPaint()
        self.veh[k]:SetTall(ScrH() * .027)
        self.veh[k]:Dock(TOP)
        self.veh[k]:DockMargin(5, 5, 5, 0)
        self.veh[k]:Background(Color(30, 30, 30)):FadeHover(Color(37, 37, 37))
        self.veh[k]:Text(v.name, "Fusion_Dealer_Button")
        self.veh[k].vehicle = v
        self.veh[k]:On("DoClick", function(s)

        end)
    end
end

//setpos -3693.711426 -1038.656372 193.258728;setang 24.879337 33.847637 0.000000

function PANEL:Clear()
    for k, v in pairs(self.cat) do
        v:Remove()
    end

    self.cat = {}
end

function PANEL:Think()
	if (input.IsKeyDown(KEY_F1)) then
		self:Remove()
		Fusion.vehicles.panel = nil
	end
end

vgui.Register("FusionVehicles", PANEL, "EditablePanel")

local function open()
    if Fusion.vehicles.panel then
        Fusion.vehicles.panel:Remove()
        Fusion.vehicles.panel = nil
    end

    Fusion.vehicles.panel = vgui.Create("FusionVehicles")
end
concommand.Add("cars", function() open() end)
