
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
	self.navbar:Text("Vehicle Insurance")

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

	local data = LocalPlayer():getChar():getVehicles()

	for k,v in SortedPairsByMemberValue(data, "bill") do
		if !v.bill then continue end

		local car = Fusion.vehicles:GetTable(k)

		if v.bill < os.time() then
			local ourLicense = self.container:Add("DPanel")
			ourLicense:Dock(TOP)
			ourLicense:DockMargin(5, 5, 5, 0)
			ourLicense:SetTall(65)
			ourLicense:TDLib():Background(Color(40, 40, 40)):Outline(Color(65, 65, 65))
			:SideBlock(Color(math.random(0, 255),math.random(0, 255),math.random(0, 255)), 4, LEFT)
			:DualText(car.make .. " " .. car.name, nil, color_white, "$"..math.Round(car.price * 0.1), nil, Color(100, 100, 100))
			:FadeHover()
			ourLicense.id = k

			local purchase = ourLicense:Add("DButton")
			purchase:Dock(RIGHT)
			purchase:DockMargin(0, 10, 5, 10)
			purchase:SetText("Pay Bill")
			local color = Color(231, 76, 60)
			purchase:TDLib():Background(color):FadeHover()
			purchase:SetTextColor(color_white)
			purchase.unique = v.unique
			purchase:On("DoClick", function(s)
				self:Remove()
				Fusion.license.gui:Remove()
				Fusion.license.gui = nil

				netstream.Start("FusionVehicleInsurance", ourLicense.id)
			end)
		else
			local ourLicense = self.container:Add("DPanel")
			ourLicense:Dock(TOP)
			ourLicense:DockMargin(5, 5, 5, 0)
			ourLicense:SetTall(65)
			print(v.bill)
			local due =  math.Round( ( (v.bill - os.time()) / 60 ) / 60 )
			ourLicense:TDLib():Background(Color(40, 40, 40)):Outline(Color(65, 65, 65))
			:SideBlock(Color(math.random(0, 255),math.random(0, 255),math.random(0, 255)), 4, LEFT)
			:DualText(car.make .. " " .. car.name, nil, color_white, "Payment due in " ..due .. "hours", nil, Color(100, 100, 100))
			:FadeHover()
		end


	end

end

vgui.Register("FusionInsurance", PANEL, "EditablePanel")
