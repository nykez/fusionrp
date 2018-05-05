
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
	self.navbar:Text("License Registration")

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

	local data = Fusion.license.GetAll()

	for k,v in pairs(data) do

		local ourLicense = self.container:Add("DPanel")
		ourLicense:Dock(TOP)
		ourLicense:DockMargin(5, 5, 5, 0)
		ourLicense:SetTall(65)
		ourLicense:TDLib():Background(Color(40, 40, 40)):Outline(Color(65, 65, 65))
		:SideBlock(Color(math.random(0, 255),math.random(0, 255),math.random(0, 255)), 4, LEFT)
		:DualText(v.name, nil, color_white, v.desc, nil, Color(100, 100, 100))
		:FadeHover()

		if v.mat then
			local ourMaterial = ourLicense:Add("DPanel")
			ourMaterial:Dock(LEFT)
			ourMaterial:DockMargin(6, 0, 0, 0)
			ourMaterial:TDLib():Background(Color(50, 50, 50)):Material(v.mat)
		end

		local purchase = ourLicense:Add("DButton")
		purchase:Dock(RIGHT)
		purchase:DockMargin(0, 10, 5, 10)
		purchase:SetText("Purchase")
		local color = Color(231, 76, 60)
		local owner = LocalPlayer()
		local char = owner:getChar()
		if char:hasMoney(v.price) then
			color = Color(46, 204, 113)
		end
		purchase:TDLib():Background(color):FadeHover()
		purchase:SetTextColor(color_white)
		purchase.unique = v.unique
		purchase:On("DoClick", function(s)
			if !char:hasMoney(v.price) then return end
			netstream.Start("license_purchase", purchase.unique)

			self:Remove()
			Fusion.license.gui:Remove()
			Fusion.license.gui = nil 
		end)
	end

end

vgui.Register("FusionLicense", PANEL, "EditablePanel")
