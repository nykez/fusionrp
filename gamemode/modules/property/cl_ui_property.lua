
local PANEL = {}


function PANEL:Init()

	self:SetWide(ScrW())
	self:SetTall(ScrH())


	self:MakePopup()
	self:Center()

	self.list = self:Add("DPanel")
	self.list:SetSize(self:GetWide() * 0.2, self:GetTall())
	self.list:TDLib():Background(Color(32, 32, 32)):Outline(Color(16, 16, 16))
	self.list:On('Paint', function(s)
		draw.DrawText( "Realtor Office", "Fusion_Dialog_Title", 5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
	end)

	self.bottom = self:Add("DPanel")
	self.bottom:Dock(BOTTOM)
	self.bottom:DockMargin(self.list:GetWide(), 0, 0, 0)
	self.bottom:SetTall(80)
	self.bottom:TDLib():Background(Color(32, 32, 32)):Outline(Color(16, 16, 16))

	self.items = self.list:Add("DScrollPanel")
	self.items:Dock(FILL)


	self:Load()
end

function PANEL:Load()
	PrintTable(Fusion.property.cache)
end

function PANEL:Think()
	if (input.IsKeyDown(KEY_F1)) then
		self:Remove()
	end

end
////


vgui.Register("FusionProperty", PANEL, "EditablePanel")


concommand.Add("property", function()

	if property then
		property:Remove()
	end

	property = vgui.Create("FusionProperty")
end)