
if not CLIENT then return end 

netstream.Hook("Fusion_CreateOrg", function(orgID, name, members)
	Fusion.orgs.cache[orgID] = Fusion.orgs.New(name, "Your MOTD", members, 0, orgID)
end)

netstream.Hook("Fusion_DestoryOrg", function(id)
	Fusion.orgs.cache[id] = nil
end)


netstream.Hook("Fusion_UpdateOrg", function(id, index, value)
	local org = Fusion.orgs.cache[id]
	if (!org) then return end 

	org:setData(index, value)
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

	local org = LocalPlayer():OrgObject()


	self.navbar = self:Add("DPanel")
	self.navbar:Dock(TOP)
	self.navbar:SetTall(self:GetTall() * 0.07)
	self.navbar:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	self.navbar:Text(org:getName() or "nil")

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

	self:BuildTabs(org)
end

function PANEL:Think()
	if input.IsKeyDown(KEY_F1) then
		self:Remove()
	end
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

function PANEL:BuildTabs(org)

	local panel = self:Add('DPanel')
	panel:Dock(FILL)
	panel:DockMargin(0, 5, 5, 5)
	panel:TDLib():Background(Color(30, 30, 30)):Outline(Color(64, 64, 64))

	local docker_top = panel:Add("DIconLayout")
	docker_top:Dock(TOP)
	docker_top:DockMargin(50, 5, 50, 0)
	docker_top:SetTall(100)
	docker_top:SetSpaceX(5)

	local members = docker_top:Add('DPanel')
	members:SetSize(205, 100)
	members:TDLib():Background(Color(35, 35, 35)):Outline(Color(72, 72, 72))
	:DualText("Members", nil, color_white, table.Count(org:getMembers()), nil, Color(100, 100, 100))

	local members = docker_top:Add('DPanel')
	members:SetSize(205, 100)
	members:TDLib():Background(Color(35, 35, 35)):Outline(Color(72, 72, 72))
	:DualText("Money", nil, color_white, org:getData("money"), nil, Color(100, 100, 100))

	local members = docker_top:Add('DPanel')
	members:SetSize(205, 100)
	members:TDLib():Background(Color(35, 35, 35)):Outline(Color(72, 72, 72))
	:DualText("Level", nil, color_white, "0", nil, Color(100, 100, 100))

	local motd = panel:Add("DPanel")
	motd:Dock(TOP)
	motd:DockMargin(5, 5, 5, 0)
	motd:SetTall(40)
	motd:TDLib():Background(Color(34, 34, 34)):Outline(Color(64, 64, 64))
	:Text("Message of the Day")

	local motd_text = panel:Add("DLabel")
	motd_text:Dock(TOP)
	motd_text:DockMargin(5, 5, 5, 0)
	motd_text:SetText("Welcome to the org. We got a few fucking rules around here to follow. So listen up.\n\nDon't minge.\nDon't raid fellow org mates")
	motd_text:SetAutoStretchVertical( true )
	motd_text:SetWrap(true)
	motd_text:SetFont("Fusion_Dealer_Button")

	self:AddSheet("Dashboard", panel, dashboard )

	// END DASHBOARD //

	// Start users //
	local panel = self:Add('DPanel')
	panel:Dock(FILL)
	panel:DockMargin(0, 5, 5, 5)
	panel:TDLib():Background(Color(30, 30, 30)):Outline(Color(64, 64, 64))

	local members = panel:Add("DPanel")
	members:Dock(TOP)
	members:DockMargin(5, 5, 5, 0)
	members:SetTall(40)
	members:TDLib():Background(Color(34, 34, 34)):Outline(Color(64, 64, 64))
	:Text("Members List")

	self:AddSheet("Dashboard", panel, users )

	local panel = self:Add('DPanel')
	panel:Dock(FILL)
	panel:DockMargin(0, 5, 5, 5)
	panel:TDLib():Background(Color(30, 30, 30)):Outline(Color(64, 64, 64))

	local members = panel:Add("DPanel")
	members:Dock(TOP)
	members:DockMargin(5, 5, 5, 0)
	members:SetTall(40)
	members:TDLib():Background(Color(34, 34, 34)):Outline(Color(64, 64, 64))
	:Text("Chat")

	local filler = panel:Add("DPanel")
	filler:Dock(FILL)
	filler:DockMargin(5, 5, 5, 5)
	filler:TDLib():Background(Color(30, 30, 30)):Outline(Color(64, 64, 64))

	local richtext = vgui.Create( "RichText", filler )
	richtext:Dock( FILL )

	local textBox = filler:Add("DPanel")
	textBox:Dock(BOTTOM)
	textBox:SetTall(self:GetTall() * 0.1)
	textBox:TDLib():Background(Color(30, 30, 30)):Outline(Color(64, 64, 64))

	local sendBtn = textBox:Add("DButton")
	sendBtn:Dock(LEFT)
	sendBtn:DockMargin(5, 5, 5, 5)
	sendBtn:SetText("SEND")
	sendBtn:SetTextColor(color_white)
	sendBtn:TDLib():Background(Color(30, 30, 30)):Outline(Color(64, 64, 64)):FadeHover()

	local entryBox = textBox:Add('DTextEntry')
	entryBox:Dock(FILL)
	entryBox:DockMargin(1, 5, 5, 5)
	entryBox:TDLib():Background(Color(30, 30, 30)):Outline(Color(64, 64, 64)):ReadyTextbox():BarHover()
	entryBox:SetTextColor(color_white)
	entryBox:SetHighlightColor(color_white)
	entryBox.OnEnter = function()
		richtext:InsertColorChange( 255, 255, 255, 255 )
		richtext:AppendText(LocalPlayer():getChar():getName()..": " ..entryBox:GetValue().."\n")
		entryBox:SetText("")
		entryBox:Clear()
	end


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