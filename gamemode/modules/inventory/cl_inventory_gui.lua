


local PANEL = {}

function PANEL:Init()

	self:SetSize(ScrW(), ScrH())

	self:MakePopup()
	self:Center()

	self:TDLib():Background(Color(32, 32, 32, 210)):Gradient(Color(35, 35, 35, 255))

	self:CreateModel()
	self:CreateInventory()
	self:CreateWearables()

	self:CreateWeapons()

	self:CreateHUD()

	//self:CreateView()
end

function PANEL:CreateModel()
	self.modelpnl = self:Add("DModelPanel")
	self.modelpnl:SetSize(self:GetWide() * 0.3, self:GetTall() * 0.65)
	self.modelpnl:SetPos(5, self:GetTall() * 0.07)
	self.modelpnl:SetModel("models/player/gman_high.mdl")
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

	self.modelpnl.Entity:SetAngles(Angle(-15, 40, 0))
	self.modelpnl:SetFOV( 32 )
	self.modelpnl:SetCamPos( Vector( size, size, size ) )
	self.modelpnl:SetLookAt( ( mn + mx ) * 0.5 )
	-- self.modelpnl:TDLib():On("Paint", function(s)
	-- 	surface.SetDrawColor(color_white)
	-- 	surface.DrawOutlinedRect(0, 0, s:GetWide(), s:GetTall())
	-- end)

end

function PANEL:CreateInventory()
	self.inventory_items = self:Add("DIconLayout")
	self.inventory_items:SetSize(self:GetWide() * 0.33, self:GetTall() * 0.55)
	self.inventory_items:SetPos(self.modelpnl:GetWide() + 10, self:GetTall() * 0.35)
	self.inventory_items:SetSpaceX(5)
	self.inventory_items:SetSpaceY(5)
	self.inventory_items.items = {}

	local MAX_COUNTER = 25
	for i=1, 25 do
		self.inventory_items.items[i] = self.inventory_items:Add("DPanel")
		self.inventory_items.items[i]:SetSize(64 + 24, 64 + 24)
		self.inventory_items.items[i]:TDLib():Background(Color(24, 24, 24)):Outline(Color(54, 54, 54))
	end

	local data = Fusion.inventory:GetInventory(LocalPlayer())
	if not data then return end

	PrintTable(data)
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
			draw.SimpleText(items[k].quantity, "TargetID", 5, 5, Color(255, 255, 255, 100), TEXT_ALIGN_LEFT)
		end)

		items[k]:On("OnMouseReleased", function(s)
			MsgN('released')
		end)



		count = count + 1
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

	local counter = 0;
	for i=1, MAX_WEAPON do
		self.weapons.items[i] = self.weapons:Add("DPanel")
		self.weapons.items[i]:SetSize(64 + 24, 64 + 24)
		self.weapons.items[i]:TDLib():Background(Color(24, 24, 24)):Outline(Color(52, 152, 219, 100))
		counter = counter + 1
	end

	for i=1, MAX_MISC do
		self.weapons.items[counter] = self.weapons:Add("DPanel")
		self.weapons.items[counter]:SetSize(64 + 24, 64 + 24)
		self.weapons.items[counter]:TDLib():Background(Color(24, 24, 24)):Outline(Color(46, 204, 113, 100))
		counter = counter + 1
	end

end

function PANEL:CreateHUD()
	self.hud = self:Add("DPanel")
	self.hud:SetPos(self:GetWide()*0.78, self:GetTall() * 0.85)
	self.hud:SetSize(self:GetWide() * 0.2, self:GetTall() * 0.13)
	self.hud:TDLib():Background(Color(32, 32, 32, 255)):Outline(Color(64, 64, 64))

	local health = self.hud:Add("DPanel")
	health:Dock(TOP)
	health:DockMargin(5, 5, 5, 0)
	health:SetTall(30)
	health:TDLib():Background(Color(46, 204, 113)):Outline(Color(54, 54, 54))

	
	local hungry = self.hud:Add("DPanel")
	hungry:Dock(TOP)
	hungry:DockMargin(5, 5, 5, 0)
	hungry:SetTall(30)
	hungry:TDLib():Background(Color(230, 126, 34)):Outline(Color(54, 54, 54))

	local thrist = self.hud:Add("DPanel")
	thrist:Dock(TOP)
	thrist:DockMargin(5, 5, 5, 0)
	thrist:SetTall(30)
	thrist:TDLib():Background(Color(52, 152, 219)):Outline(Color(54, 54, 54))
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

	inventory = vgui.Create("FusionInventory")
end)
