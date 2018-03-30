

Fusion.menu = Fusion.menu or {}
Fusion.menu.items = Fusion.menu.items or {}


function Fusion.menu:Add(tblData)
	Fusion.menu.items[tblData.name] = {
		tblData
	}
end

function Fusion.menu:Get()
	return self.items
end

function Fusion.menu:GetByID(id)
	return self.items[id] or false
end


local PANEL = {}


function PANEL:Init()
	self:SetSize(ScrW(), ScrH())

	self:Center()

	self:MakePopup()

	self:TDLib():Background(Color(32, 32, 32, 210)):Gradient(Color(35, 35, 35, 255))

	self.PanelsBuilt = {}
	self.Active = nil

	self.container = self:Add("DScrollPanel")
	self.container:Dock(LEFT)
	self.container:DockMargin(0, 1, 0, 0)
	self.container:SetWide(300)
	self.container:TDLib():Background(Color(40, 40, 40))

	self.cache_container_w = self.container:GetWide()


	local data = Fusion.menu:Get()

	self.buttons = {}
	for k,v in pairs(data) do
		self.buttons[k] = self.container:Add('DButton')
		self.buttons[k]:Dock(TOP)
		self.buttons[k]:SetText(k)
		self.buttons[k]:DockMargin(5, 3, 5, 0)
		self.buttons[k]:TDLib():Background(Color(35, 35, 35))
		self.buttons[k]:SetTall(80)
		self.buttons[k]:On("DoClick", function()
			self:BuildPanel(k, v[1].panel)
		end)
	end

	self.closebutton = self.container:Add('DButton')
	self.closebutton:Dock(TOP)
	self.closebutton:SetText("Close")
	self.closebutton:DockMargin(5, 20, 5, 0)
	self.closebutton:TDLib():Background(Color(35, 35, 35))
	self.closebutton:SetTall(60)
end

function PANEL:HidePanels()
	for k,v in pairs(self.buttons) do
		v:SetVisible(false)
	end

	self.closebutton:SetVisible(false)

	self.container:SizeTo(1, self.container:GetTall(), 0.3, 0, 4, function()
		self.container:SetVisible(false)
	end)
end

function PANEL:ShowPanels()
	if self.Active then
		self.Active:SetVisible(false)
	end

	self.backbtn:SetVisible(false)

	for k,v in pairs(self.buttons) do
		v:SetVisible(true)
	end

	self.closebutton:SetVisible(true)

	self.container:SetVisible(true)

	self.container:SizeTo(self.cache_container_w, self.container:GetTall(), 0.3, 0, 4, function()

	end)
end

function PANEL:CreateButton()
	if self.backbtn then
		self.backbtn:SetVisible(true)
		self.backbtn:MoveToFront()
		return
	end

	self.backbtn = self:Add('DButton')
	self.backbtn:SetSize(130, 25)
	self.backbtn:SetPos(1, 1)
	self.backbtn:MoveToFront()
	self.backbtn:SetText("<--")
	self.backbtn:TDLib():On('DoClick', function()
		self:ShowPanels()
	end)
end

function PANEL:BuildPanel(ID, panel)
	self:HidePanels()

	if self.Active then
		self.Active:SetVisible(false)
	end

	if self.PanelsBuilt[ID] then
		self.PanelsBuilt[ID]:SetVisible(true)
		self.backbtn:SetVisible(true)
		return
	end

	self.PanelsBuilt[ID] = self:Add(panel)

	self.Active = self.PanelsBuilt[ID]


	self:CreateButton()
end


function PANEL:Think()
	if (input.IsKeyDown(KEY_F1)) then
		self:Remove()
	end
end

vgui.Register("FusionMenu", PANEL, "EditablePanel")

local data = {name = "Skills", panel = "FusionInventory"}
Fusion.menu:Add(data)

local data = {name = "Organization", panel = "FusionInventory"}
Fusion.menu:Add(data)

local data = {name = "Settings", panel = "FusionInventory"}
Fusion.menu:Add(data)