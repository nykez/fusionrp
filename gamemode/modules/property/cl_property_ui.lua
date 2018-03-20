
surface.CreateFont("Fusion_Property_Title", {
	font = "Bebas Neue",
	size = 46,
	weight = 500,
	antialias = true
})

surface.CreateFont("Fusion_Property_Price", {
	font = "Bebas Neue",
	size = 28,
	weight = 500,
	antialias = true
})

local PANEL = {}


function PANEL:Init()

	self:SetWide(ScrW())
	self:SetTall(ScrH())

	self:ParentToHUD()

	self:MakePopup()
	self:Center()

	self.a_back = self:Add("DButton")
	self.a_back:SetSize(50, 50)
	self.a_back:SetPos(ScrW() / 2 - 50 / 2 - 5, 10)
	self.a_back:SetText("")
	self.a_back:TDLib():Background(Color(24, 24, 24, 255)):Text("<", "Fusion_Dialog_Title"):FadeHover(Color(37, 37, 37))
	self.a_back:SetVisible(false)
	self.a_back:On("DoClick", function(s)
		if self.selected and isViewing then
			if #self.selected.cams.pos == #self.selected.cams.ang then
				local len = #self.selected.cams.pos

				if isViewing[3] != 1 then
					isViewing[1] = self.selected.cams.pos[isViewing[3] - 1]
					isViewing[2] = self.selected.cams.ang[isViewing[3] - 1]
					isViewing[3] = isViewing[3] - 1
				else
					isViewing[1] = self.selected.cams.pos[len]
					isViewing[2] = self.selected.cams.ang[len]
					isViewing[3] = len
				end
			end
		end
	end)

	self.a_forward = self:Add("DButton")
	self.a_forward:SetSize(50, 50)
	self.a_forward:SetPos(ScrW() / 2 + 50 / 2 + 5, 10)
	self.a_forward:SetText("")
	self.a_forward:TDLib():Background(Color(24, 24, 24, 255)):Text(">", "Fusion_Dialog_Title"):FadeHover(Color(37, 37, 37))
	self.a_forward:SetVisible(false)
	self.a_forward:On("DoClick", function(s)
		if self.selected and isViewing then
			if #self.selected.cams.pos == #self.selected.cams.ang then
				local len = #self.selected.cams.pos

				if isViewing[3] != len then
					isViewing[1] = self.selected.cams.pos[isViewing[3] + 1]
					isViewing[2] = self.selected.cams.ang[isViewing[3] + 1]
					isViewing[3] = isViewing[3] + 1
				else
					isViewing[1] = self.selected.cams.pos[1]
					isViewing[2] = self.selected.cams.ang[1]
					isViewing[3] = 1
				end
			end
		end
	end)

	self.title = "Realtor Office"

	self.list = self:Add("DPanel")
	self.list:SetSize(self:GetWide() * 0.2, self:GetTall())
	self.list:TDLib():Background(Color(40, 40, 40)):Outline(Color(16, 16, 16)):Gradient(Color(28, 28, 28))
	self.list:On('Paint', function(s)
		draw.DrawText(self.title, "Fusion_Property_Title", 10, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
	end)

	self.list:SetPos(-self.list:GetWide(), 0)
	self.list:MoveTo(0, 0, 0.4, 0, 0.2, function() end)

	surface.SetFont("Fusion_Property_Title")
	local tX, tY = surface.GetTextSize(self.title)

	self.items = self.list:Add("DScrollPanel")
	self.items:Dock(FILL)
	self.items:DockMargin(8, tY + 20, 8, 0)

	self.back = self.list:Add("DButton")
	self.back:Dock(BOTTOM)
	self.back:DockMargin(5, 5, 5, 5)
	self.back:SetText("")
	self.back:TDLib():Background(Color(24, 24, 24)):Text("Back", "Fusion_Dialog_Title"):FadeHover(Color(37, 37, 37))
	self.back:SetTall(40)
	self.back:SetVisible(false)
	self.back:On("DoClick", function(s)
		self:Back()
	end)

	self.action = self.list:Add("DButton")
	self.action:Dock(BOTTOM)
	self.action:DockMargin(5, 5, 5, 0)
	self.action:SetText("")
	self.action:SetTall(40)
	self.action.text = "NULL"
	self.action.color = Color(255, 255, 255)
	self.action:TDLib():Background(Color(24, 24, 24)):Text(self.action.text, "Fusion_Dialog_Title", self.action.color):FadeHover(Color(37, 37, 37))
	self.action:SetVisible(false)
	self.action:On("DoClick", function(s)
		if self.selected then
			if Fusion.property.owners[self.selected.id] == LocalPlayer() then
				net.Start("Fusion.property.sell")
					net.WriteInt(self.selected.id, 16)
				net.SendToServer()
			else
				net.Start("Fusion.property.purchase")
					net.WriteInt(self.selected.id, 16)
				net.SendToServer()
			end

			self:Back()
		end
	end)
	self.action:On("Think", function(s)
		if self.selected and Fusion.property.owners[self.selected.id] == LocalPlayer() then
			self.action.text = "Sell" .. " ($" .. math.Round(self.selected.price / 2) .. ")"
			self.action.color = Color(255, 100, 100)
		else
			self.action.text = "Purchase" .. " ($" .. self.selected.price .. ")"
			self.action.color = Color(100, 255, 100)
		end

		self.action:Text(self.action.text, "Fusion_Dialog_Title", self.action.color)
	end)


	self:Load()
end

function PANEL:Back()
	self.list:MoveTo(-self.list:GetWide(), 0, 0.4, 0, 0.2, function()
		for k, v in pairs(self.cats) do
			v:Remove()
		end

		if self.props then
			for k, v in pairs(self.props) do
				v:Remove()
			end
		end

		self:Load()

		self.list:MoveTo(0, 0, 0.4, 0, 0.2, function() end)
	end)
end

function PANEL:Load()
	local data = Fusion.property.cache
	if not data then return end

	self.title = "Realtor Office"
	self.back:SetVisible(false)
	self.action:SetVisible(false)
	self.a_back:SetVisible(false)
	self.a_forward:SetVisible(false)

	isViewing = nil

	self.selected = nil

	self.cats = {}
	for k,v in pairs(data) do

		if !self.cats[v.category.id] then
			self.cats[v.category.id] = self.items:Add("DButton")
			self.cats[v.category.id]:Dock(TOP)
			self.cats[v.category.id]:SetText(v.category.name)
			self.cats[v.category.id]:DockMargin(0, 0, 0, 5)
			self.cats[v.category.id].ourcat = v.category
			self.cats[v.category.id]:TDLib():Background(Color(30, 30, 30)):Text(v.category.name, "Fusion_Dialog_Title"):BarHover(Color(64, 160, 255, 255), 3)
			self.cats[v.category.id]:SetTall(60)
			self.cats[v.category.id]:On("DoClick", function(s)
				self.list:MoveTo(-self.list:GetWide(), 0, 0.4, 0, 0.2, function()
					for k, v in pairs(self.cats) do
						v:Remove()
					end

					self:ShowCategory(v.category)

					self.list:MoveTo(0, 0, 0.4, 0, 0.2, function() end)
				end)
			end)
		end
	end
end

function PANEL:ShowCategory(cat)
	local data = Fusion.property.cache
	if not data then return end

	self.title = cat.name
	self.back:SetVisible(true)

	self.props = {}
	for k, v in pairs(data) do
		if v.category.id == cat.id then
			self.props[k] = self.items:Add("DButton")
			self.props[k]:Dock(TOP)
			self.props[k]:DockMargin(0, 0, 0, 5)
			self.props[k]:SetText("")
			self.props[k]:TDLib():Background(Color(24, 24, 24)):Text(v.name, "Fusion_Dialog_Title"):BarHover(Color(64, 160, 255, 255), 3)
			self.props[k]:SetTall(60)
			self.props[k].data = v
			self.props[k]:On("DoClick", function(s)
				self:SelectProperty(v)
			end)
			self.props[k]:On("Think", function(s)
				if self.selected and self.selected == s.data then
					s:Background(Color(30, 30, 30))
				else
					s:Background(Color(24, 24, 24))
				end

				if Fusion.property.owners[s.data.id] == LocalPlayer() then
					s:SideBlock(Color(100, 255, 100), 4)
				end
			end)
		end
	end
end

function PANEL:SelectProperty(property)
	if !Fusion.property.cache[property.id] then return end

	self.action:SetVisible(true)
	self.a_back:SetVisible(false)
	self.a_forward:SetVisible(false)

	self.selected = property
	self:TryView(property)
end

function PANEL:TryView(property)
	if !Fusion.property.cache[property.id] then return end

	if #property.cams.pos > 0 and #property.cams.ang > 0 then
		isViewing = nil
		isViewing = {}

		isViewing[1] = property.cams.pos[1]
		isViewing[2] = property.cams.ang[1]
		isViewing[3] = 1

		if #property.cams.pos > 1 and #property.cams.ang > 1 then
			self.a_back:SetVisible(true)
			self.a_forward:SetVisible(true)
		end
	end
end

hook.Add("CalcView", "PropertyView", function(ply, pos, angles, fov)
	if isViewing then
		local view = {}
		view.origin = isViewing[1]
	   	view.angles = isViewing[2]
	   	view.fov = 75
	   	view.drawviewer = true

		return view
	end
end)

function PANEL:Think()
	if (input.IsKeyDown(KEY_F1)) then
		isViewing = nil
		self:Remove()
		Fusion.property.panel = nil
	end
end

vgui.Register("FusionProperty", PANEL, "EditablePanel")


concommand.Add("property", function()

	if Fusion.property.panel then
		isViewing = nil
		Fusion.property.panel:Remove()
		Fusion.property.panel = nil
	end

	Fusion.property.panel = vgui.Create("FusionProperty")
end)
