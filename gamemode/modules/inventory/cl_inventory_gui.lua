
surface.CreateFont( "Fusion_Label_Inventory", {
	font = "Bebas Neue",
	extended = true,
	size = 30,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "Fusion_Label_Inventory2", {
	font = "Arial",
	extended = true,
	size = 18,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "Fusion_Label_InventoryPages", {
	font = "Arial",
	extended = true,
	size = 14,
	weight = 300,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )



local PANEL = {}

function PANEL:Init()

	self:SetSize(ScrW(), ScrH())

	//self:MakePopup()
	self:Center()

	self:TDLib():Background(Color(32, 32, 32, 210)):Gradient(Color(35, 35, 35, 255))

	self:CreateModel()
	self:CreateWearables()
	self:CreateInventory()

	self:CreateWeapons()

	//self:CreateHUD()

	self:CreateInfoPanel()
	
	self:CreatePages()

	//self:CreateView()

	self.OnFocusChanged = function(bool)
		print(bool)
	end
end

function PANEL:CreateModel()
	self.modelpnl = self:Add("DModelPanel")
	self.modelpnl:SetSize(self:GetWide() * 0.3, self:GetTall() * 0.65 + 100)
	self.modelpnl:SetPos(5, self:GetTall() * 0.07)
	self.modelpnl:SetModel(LocalPlayer():GetModel())
	//self.modelpnl:SetAlpha(0)
	local mn, mx = self.modelpnl.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

	function self.modelpnl.LayoutEntity( ent )
		self.modelpnl.Entity:ResetSequence( self.modelpnl.Entity:LookupSequence("pose_standing_02") )
		self.modelpnl:RunAnimation()
		return
	end

	if LocalPlayer():getChar():getData("bodygroups", {}) then
		for k,v in pairs(LocalPlayer():getChar():getData("bodygroups", {})) do
			self.modelpnl.Entity:SetBodygroup(k, v)
		end
	end

	function self.modelpnl.PostDrawModel( ent )
		local ply = LocalPlayer()
		if not IsValid( ply ) then return end

		if not ply.cosmetic then return end


	for k,v in pairs(ply.cosmetic) do
		local draw = Fusion.inventory:GetItem(v[1])

		local ourData = draw.data
		if not ourData then return end

		local class = k

		if (draw) then
			ent.drawcos = ent.drawcos or {}

			if (!ent.drawcos[class] or !IsValid(ent.drawcos[class])) then
				ent.drawcos[class] = ClientsideModel(draw.model, RENDERGROUP_TRANSLUCENT)
				if ent.drawcos[class] then
					ent.drawcos[class]:SetNoDraw(true)
				end
			end


			local infoModel = ent.drawcos[class]
			local infoBone = self.modelpnl.Entity:LookupBone(ourData.bone)

			if (infoBone and infoBone > 0) then

				local bonePos, boneAng = self.modelpnl.Entity:GetBonePosition(infoBone)

				if (plywep_class != class and infoModel and IsValid(infoModel)) then
					local Right 	= boneAng:Right()
					local Up 		= boneAng:Up()
					local Forward 	= boneAng:Forward()

					boneAng:RotateAroundAxis(Right, ourData.ang[1])
					boneAng:RotateAroundAxis(Up, ourData.ang[2])
					boneAng:RotateAroundAxis(Forward, ourData.ang[3])

					bonePos = bonePos + ourData.pos[1] * Right
					bonePos = bonePos + ourData.pos[2] * Forward
					bonePos = bonePos + ourData.pos[3] * Up

					infoModel:SetRenderOrigin(bonePos)
					infoModel:SetRenderAngles(boneAng)
					infoModel:DrawModel()
				end
			end
		end
	end

	if ent.drawcos then
		for k,v in pairs(ent.drawcos) do
			if not ply.cosmetic then return end

			if not ply.cosmetic[k] then
				ent.drawcos[k] = nil
				v:Remove()
			end
		end
	end

	end

	self.modelpnl.Entity:SetAngles(Angle(-15, 40, 0))
	self.modelpnl:SetFOV( 32 )
	self.modelpnl:SetCamPos( Vector( size, size, size ) )
	self.modelpnl:SetLookAt( ( mn + mx ) * 0.5 )

end

function PANEL:CreateInventory()
	self.inventory_items = self:Add("DIconLayout")
	self.inventory_items:SetSize(self:GetWide() * 0.66, self:GetTall() * 0.55)
	self.inventory_items:SetPos(self.modelpnl:GetWide() + 10, self:GetTall() * 0.35)
	//self.inventory_items:Dock(FILL)
	self.inventory_items:SetSpaceX(5)
	self.inventory_items:SetSpaceY(5)
	self.inventory_items.items = {}

	local MAX_COUNTER = 55
	for i=1, 55 do
		self.inventory_items.items[i] = self.inventory_items:Add("DPanel")
		self.inventory_items.items[i]:SetSize(64 + 24, 64 + 24)
		self.inventory_items.items[i]:TDLib():Background(Color(24, 24, 24)):Outline(Color(54, 54, 54))
	end

	local data = Fusion.inventory:GetInventory(LocalPlayer())
	if not data then return end

	local count = 1	
	local items = {}
	for k,v in pairs(data) do
		local item = Fusion.inventory:GetItem(k)
		if not item then continue end 

		items[k] = self.inventory_items.items[count]:Add("DModelPanel")
		items[k]:SetModel(item.model)
		items[k]:Dock(FILL)
		items[k].quantity = v.quantity
		local mn, mx = items[k].Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

		items[k].Entity:SetAngles(Angle(-15, 40, 0))
		items[k]:SetFOV( 75 )
		items[k]:SetCamPos( Vector( size, size, size ) )
		items[k]:SetLookAt( ( mn + mx ) * 0.5 )

		items[k]:TDLib():On("Paint", function(s)
			draw.SimpleText("x"..items[k].quantity, "TargetID", 5, 5, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT)
		end)

		items[k]:On("OnMouseReleased", function(s)
			self:SetInfoModel(k, s, self.inventory_items)
		end)
		items[k]:Droppable('equipped')



		count = count + 1
	end
end

function PANEL:CreatePages()
	self.pages = self:Add("DIconLayout")
	self.pages:SetSize(self.inventory_items:GetWide(), 35)
	self.pages:SetPos(self.modelpnl:GetWide() + 10, self:GetTall() * 0.32)
	self.pages:SetSpaceX(5)
	self.pages:SetSpaceY(5)

	self.tabs = {}
	for i=1, 4 do 
		self.tabs[i] = self.pages:Add("DPanel")
		self.tabs[i]:SetSize(16, 16)
		self.tabs[i]:TDLib():Background(Color(70, 70, 70)):Outline(Color(24, 24, 24)):Text(i, "Fusion_Label_InventoryPages")
	end
end

function PANEL:CreateWearables()
	self.wearables = self:Add("DIconLayout")
	self.wearables:SetSize(self.modelpnl:GetWide(), self:GetTall() * 0.1)
	self.wearables:SetPos(10, self.modelpnl:GetTall() * 1.1)
	self.wearables:SetSpaceX(5)
	self.wearables:SetSpaceY(5)

	self.wearables.items = {}
	for i=1, 5 do
		self.wearables.items[i] = self.wearables:Add("DPanel")
		self.wearables.items[i]:SetSize(64 + 24, 64 + 24)
		self.wearables.items[i]:TDLib():Background(Color(24, 24, 24)):Outline(Color(54, 54, 54))
	end

	self.wearables.equips = {}
	if LocalPlayer().inventory and LocalPlayer().inventory.cosmetic then
		for k,v in pairs(LocalPlayer().inventory.cosmetic) do
			local data = Fusion.inventory:GetItem(v)
			if not data then continue end

			self.wearables.equips[k] = vgui.Create("DModelPanel", self.wearables.items[k])
			self.wearables.equips[k]:Dock(FILL)
			self.wearables.equips[k]:SetModel(data.model)

			local mn, mx = self.wearables.equips[k].Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

			-- local function self.OurWeapons[k]:LayoutEntity( ent )
			-- 	return
			-- end

			self.wearables.equips[k].Entity:SetAngles(Angle(-15, 40, 0))
			self.wearables.equips[k]:SetFOV( 45 )
			self.wearables.equips[k]:SetCamPos( Vector( size, size, size ) )
			self.wearables.equips[k]:SetLookAt( ( mn + mx ) * 0.5 )
			self.wearables.equips[k]:TDLib():On('OnMouseReleased', function(s)
				net.Start('Fusion.inventory.unequip')
					net.WriteString("cosmetic")
					net.WriteInt(k, 16)
				net.SendToServer()
				s:Remove()
				timer.Simple(0.2, function()
					self:RebuildInventory()
				end)
			end)
		end
	end
end

local MAX_WEAPON = 2
local MAX_MISC = 3
function PANEL:CreateWeapons()
	self.weapons = self:Add("DIconLayout")
	self.weapons:SetPos(self.modelpnl:GetWide() + 10, self.inventory_items:GetTall() * 1.6)
	self.weapons:SetSize(self.modelpnl:GetWide(), 64 + 24)
	self.weapons:SetSpaceX(5)
	self.weapons:SetSpaceY(5)

	self.weapons.items = {}
	self.weapons.misc = {}

	for i=1, MAX_WEAPON do
		self.weapons.items[i] = self.weapons:Add("DPanel")
		self.weapons.items[i]:SetSize(64 + 24, 64 + 24)
		self.weapons.items[i]:TDLib():Background(Color(24, 24, 24)):Outline(Color(52, 152, 219, 100))
		self.weapons.items[i]:Receiver( 'equipped', function( receiver, tableOfDroppedPanels, isDropped, menuIndex, mouseX, mouseY ) 
			if isDropped then
				local ourPanel = tableOfDroppedPanels[1]

				if ourPanel then
					print(ourPanel)
					local posX, posY = receiver:LocalToScreen(0, 0)
					ourPanel:SetPos(posX, posY)
					ourPanel:TDLib():Outline(Color(255, 0, 0))
				end
			end
		end, {} )
	end

	for i=1, MAX_MISC do
		self.weapons.misc[i] = self.weapons:Add("DPanel")
		self.weapons.misc[i]:SetSize(64 + 24, 64 + 24)
		self.weapons.misc[i]:TDLib():Background(Color(24, 24, 24)):Outline(Color(46, 204, 113, 100))
	end

	self.OurWeapons = {}
	self.OurWeaponsMisc = {}
	if LocalPlayer().inventory and LocalPlayer().inventory.equip then
		for k,v in pairs(LocalPlayer().inventory.equip) do
			local data = Fusion.inventory:GetItem(v)
			if not data then continue end

			self.OurWeapons[k] = vgui.Create("DModelPanel", self.weapons.items[k])
			self.OurWeapons[k]:Dock(FILL)
			self.OurWeapons[k]:SetModel(data.model)

			local mn, mx = self.OurWeapons[k].Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

			-- local function self.OurWeapons[k]:LayoutEntity( ent )
			-- 	return
			-- end

			self.OurWeapons[k].Entity:SetAngles(Angle(-15, 40, 0))
			self.OurWeapons[k]:SetFOV( 45 )
			self.OurWeapons[k]:SetCamPos( Vector( size, size, size ) )
			self.OurWeapons[k]:SetLookAt( ( mn + mx ) * 0.5 )
			self.OurWeapons[k]:TDLib():On('OnMouseReleased', function(s)
				net.Start('Fusion.inventory.unequip')
					net.WriteString("equip")
					net.WriteInt(k, 16)
				net.SendToServer()
				s:Remove()
				timer.Simple(0.2, function()
					self:RebuildInventory()
				end)
			end)
		end
	end

	if LocalPlayer().inventory and LocalPlayer().inventory.misc then
		for k,v in pairs(LocalPlayer().inventory.misc) do
			local data = Fusion.inventory:GetItem(v)
			if not data then continue end

			self.OurWeaponsMisc[k] = vgui.Create("DModelPanel", self.weapons.misc[k])
			self.OurWeaponsMisc[k]:Dock(FILL)
			self.OurWeaponsMisc[k]:SetModel(data.model)

			local mn, mx = self.OurWeaponsMisc[k].Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

			-- local function self.OurWeapons[k]:LayoutEntity( ent )
			-- 	return
			-- end

			self.OurWeaponsMisc[k].Entity:SetAngles(Angle(-15, 40, 0))
			self.OurWeaponsMisc[k]:SetFOV( 45 )
			self.OurWeaponsMisc[k]:SetCamPos( Vector( size, size, size ) )
			self.OurWeaponsMisc[k]:SetLookAt( ( mn + mx ) * 0.5 )
			self.OurWeaponsMisc[k]:TDLib():On('OnMouseReleased', function(s)
				net.Start('Fusion.inventory.unequip')
					net.WriteString("misc")
					net.WriteInt(k, 16)
				net.SendToServer()
				s:Remove()
				timer.Simple(0.2, function()
					self:RebuildInventory()
				end)
			end)
		end
	end

end

function PANEL:ReBuildWeapons()
	if self.OurWeapons then
		for k,v in pairs(self.OurWeapons) do
			if v then
				v:Remove()
			end
		end
	end

	if self.OurWeaponsMisc then
		for k,v in pairs(self.OurWeaponsMisc) do
			if v then
				v:Remove()
			end
		end
	end

	if self.wearables.equips then
		for k,v in pairs(self.wearables.equips) do
			v:Remove()
		end
	end

	self.OurWeapons = {}
	self.OurWeaponsMisc = {}
	if LocalPlayer().inventory and LocalPlayer().inventory.equip then
		for k,v in pairs(LocalPlayer().inventory.equip) do
			local data = Fusion.inventory:GetItem(v)
			if not data then continue end

			self.OurWeapons[k] = vgui.Create("DModelPanel", self.weapons.items[k])
			self.OurWeapons[k]:Dock(FILL)
			self.OurWeapons[k]:SetModel(data.model)

			local mn, mx = self.OurWeapons[k].Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

			-- local function self.OurWeapons[k]:LayoutEntity( ent )
			-- 	return
			-- end

			self.OurWeapons[k].Entity:SetAngles(Angle(-15, 40, 0))
			self.OurWeapons[k]:SetFOV( 45 )
			self.OurWeapons[k]:SetCamPos( Vector( size, size, size ) )
			self.OurWeapons[k]:SetLookAt( ( mn + mx ) * 0.5 )
			self.OurWeapons[k]:TDLib():On('OnMouseReleased', function(s)
				net.Start('Fusion.inventory.unequip')
					net.WriteString("equip")
					net.WriteInt(k, 16)
				net.SendToServer()
				s:Remove()
				timer.Simple(0.2, function()
					self:RebuildInventory()
				end)
			end)
		end
	end

	if LocalPlayer().inventory and LocalPlayer().inventory.misc then
		for k,v in pairs(LocalPlayer().inventory.misc) do
			local data = Fusion.inventory:GetItem(v)
			if not data then continue end

			self.OurWeaponsMisc[k] = vgui.Create("DModelPanel", self.weapons.misc[k])
			self.OurWeaponsMisc[k]:Dock(FILL)
			self.OurWeaponsMisc[k]:SetModel(data.model)

			local mn, mx = self.OurWeaponsMisc[k].Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

			-- local function self.OurWeapons[k]:LayoutEntity( ent )
			-- 	return
			-- end

			self.OurWeaponsMisc[k].Entity:SetAngles(Angle(-15, 40, 0))
			self.OurWeaponsMisc[k]:SetFOV( 45 )
			self.OurWeaponsMisc[k]:SetCamPos( Vector( size, size, size ) )
			self.OurWeaponsMisc[k]:SetLookAt( ( mn + mx ) * 0.5 )
			self.OurWeaponsMisc[k]:TDLib():On('OnMouseReleased', function(s)
				net.Start('Fusion.inventory.unequip')
					net.WriteString("misc")
					net.WriteInt(k, 16)
				net.SendToServer()
				s:Remove()
				timer.Simple(0.2, function()
					self:RebuildInventory()
				end)
			end)
		end
	end

		for k,v in pairs(LocalPlayer().inventory.cosmetic) do
			local data = Fusion.inventory:GetItem(v)
			if not data then continue end

			self.wearables.equips[k] = vgui.Create("DModelPanel", self.wearables.items[k])
			self.wearables.equips[k]:Dock(FILL)
			self.wearables.equips[k]:SetModel(data.model)

			local mn, mx = self.wearables.equips[k].Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

			-- local function self.OurWeapons[k]:LayoutEntity( ent )
			-- 	return
			-- end

			self.wearables.equips[k].Entity:SetAngles(Angle(-15, 40, 0))
			self.wearables.equips[k]:SetFOV( 45 )
			self.wearables.equips[k]:SetCamPos( Vector( size, size, size ) )
			self.wearables.equips[k]:SetLookAt( ( mn + mx ) * 0.5 )
			self.wearables.equips[k]:TDLib():On('OnMouseReleased', function(s)
				net.Start('Fusion.inventory.unequip')
					net.WriteString("cosmetic")
					net.WriteInt(k, 16)
				net.SendToServer()
				s:Remove()
				timer.Simple(0.2, function()
					self:RebuildInventory()
				end)
			end)
		end

end

function PANEL:CreateHUD()
	self.hud = self:Add("DPanel")
	self.hud:SetPos(10, self:GetTall() * 0.85)
	self.hud:SetSize(self:GetWide() * 0.19, self:GetTall() * 0.105)
	self.hud:TDLib():Background(Color(32, 32, 32, 255)):Outline(Color(64, 64, 64))

	local ourHealth = 35
	local health = self.hud:Add("DPanel")
	health:Dock(TOP)
	health:DockMargin(5, 5, 5, 0)
	health:SetTall(25)
	health:TDLib():On("Paint", function(s)
		ourHealth = Lerp(3 * FrameTime(), ourHealth, LocalPlayer():Health())
		surface.SetDrawColor(46, 204, 113)
		surface.DrawRect(0, 0, ourHealth * 3.1, self:GetTall())
	end)

	
	local ourHunger = 50
	local hungry = self.hud:Add("DPanel")
	hungry:Dock(TOP)
	hungry:DockMargin(5, 5, 5, 0)
	hungry:SetTall(25)
	hungry:TDLib():On("Paint", function(s)
		ourHunger = Lerp(4 * FrameTime(), ourHunger, LocalPlayer():Health())
		surface.SetDrawColor(230, 126, 34)
		surface.DrawRect(0, 0, ourHunger * 3.1, self:GetTall())
	end)


	local ourThrist = 25
	local thrist = self.hud:Add("DPanel")
	thrist:Dock(TOP)
	thrist:DockMargin(5, 5, 5, 0)
	thrist:SetTall(25)
	thrist:TDLib():On("Paint", function(s)
		ourThrist = Lerp(5 * FrameTime(), ourThrist, LocalPlayer():Health())
		surface.SetDrawColor(52, 152, 219)
		surface.DrawRect(0, 0, ourThrist * 3.1, self:GetTall())
	end)

end


function PANEL:CreateInfoPanel()
	self.infopanel = self:Add("DPanel")
	self.infopanel:SetSize(self:GetWide() * 0.30, self:GetTall() * 0.25)
	self.infopanel:SetPos(self.modelpnl:GetWide(), self:GetTall() * 0.05)
	self.infopanel:TDLib():Background(Color(35, 35, 35, 255)):Outline(Color(64, 64, 64))

	self.infomodel = self.infopanel:Add("DModelPanel")
	self.infomodel:SetPos(5, 1)
	self.infomodel:SetSize(self.infopanel:GetWide() * 0.5, self.infopanel:GetTall())
	self.infomodel:SetModel("models/player/gman_high.mdl")
	//self.modelpnl:SetAlpha(0)
	local mn, mx = self.infomodel.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

	self.infomodel.Entity:SetAngles(Angle(-15, 40, 0))
	self.infomodel:SetFOV( 70 )
	self.infomodel:SetCamPos( Vector( size, size, size ) )
	self.infomodel:SetLookAt( ( mn + mx ) * 0.5 )

	self.actionpnl = self.infopanel:Add('DPanel')
	self.actionpnl:SetSize(self.infopanel:GetWide() * 0.35, self.infopanel:GetTall() * 0.28)
	self.actionpnl:SetPos(self.infopanel:GetWide() * 0.64, self.infopanel:GetTall() * 0.69)
	self.actionpnl:TDLib():Background(Color(24, 24, 24)):Outline(Color(54, 54, 54))


	self.title = self.infopanel:Add("DLabel")
	self.title:Dock(TOP)
	self.title:DockMargin(10, 10, 0, 0)
	self.title:SetFont("Fusion_Label_Inventory")
	self.title:SetText(" ")
	self.title:SetTextColor(color_white)
	self.title:SetAlpha(255)

	self.title:SetExpensiveShadow(2, Color(0, 0, 0, 200))

	self.dsec = self.infopanel:Add("DLabel")
	self.dsec:SetPos(10, 15)
	self.dsec:SetWide(self.infopanel:GetWide() * 0.8)
	self.dsec:SetTall(80)
	self.dsec:SetFont("Fusion_Label_Inventory2")
	self.dsec:SetText(" ")
	self.dsec:SetTextColor(color_white)
	self.dsec:SetAlpha(255)
	self.dsec:SetWrap(true)
	self.dsec:SetMultiline(true)
//	self.dsec:SizeToContents()


	self.infopanel:SetVisible(false)

	self.actionpnl.buttons = {}
end

function PANEL:SetInfoModel(strItemID, model, parent)
	if not strItemID then return end

	

	local data = Fusion.inventory:GetItem(strItemID)
	if not data then return end

	for k,v in pairs(self.actionpnl.buttons) do
		if v then v
			:Remove() 
		end
	end

	self.actionpnl.buttons["Drop"] = self.actionpnl:Add("DButton")
	self.actionpnl.buttons["Drop"]:Dock(TOP)
	self.actionpnl.buttons["Drop"]:DockMargin(5, 5, 5, 0)
	self.actionpnl.buttons["Drop"]:SetText('Drop')
	self.actionpnl.buttons["Drop"]:TDLib():Background(Color(40, 40, 40)):Outline(Color(64, 64, 64))
	self.actionpnl.buttons["Drop"]:SetTextColor(Color(255, 255, 255))
	self.actionpnl.buttons["Drop"]:On('DoClick', function(s)
		net.Start("Fusion.inventory.spawn")
			net.WriteInt(data.id, 16)
		net.SendToServer()
		model.quantity = model.quantity - 1

		if model.quantity < 1 then
			model:Remove()
			parent:InvalidateLayout()
		end
	end)
	self.actionpnl:SetTall(self.infopanel:GetTall() * 0.15)

	if data.weapon then
		self.actionpnl.buttons["Equip"] = self.actionpnl:Add("DButton")
		self.actionpnl.buttons["Equip"]:Dock(TOP)
		self.actionpnl.buttons["Equip"]:DockMargin(5, 5, 5, 0)
		self.actionpnl.buttons["Equip"]:SetText('Equip')
		self.actionpnl.buttons["Equip"]:TDLib():Background(Color(40, 40, 40)):Outline(Color(64, 64, 64))
		self.actionpnl.buttons["Equip"]:SetTextColor(Color(255, 255, 255))
		self.actionpnl.buttons["Equip"]:On('DoClick', function(s)
			net.Start('Fusion.inventory.equip')
				net.WriteInt(data.id, 16)
			net.SendToServer()
			timer.Simple(0.1, function()
				self:ReBuildWeapons()
				self:RebuildInventory()
			end)
		end)
		self.actionpnl:SetTall(self.infopanel:GetTall() * 0.28)
	end

	if data.cosmetic then
		self.actionpnl.buttons["Wear"] = self.actionpnl:Add("DButton")
		self.actionpnl.buttons["Wear"]:Dock(TOP)
		self.actionpnl.buttons["Wear"]:DockMargin(5, 5, 5, 0)
		self.actionpnl.buttons["Wear"]:SetText("Wear")
		self.actionpnl.buttons["Wear"]:TDLib():Background(Color(40, 40, 40)):Outline(Color(64, 64, 64))
		self.actionpnl.buttons["Wear"]:SetTextColor(Color(255, 255, 255))
		self.actionpnl.buttons["Wear"]:On('DoClick', function(s)
			net.Start('Fusion.inventory.equip')
				net.WriteInt(data.id, 16)
			net.SendToServer()
			timer.Simple(0.1, function()
				self:ReBuildWeapons()
				self:RebuildInventory()
			end)
		end)
		self.actionpnl:SetTall(self.infopanel:GetTall() * 0.28)
	end

	self.ourItem = strItemID
	self.infopanel:SetVisible(true)
	self.infomodel:SetModel(data.model)
	self.title:SetText(data.name)
	self.dsec:SetText(data.desc)
	

end

function PANEL:RebuildInventory()
	self.inventory_items = self:Add("DIconLayout")
	self.inventory_items:SetSize(self:GetWide() * 0.33, self:GetTall() * 0.55)
	self.inventory_items:SetPos(self.modelpnl:GetWide() + 10, self:GetTall() * 0.35)
	self.inventory_items:SetSpaceX(5)
	self.inventory_items:SetSpaceY(5)
	self.inventory_items.items = {}

	for k,v in pairs(self.inventory_items.items) do
		v:Remove()
	end

	local MAX_COUNTER = 25
	for i=1, 25 do
		self.inventory_items.items[i] = self.inventory_items:Add("DPanel")
		self.inventory_items.items[i]:SetSize(64 + 24, 64 + 24)
		self.inventory_items.items[i]:TDLib():Background(Color(24, 24, 24)):Outline(Color(54, 54, 54))
	end

	local data = Fusion.inventory:GetInventory(LocalPlayer())
	if not data then return end

	local count = 1	
	local items = {}
	for k,v in pairs(data) do
		local item = Fusion.inventory:GetItem(k)
		if not item then continue end 

		items[k] = self.inventory_items.items[count]:Add("DModelPanel")
		items[k]:SetModel(item.model)
		items[k]:Dock(FILL)
		items[k].quantity = v.quantity
		local mn, mx = items[k].Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

		items[k].Entity:SetAngles(Angle(-15, 40, 0))
		items[k]:SetFOV( 75 )
		items[k]:SetCamPos( Vector( size, size, size ) )
		items[k]:SetLookAt( ( mn + mx ) * 0.5 )

		items[k]:TDLib():On("Paint", function(s)
			draw.SimpleText("x"..items[k].quantity, "TargetID", 5, 5, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT)
		end)

		items[k]:On("OnMouseReleased", function(s)
			self:SetInfoModel(k, s, self.inventory_items)
		end)
		items[k]:Droppable('equipped')



		count = count + 1
	end

end


function PANEL:Think()
	if input.IsKeyDown(KEY_F1) then
		self:Remove()
	end
end

vgui.Register("FusionInventory", PANEL, "EditablePanel")


concommand.Add("inventory_gui", function()
	if inventory then
		inventory:Remove()
	end

	//inventory = vgui.Create("FusionMenu")
end)


////