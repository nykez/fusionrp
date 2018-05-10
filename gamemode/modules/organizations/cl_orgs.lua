
netstream.Hook("Fusion_UpdateOrgs", function(id, data)
	print("updating orgs")
	Fusion.orgs.cache[id] = data

	PrintTable(Fusion.orgs.cache)
end)


local dashboard = Material("gui/org/dash.png", "noclamp smooth")
local users = Material("gui/org/users.png", "noclamp smooth")
local chat = Material("gui/org/chat.png", "noclamp smooth")
local manage = Material("gui/org/manage.png", "noclamp smooth")


local PANEL = {}

function PANEL:Init()
	self:SetWide(ScrW() * 0.5)
	self:SetTall(ScrH() * 0.6)
	self:Center()
	self:MakePopup()

	self:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0))

	self.navbar = self:Add("DPanel")
	self.navbar:Dock(TOP)
	self.navbar:SetTall(self:GetTall() * 0.07)
	self.navbar:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	self.navbar:Text("Organization")

	self.exit = self:Add("DButton")
	self.exit:SetSize(32, 32)
	self.exit:SetPos(self:GetWide() - 38, 2)
	self.exit:SetText('X')
	self.exit:TDLib():Background(Color(231, 76, 60)):FadeHover()
	self.exit:SetTextColor(color_white)
	self.exit:On('DoClick', function()
		self:Remove()
	end)

	self.Navigation = vgui.Create( "DScrollPanel", self )
	self.Navigation:Dock( LEFT )
	self.Navigation:SetWidth( 32 )
	self.Navigation:DockMargin( 10, 10, 10, 0 )

	self.Content = vgui.Create( "Panel", self )
	self.Content:Dock( FILL )

	self.Items = {}

	self:BuildTabs()
end

function PANEL:AddSheet( label, panel, material )

	if ( !IsValid( panel ) ) then return end

	local Sheet = {}


	if material then
		Sheet.Button = vgui.Create( "DButton", self.Navigation )
		Sheet.Button.Paint = function(s)
			surface.SetDrawColor(color_white)
			surface.SetMaterial(material)
			surface.DrawTexturedRect(0, 0, 32, 32)
		end
		Sheet.Button:SetText( " " )
	else
		Sheet.Button = vgui.Create( "DButton", self.Navigation )
		Sheet.Button:SetText( label )
	end

	Sheet.Button.Target = panel
	Sheet.Button:Dock( TOP )
	Sheet.Button:DockMargin( 0, 5, 0, 0 )
	Sheet.Button:SetTall(32)
	Sheet.Button:TDLib():FadeHover()

	Sheet.Button.DoClick = function()
		self:SetActiveButton( Sheet.Button )
	end

	Sheet.Panel = panel
	Sheet.Panel:SetParent( self.Content )
	Sheet.Panel:SetVisible( false )

	if ( self.ButtonOnly ) then
		Sheet.Button:SizeToContents()
		--Sheet.Button:SetColor( Color( 150, 150, 150, 100 ) )
	end

	table.insert( self.Items, Sheet )

	if ( !IsValid( self.ActiveButton ) ) then
		self:SetActiveButton( Sheet.Button )
	end

end

function PANEL:SetActiveButton( active )

	if ( self.ActiveButton == active ) then return end

	if ( self.ActiveButton && self.ActiveButton.Target ) then
		self.ActiveButton.Target:SetVisible( false )
		self.ActiveButton:SetSelected( false )
		self.ActiveButton:SetToggle( false )
		--self.ActiveButton:SetColor( Color( 150, 150, 150, 100 ) )
	end

	self.ActiveButton = active
	active.Target:SetVisible( true )
	active:SetSelected( true )
	active:SetToggle( true )
	--active:SetColor( Color( 255, 255, 255, 255 ) )

	self.Content:InvalidateLayout()

end

function PANEL:BuildTabs()

	local panel = self:Add('DPanel')
	panel:Dock(FILL)
	panel:DockMargin(0, 5, 5, 5)


	self:AddSheet("Dashboard", panel, dashboard )

	local panel = self:Add('DPanel')
	panel:Dock(FILL)
	panel:DockMargin(0, 5, 5, 5)


	self:AddSheet("Dashboard", panel, users )

	local panel = self:Add('DPanel')
	panel:Dock(FILL)
	panel:DockMargin(0, 5, 5, 5)


	self:AddSheet("Dashboard", panel, chat )

	local panel = self:Add('DPanel')
	panel:Dock(FILL)
	panel:DockMargin(0, 5, 5, 5)


	self:AddSheet("Dashboard", panel, manage )
end


vgui.Register("FusionOrgs", PANEL, "EditablePanel")

concommand.Add("myorg", function()
	vgui.Create("FusionOrgs")
end)