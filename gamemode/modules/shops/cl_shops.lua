

local PANEL = {}

function PANEL:Init()
	self:SetWide(ScrW() * 0.55)
	self:SetTall(ScrH() * 0.6)
	self:Center()
	self:MakePopup()

	self.id = 1
	self.items = {}
	self.checkout = {}
	self.cost = 0

	local data = Fusion.shops:Get(self.id)

	if not data then
		self:Remove()
		Fusion.menus:Remove("FusionShop")
		LocalPlayer():Notify("Invalid shop. Removing.")
		return
	end

	self:TDLib():Background(Color(35, 35, 35)):Outline(Color(0, 0, 0))

	self.navbar = self:Add("DPanel")
	self.navbar:Dock(TOP)
	self.navbar:SetTall(self:GetTall() * 0.1)
	self.navbar:TDLib():Background(Color(26, 26, 26)):Gradient(Color(30, 30, 30))
	self.navbar:Text(data.name)

	self.container = self:Add("DScrollPanel")
	self.container:Dock(FILL)

	local sbar = self.container:GetVBar()
	sbar:TDLib():Background(Color(54, 54, 54))
	sbar.btnGrip:TDLib():Background(Color(75, 75, 75))
	sbar.btnUp:TDLib():Background(Color(125, 125, 125)):Text("^", nil, nil, 0, 5)
	sbar.btnDown:TDLib():Background(Color(125, 125, 125))


	self.cart = self:Add("DScrollPanel")
	self.cart:Dock(RIGHT)
	self.cart:SetWide(self:GetWide()*0.3)
	self.cart:TDLib():Background(Color(35, 35, 35))

	self.purchase = vgui.Create("DButton", self)
	self.purchase:SetSize(self.cart:GetWide()-10, 30)
	self.purchase:SetPos(self:GetWide() - self.cart:GetWide()+5, self:GetTall() * 0.942)
	self.purchase:SetText("Purchase")
	self.purchase:TDLib():Background(Color(231, 76, 60))
	self.purchase:SetTextColor(color_white)
	self.purchase:On('DoClick', function(s)
		if self.cost and !LocalPlayer():CanAfford(self.cost) then
			LocalPlayer():Notify("You can't afford this cart.")
			return
		end

		if !self.checkout then return end

		net.Start("Fusion.shops.purchase")
			net.WriteTable(self.checkout)
			net.WriteInt(self.id, 16)
		net.SendToServer()

		self:Remove()
		Fusion.menus:Remove("FusionShop")
	end)

	self.cart:DockMargin(0, 0, 0, self:GetTall() * (1 - 0.944))

	self:LoadItems(data.items)
end

function PANEL:LoadItems(dataItems)
	for k,v in pairs(dataItems) do

		local item = Fusion.inventory:GetItem(v)

		self.items[k] = self.container:Add("DPanel")
		self.items[k]:Dock(TOP)
		self.items[k]:SetTall(65)
		self.items[k]:DockMargin(5, 5, 5, 0)
		self.items[k]:TDLib():Background(Color(40, 40, 40)):Outline(Color(65, 65, 65))
		self.items[k]:DualText(item.name, nil, color_white, item.desc, nil, Color(100, 100, 100))


		self.items[k].addbtn = self.items[k]:Add("DButton")
		self.items[k].addbtn:Dock(RIGHT)
		self.items[k].addbtn:DockMargin(0, 5, 5, 5)
		self.items[k].addbtn:SetText("Add")
		self.items[k].addbtn:TDLib():Background(Color(30, 30, 30)):FadeHover(Color(35, 35, 35))
		self.items[k].addbtn:SetTextColor(Color(72, 72, 72))
		self.items[k].addbtn:On("DoClick", function(s)
			self:AddItem(k, item.price, item.name)
		end)

		self.items[k].model = self.items[k]:Add("DModelPanel")
		self.items[k].model:Dock(LEFT)
		self.items[k].model:SetModel(item.model)

	end
end

function PANEL:AddItem(id, intCost, ourItem)
	if (!self.first) then
		self.purchase:TDLib():Background(Color(46, 204, 113))
		self.first = true
	end

	table.insert(self.checkout, id)

	local id = #self.checkout

	local item = self.cart:Add("DPanel")
	item:Dock(TOP)
	item:DockMargin(5, 0, 5, 5)
	item:SetTall(50)
	item:TDLib():Background(Color(27, 27, 27)):Outline(Color(72, 72, 72)):Text(ourItem)
	item.ourID = id
	item.cost = intCost
	item:On('OnMouseReleased', function(s)
		self.checkout[s.ourID] = nil
		self.cost = self.cost - s.cost
		self.purchase:SetText("Purchase ($"..self.cost..")")
		s:Remove()
	end)

	self.cost = self.cost + intCost

	self.purchase:SetText("Purchase ($"..self.cost..")")

	if not LocalPlayer():CanAfford(self.cost) then
		self.purchase:SetTextColor(Color(255, 0, 0))
	end
end

function PANEL:Think()
	if input.IsKeyDown(KEY_F1) then
		self:Remove()
	end
end

vgui.Register("FusionShop", PANEL, "EditablePanel")

concommand.Add("openshop", function(ply, cmd, args)
	Fusion.menus:Create("FusionShop")
end)
