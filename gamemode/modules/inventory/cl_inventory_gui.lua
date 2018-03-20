


local PANEL = {}

function PANEL:Init()

	self:SetSize(ScrW() * 0.50, ScrH() * 0.7)

	self:MakePopup()
	self:Center()

	self:TDLib():Background(Color(35, 35, 35)):Gradient(Color(28, 28, 28))

	self:CreateModel()
	self:CreateEquipped()
	self:CreateItems()
end

function PANEL:CreateModel()
	self.modelpnl = self:Add("DModelPanel")
	self.modelpnl:SetSize(self:GetWide()/2, self:GetTall())
	self.modelpnl:SetModel("models/player/gman_high.mdl")
	//self.modelpnl:SetAlpha(0)
	local mn, mx = self.modelpnl.Entity:GetRenderBounds()
	local size = 0
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

	function self.modelpnl.LayoutEntity( ent )
		self.modelpnl.Entity:SetSequence( "idle_all_02" )
		self.modelpnl:RunAnimation()
		return
	end

	self.modelpnl.Entity:SetAngles(Angle(0, 40, 0))
	self.modelpnl:SetFOV( 30 )
	self.modelpnl:SetCamPos( Vector( size, size, size ) )
	self.modelpnl:SetLookAt( ( mn + mx ) * 0.5 )

end

local tbl = {
	"models/player/gman_high.mdl",
	"models/player/gman_high.mdl"
}

local MAX_SLOTS = 6
local MAX_WEAPONS = 2

function PANEL:CreateEquipped()
	self.equipList = self:Add("DIconLayout")
	self.equipList:SetPos(self.modelpnl:GetWide(), 10)
	self.equipList:SetSize(self:GetWide() * 0.5, self:GetTall() * 0.2)
	self.equipList:SetSpaceX(5)
	self.equipList:SetSpaceY(5)

	self.weapons = {}
	self.slots = {}
	for i=1, MAX_WEAPONS do
		self.weapons[i] = self.equipList:Add("DPanel")
		self.weapons[i]:SetSize(80, 60)
		self.weapons[i]:TDLib():Background(Color(56, 56, 56)):Outline(Color(52, 152, 219))
	end

	for i = 1, MAX_SLOTS do
		self.slots[i] = self.equipList:Add("DPanel")
		self.slots[i]:SetSize(80, 60)
		self.slots[i]:TDLib():Background(Color(56, 56, 56)):Outline(Color(46, 204, 113))
	end

end

function PANEL:CreateItems()
	self.itemList = self:Add("DScrollPanel")
	self.itemList:SetPos(self.equipList:GetWide(), self.equipList:GetTall() * 1.1)
	self.itemList:SetSize(self:GetWide() * 0.48, self:GetTall() - self.equipList:GetTall() - 20)

	local data = Fusion.inventory:GetInventory(LocalPlayer())
	-- LocalPlayer().inventory = {}
	-- LocalPlayer().inventory[1] = true
	-- LocalPlayer().inventory[2] = true
	

	PrintTable(data)
	for k,v in pairs(data) do
		local item = Fusion.inventory:GetItem(k)

		local itempnl = self.itemList:Add("DPanel")
		itempnl.id = k
		itempnl.quantity = data[k].quantity
		itempnl:Dock(TOP)
		itempnl:DockMargin(0, 0, 0, 5)
		itempnl:SetTall(60)
		itempnl:TDLib():Background(Color(56, 56, 56)):DualText(
			item.name,
			"TargetID",
			color_white,

			itempnl.quantity, 
			"TargetID",
			color_white


			)

		local icon = itempnl:Add('SpawnIcon')
		icon:SetModel(item.model)

		local spawn_btn = itempnl:Add("DButton")
		spawn_btn:Dock(RIGHT)
		spawn_btn:SetText("Use")
		spawn_btn:TDLib():Background(Color(45, 45, 45)):Text("Use", "TargetID"):FadeHover(Color(32, 32, 32))
		spawn_btn:On("DoClick", function(s)
			net.Start("Fusion.inventory.spawn")
				net.WriteInt(itempnl.id, 16)
			net.SendToServer()

			itempnl.quantity = itempnl.quantity - 1
			
			if itempnl.quantity <= 0 then
				self:Remove()
			end
		end)
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

	inventory = vgui.Create("FusionInventory")
end)
