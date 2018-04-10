
Fusion.perks = Fusion.perks or {}


local civil = Material("gui/bank.png", "noclamp smooth")
local business = Material("gui/graph.png", "noclamp smooth")
local gangster = Material("gui/suit.png", "noclamp smooth")

surface.CreateFont("Fusion_Perks_Main", {
	font = "Bebas Neue",
	extended = true,
	size = 36,
	weight = 400,
	antialias = true
})


local tbl = {
	{civil, "Civil Service"},
	{business, "Business"},
	{gangster, "Criminal"},
}

local PANEL = {}

function PANEL:Init()
	self:SetSize(ScrW()*0.6, ScrH()*0.6)

	self:Center()

	self:MakePopup()

	self:TDLib():Background(Color(34, 34, 34)):Gradient(Color(37, 37, 37)):Outline(Color(64, 64, 64, 255))

	self.list = self:Add("DIconLayout")
	self.list:Dock(FILL)
	self.list:SetSpaceX(5)
	self.list:DockMargin(5, 5, 0, 5)

	self.perks = {}

	self.count = 0;

	print()

	self:Build()
end

// self.perks[i]:TDLib():Material(tbl[i])
function PANEL:Build()
	for i=1, 3 do
		self.perks[i] = self.list:Add("DPanel")
		self.perks[i]:SetWide(self:GetWide() / 3-7)
		self.perks[i]:SetTall(self:GetTall()*0.98)
		self.perks[i]:TDLib():Background(Color(35, 35, 35)):Outline(Color(64, 64, 64))

		local image = self.perks[i]:Add("DPanel")
		image:Dock(TOP)
		image:SetTall(self.perks[i]:GetTall() * 0.4)
		image:DockMargin(5, 0, 5, 0)
		image.Paint = function()
			surface.SetDrawColor(Color(255, 255, 255, 125))
			surface.SetMaterial(tbl[i][1])
			surface.DrawTexturedRect(0, 0, image:GetWide(), image:GetTall())
		end

		local label = self.perks[i]:Add("DLabel")
		label:Dock(TOP)
		label:SetText(tbl[i][2])
		label:SetContentAlignment( 5 ) 
		label:SetFont("Fusion_Perks_Main")
		label:SetTall(50)
		label:SetTextColor(color_white)

	end

end

function PANEL:ReBuild()

end

function PANEL:Think()
	if (input.IsKeyDown(KEY_F1)) then
		self:Remove()
	end
end

vgui.Register("FusionPerks", PANEL, "EditablePanel")


concommand.Add("perks", function()

	if Fusion.property.panel then
		Fusion.property.panel:Remove()
		Fusion.property.panel = nil
	end

	Fusion.property.panel = vgui.Create("FusionPerks")
end)
