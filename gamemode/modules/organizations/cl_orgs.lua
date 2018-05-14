
if not CLIENT then return end 

netstream.Hook("Fusion_CreateOrg", function(orgID, name, members)
	Fusion.orgs.cache[orgID] = Fusion.orgs.New(name, "Your MOTD", members, 0, orgID)
end)

netstream.Hook("Fusion_DestoryOrg", function(id)
	Fusion.orgs.cache[id] = nil
end)

netstream.Hook("Fusion_CreateOrgWhole", function(id, tbl)
	Fusion.orgs.cache[id] = tbl
end)

netstream.Hook("Fusion_UpdateOrg", function(id, index, value)
	local org = Fusion.orgs.cache[id]
	if (!org) then return end 

	org:setData(index, value)
end)

netstream.Hook("fusion_orginvite", function(name, id)

end)


local dashboard = Material("gui/org/dash.png", "noclamp smooth")
local users = Material("gui/org/users.png", "noclamp smooth")
local chat = Material("gui/org/chat.png", "noclamp smooth")
local manage = Material("gui/org/manage.png", "noclamp smooth")

Fusion.OrgChat = Fusion.OrgChat or {}

local PANEL = {}

local function GetPotentialPlayers(id)
	local players = {}
	for k,v in pairs(player.GetAll()) do
		if v:getChar():getOrg() == id then continue end 
		table.insert(players, v)
	end

	return players
end

function PANEL:Init()

	self:SetWide(ScrW() * 0.5)
	self:SetTall(ScrH() * 0.6)
	self:Center()
	self:MakePopup()

	self:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0))

	local org = LocalPlayer():OrgObject()

	self.org = org


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
	Sheet.Button:On('Paint', function(s)
		if self.ActiveButton == s then
			s:SideBlock()
		end
	end)


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

function PANEL:BuildInvitePanel()
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( 500, 500 )
	frame:Center()
	frame:MakePopup()
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame:TDLib():Background(Color(24, 24, 24)):Outline(Color(54, 54, 54))


	local exit = vgui.Create("DButton", frame)
	exit:SetSize(32, 32)
	exit:SetPos(frame:GetWide() - 38, 2)
	exit:SetText('X')
	exit:TDLib():Background(Color(231, 76, 60)):FadeHover()
	exit:SetTextColor(color_white)
	exit:On('DoClick', function()
		frame:Close()
	end)

	local players = GetPotentialPlayers(self.org:getID())


	local AppList = vgui.Create( "DScrollPanel", frame)
	AppList:Dock( FILL )
	AppList:DockMargin(1, 5, 1, 5)

	for k,v in pairs(players) do
		local ourPlayer = AppList:Add("DPanel")
		ourPlayer.player = v
		ourPlayer:Dock(TOP)
		ourPlayer:DockMargin(5, 5, 5, 5)
		ourPlayer:TDLib():Background(Color(30, 30, 30)):Outline(Color(70, 70, 70)):FadeHover()
		:Text(v:getChar():getName())
		ourPlayer:SetTall(30)

		local invite = ourPlayer:Add('DButton')
		invite:Dock(RIGHT)
		invite:DockMargin(0, 2, 5, 2)
		invite:SetText("Invite")
		invite:SetTextColor(color_white)
		invite:TDLib():Background(Color(50, 50, 50)):Outline(Color(24, 24, 24))
		invite:On("DoClick", function()
			netstream.Start("fusion_invite", ourPlayer.player)
			frame:Close()
		end)

	end


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
	:DualText("Money", nil, color_white, "$".. string.Comma(org:getData("money")), nil, Color(100, 100, 100))

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
	motd_text:SetText(org:getData("motd") or "n/a")
	motd_text:SetAutoStretchVertical( true )
	motd_text:SetWrap(true)
	motd_text:SetFont("Fusion_Dealer_Button")

	self:AddSheet("Dashboard", panel, dashboard )

	// END DASHBOARD //

	// Start Members //
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

	local member_dock = panel:Add("DIconLayout")
	member_dock:Dock(FILL)
	member_dock:DockMargin(5, 5, 5, 0)
	member_dock:SetSpaceX(5)
	member_dock:SetSpaceY(5)

	local membertable = org:getMembers()

	for k,v in pairs(player.GetAll()) do
		if v:OrgObject() == org then
			membertable[v:SteamID()].online = true
		end
	end

	for k,v in pairs(org:getMembers()) do
		local mem = member_dock:Add('DPanel')
		mem:SetSize(200, 200)
		mem:TDLib():Background(Color(28, 28, 28)):Outline(Color(64, 64, 64)):FadeHover()
		mem.OnMousePressed = function( self )

			local url = "http://steamcommunity.com/profiles/"..util.SteamIDTo64(k)

			gui.OpenURL( url )

		end

		local av = vgui.Create( "AvatarImage", mem)
		av:SetSteamID(util.SteamIDTo64(k) , 400)
		av:Dock(TOP)
		av:DockMargin(5, 3, 5, 0)
		av:SetTall(mem:GetTall()*0.55)


		local name = mem:Add("DLabel")
		name:Dock(TOP)
		name:DockMargin(5, 5, 5, 0)
		name:SetText(v.name)
		name:SetFont("Fusion_Dealer_Title")
		name:SetContentAlignment(5)
		name:SetAutoStretchVertical(true)
		name:SetTextColor(color_white)

		local name = mem:Add("DLabel")
		name:Dock(TOP)
		name:DockMargin(5, 5, 5, 0)
		name:SetText(v.rank)
		name:SetFont("Fusion_Dealer_Button")
		name:SetContentAlignment(5)

		local text = "Offline"

		if v.online then
			text = "Online"
		end

		local name = mem:Add("DLabel")
		name:Dock(TOP)
		name:DockMargin(5, 5, 5, 0)
		name:SetText(text)
		name:SetFont("Fusion_Dealer_Button")
		name:SetContentAlignment(5)

	end

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

	local filler = panel:Add("DPanel")
	filler:Dock(FILL)
	filler:DockMargin(5, 5, 5, 5)
	filler:TDLib():Background(Color(30, 30, 30)):Outline(Color(64, 64, 64))

	local richtext = vgui.Create( "RichText", filler )
	richtext:Dock( FILL )

	for k,v in pairs(Fusion.OrgChat) do
		richtext:InsertColorChange( 255, 255, 255, 255 )
		richtext:AppendText(v[1].. ": " .. v[2] .. "\n")
	end
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
		local txt = entryBox:GetValue()
		local record = table.Count(Fusion.OrgChat)
		Fusion.OrgChat[record] = {LocalPlayer():getChar():getName(), txt}

		entryBox:SetText("")
		entryBox:Clear()
	end


	self:AddSheet("Dashboard", panel, chat )

	if !org:HasPermissions(LocalPlayer():getChar(), {'z', "i"}) then return end

	//

	local panel = self:Add('DPanel')
	panel:Dock(FILL)
	panel:DockMargin(0, 5, 5, 5)
	panel:TDLib():Background(Color(30, 30, 30)):Outline(Color(64, 64, 64))

	local sheet = vgui.Create( "DPropertySheet", panel)
	sheet:Dock( FILL )
	sheet:DockMargin(5, 5, 5, 5)

	local panel1 = vgui.Create( "DPanel", sheet )
	panel1:Dock(FILL)
	panel1:TDLib():Background(Color(30, 30, 30)):Outline(Color(65, 65, 65))

	local newInvite = panel1:Add("DIconLayout")
	newInvite:Dock(TOP)
	newInvite:DockMargin(5, 5, 5, 0)
	newInvite:SetTall(40)
	newInvite:SetSpaceX(5)

	local invite = newInvite:Add("DButton")
	invite:SetSize(100, 25)
	invite:SetText("Invite")
	invite:TDLib():Background(Color(46, 204, 113)):Outline(Color(0, 0, 0, 200)):FadeHover()
	invite:SetTextColor(color_white)
	invite:On('DoClick', function(s)
		self:BuildInvitePanel()
	end)

	local cinvite = newInvite:Add("DButton")
	cinvite:SetSize(100, 25)
	cinvite:SetText("Flush Invites")
	cinvite:TDLib():Background(Color(230, 126, 34)):Outline(Color(0, 0, 0, 200)):FadeHover()
	cinvite:SetTextColor(color_white)
	cinvite:On('DoClick', function(s)
		Derma_Query("Are you sure you want to flush all invites?", "", "Yes", function() 
			netstream.Start("fusion_flushinvites")
			self:Remove()
		end, "No")
	end)

	//

	local ccinvite = newInvite:Add("DButton")
	ccinvite:SetSize(100, 25)
	ccinvite:SetText("Kick Player")
	ccinvite:TDLib():Background(Color(231, 76, 60)):Outline(Color(0, 0, 0, 200)):FadeHover()
	ccinvite:SetTextColor(color_white)

	local curInvites = org:getData("invites")

	if table.Count(curInvites) <= 0 then
		local motd_text = panel1:Add("DLabel")
		motd_text:Dock(TOP)
		motd_text:DockMargin(5, 5, 5, 0)
		motd_text:SetText("No pending invites")
		motd_text:SetAutoStretchVertical( true )
		motd_text:SetWrap(true)
		motd_text:SetFont("Fusion_Dealer_Button")
	end
	for k,v in pairs(curInvites) do
		local ourInvite = panel1:Add("DPanel")
		ourInvite:Dock(TOP)
		ourInvite:DockMargin(5, 5, 5, 0)
		ourInvite:SetTall(35)
		ourInvite.id = k
		ourInvite:TDLib():Background(Color(34, 34, 34)):Outline(Color(64, 64, 64)):Text(v.name)
		:SideBlock(Color(0, 255, 0))

		local cancel_invite = ourInvite:Add('DButton')
		cancel_invite:Dock(RIGHT)
		cancel_invite:DockMargin(0, 5, 5, 5)
		cancel_invite:SetText("Cancel")
		cancel_invite:SetTextColor(color_white)
		cancel_invite:TDLib():Background(Color(231, 76, 60)):Outline(Color(0, 0, 0, 200)):FadeHover()
		cancel_invite:On("DoClick", function()
			netstream.Start("fusion_cinvite", ourInvite.id)
			self:Remove()
		end)

	end


	sheet:AddSheet( "Invites", panel1)

	local panel1 = vgui.Create( "DPanel", sheet )
	panel1:Dock(FILL)
	panel1:TDLib():Background(Color(30, 30, 30)):Outline(Color(65, 65, 65))

	local ourMotd = panel1:Add('DTextEntry')
	ourMotd:Dock(TOP)
	ourMotd:SetTall(self:GetTall() * 0.30)
	ourMotd:DockMargin(5, 5, 5, 0)
	ourMotd:SetText(org:getData("motd"))
	ourMotd:SetMultiline(true)

	local confirm = panel1:Add('DButton')
	confirm:Dock(BOTTOM)
	confirm:DockMargin(5, 5, 5, 5)
	confirm:SetText('Confirm')
	confirm:SetTextColor(color_white)
	confirm:TDLib():Background(Color(46, 204, 113)):Outline(Color(0, 0, 0, 255)):FadeHover()
	confirm:On("DoClick", function(s)
		netstream.Start("fusion_setmotd", ourMotd:GetValue())
	end)

	sheet:AddSheet( "MOTD", panel1)


	self:AddSheet("Dashboard", panel, manage )
end



vgui.Register("FusionOrgs", PANEL, "EditablePanel")

concommand.Add("myorg", function()
	vgui.Create("FusionOrgs")
end)