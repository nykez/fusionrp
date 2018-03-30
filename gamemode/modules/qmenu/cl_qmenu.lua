

Fusion.menu = Fusion.menu or {}
Fusion.menu.items = Fusion.menu.items or {}


function Fusion.menu:Add(tblData)
	Fusion.menu.items[tblData.name] = {
		tblData
	}

	if tblData.icon then
		tblData.icon[1] = Material(tblData.icon[2], "noclamp smooth")
		print("Created icon for main menu.")
		print(tblData.icon[1], tblData.icon[2])
	end
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

	self.mycontainer = self:Add("DScrollPanel")
	self.mycontainer:Dock(LEFT)
	self.mycontainer:DockMargin(0, 1, 0, 0)
	self.mycontainer:SetWide(307)
	self.mycontainer:TDLib():Background(Color(40, 40, 40))

	self.container = self.mycontainer:Add("DIconLayout")
	self.container:Dock(FILL)
	self.container:TDLib():Background(Color(40, 40, 40))
	self.container:SetSpaceY( 2 )
	self.container:SetSpaceX( 2 )

	self.cache_container_w = self.mycontainer:GetWide()


	local data = Fusion.menu:Get()

	PrintTable(data)

	self.buttons = {}
	for k,v in pairs(data) do
		self.buttons[k] = self.container:Add('DButton')
		self.buttons[k].alpha = 255
		self.buttons[k]:SetText(" ")
		self.buttons[k]:DockMargin(7, 3, 5, 0)
		self.buttons[k]:TDLib()
		self.buttons[k]:SetSize(150, 120)
		self.buttons[k]:On("DoClick", function()
			self:BuildPanel(k, v[1].panel)
		end)
		self.buttons[k]:On("Paint", function(s)
			if not v[1].icon then return end

			surface.SetDrawColor(Color(35, 35, 35))
			surface.DrawRect(0, 0, s:GetWide(), s:GetTall())

			surface.SetDrawColor(255, 255, 255, s.alpha)
			surface.SetMaterial(v[1].icon[1])
			surface.DrawTexturedRect(s:GetWide()*0.7-64, s:GetTall()*0.7-64, 64, 64)

		end)
		self.buttons[k]:On("OnCursorEntered", function(s)
			s.alpha = 170
		end)
		self.buttons[k]:On("OnCursorExited", function(s)
			s.alpha = 255
		end)
	end

	-- self.closebutton = self.container:Add('DButton')
	-- self.closebutton:SetText("Close")
	-- self.closebutton:TDLib():Background(Color(35, 35, 35))
	-- self.closebutton:DockMargin(0, 10, 0, 0)
	-- self.closebutton:SetSize(self.cache_container_w, 25)
end

function PANEL:HidePanels()
	for k,v in pairs(self.buttons) do
		v:SetVisible(false)
	end

	-- self.closebutton:SetVisible(false)

	self.mycontainer:SizeTo(1, self.container:GetTall(), 0.3, 0, 4, function()
		self.mycontainer:SetVisible(false)
	end)
end

function PANEL:ShowPanels()
	if self.Active then
		self.Active:SetVisible(false)
	end

	self.backbtn:SetVisible(false)


	-- self.closebutton:SetVisible(true)

	self.mycontainer:SetVisible(true)

	self.mycontainer:SizeTo(self.cache_container_w, self.container:GetTall(), 0.3, 0, 4, function()
		for k,v in pairs(self.buttons) do
			v:SetVisible(true)
		end
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
	if self.Active then
		self.Active:SetVisible(false)
	end
	
	self:HidePanels()

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

local data = {name = "Organization", panel = "FusionInventory", icon = {inventorypng, "gui/gang.png" }}
Fusion.menu:Add(data)

local data = {name = "Settings", panel = "FusionInventory", icon = {inventorypng, "gui/settings.png" }}
Fusion.menu:Add(data)


hook.Add( "OnSpawnMenuOpen", "SpawnMenuWhitelist", function()
	if IsValid(mainmenu) then
		mainmenu:SetVisible(true)
		return
	end

	mainmenu = vgui.Create("FusionMenu")
end )

hook.Add( "OnSpawnMenuClose", "SpawnMenuWhitelist", function()
	if IsValid(mainmenu) then
		mainmenu:SetVisible(false)
	else
		mainmenu = nil
	end
end )

concommand.Add("refreshmenu", function()
	mainmenu = nil
end)