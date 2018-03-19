
local PANEL = {}


function PANEL:Init()

	self:SetWide(ScrW())
	self:SetTall(ScrH())


	self:MakePopup()
	self:Center()

	self.list = self:Add("DPanel")
	self.list:SetSize(self:GetWide() * 0.2, self:GetTall())
	self.list:TDLib():Background(Color(40, 40, 40)):Outline(Color(16, 16, 16)):Gradient(Color(28, 28, 28))
	self.list:On('Paint', function(s)
		draw.DrawText( "Realtor Office", "Fusion_Dialog_Title", 5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
	end)


	self.items = self.list:Add("DScrollPanel")
	self.items:Dock(FILL)
	self.items:DockMargin(5, 45, 5, 0)


	self:Load()
end

function PANEL:Load()
	local data = Fusion.property.cache
	if not data then return end
		
	self.buttons = {}
	self.cats = {}
	for k,v in pairs(data) do

		if !self.cats[v.category] then 
			self.cats[v.category] = self.items:Add("DCollapsibleCategory")
			self.cats[v.category]:Dock(TOP)
			self.cats[v.category]:SetLabel(" ")
			self.cats[v.category]:DockMargin(0, 0, 0, 5)
			self.cats[v.category].ourcat = v.category
			self.cats[v.category]:SetExpanded(false)
			self.cats[v.category].height = 0
			self.cats[v.category]:TDLib():Background(Color(54, 54, 54)):Text(v.category, "Fusion_Dialog_Title")
			self.cats[v.category]:SetTall(60)
		end

		self.buttons[k] = self.cats[v.category]:Add("DPanel")
		self.buttons[k]:Dock(TOP)
		self.buttons[k]:DockMargin(0, 20, 0, 0)
		self.buttons[k]:SetTall(60)
		self.buttons[k].cat = v.category
		self.buttons[k]:TDLib():Background(Color(54, 54, 54)):Text(v.name, "Fusion_Dialog_Title")
		:FadeHover(Color(44, 44, 44, 200))
		self.buttons[k]:SetVisible(false)
		self.cats[v.category]:SetContents(self.buttons[k])		
	end
end

function PANEL:Think()
	if (input.IsKeyDown(KEY_F1)) then
		self:Remove()
		property = nil
	end

end
////


vgui.Register("FusionProperty", PANEL, "EditablePanel")


concommand.Add("property", function()

	if property then
		property:Remove()
		property = nil
	end

	property = vgui.Create("FusionProperty")
end)