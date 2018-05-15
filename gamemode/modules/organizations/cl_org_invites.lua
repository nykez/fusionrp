

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
	self.navbar:Text("Current Invites ")

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

	local data = LocalPlayer():getChar():getData("invites", {})

	PrintTable(data)
	for k,v in pairs(data) do

		local ourLicense = self.container:Add("DPanel")
		ourLicense:Dock(TOP)
		ourLicense:DockMargin(5, 5, 5, 0)
		ourLicense:SetTall(65)
		ourLicense:TDLib():Background(Color(40, 40, 40)):Outline(Color(65, 65, 65))
		:SideBlock(Color(math.random(0, 255),math.random(0, 255),math.random(0, 255)), 4, LEFT)
		:DualText(v.name, nil, color_white, "Invited by "..v.invitedby, nil, Color(100, 100, 100))
		:FadeHover()


		local purchase = ourLicense:Add("DButton")
		purchase:Dock(RIGHT)
		purchase:DockMargin(0, 15, 5, 15)
		purchase:SetText("Deny")
		local color = Color(231, 76, 60)
		purchase:TDLib():Background(color):FadeHover()
		purchase:SetTextColor(color_white)
		purchase.unique = k
		purchase:On("DoClick", function(s)
			netstream.Start("fusion_invitecmd", "d", s.unique)
			self:Remove()
		end)

		local purchase2 = ourLicense:Add("DButton")
		purchase2:Dock(RIGHT)
		purchase2:DockMargin(0, 15, 7, 15)
		purchase2:SetText("Accept")
		local color = Color(46, 204, 113)
		purchase2:TDLib():Background(color):FadeHover()
		purchase2:SetTextColor(color_white)
		purchase2.unique = k
		purchase2:On("DoClick", function(s)
			netstream.Start("fusion_invitecmd", "a", s.unique)
			self:Remove()
		end)
	end

end

vgui.Register("FusionOrgInvites", PANEL, "EditablePanel")