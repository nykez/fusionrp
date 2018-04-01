

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
		shopmenu = nil
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
		self.items[k]:TDLib():Background(Color(40, 40, 40))
		self.items[k]:Text(item.name)


		self.items[k].addbtn = self.items[k]:Add("DButton")
		self.items[k].addbtn:Dock(RIGHT)
		self.items[k].addbtn:SetText("Add")
		self.items[k].addbtn:TDLib():Background(Color(30, 30, 30)):FadeHover(Color(35, 35, 35))
		self.items[k].addbtn:SetTextColor(Color(72, 72, 72))
		self.items[k].addbtn:On("DoClick", function(s)
			self:AddItem(k, math.random(25, 500))
		end)

		self.items[k].model = self.items[k]:Add("DModelPanel")
		self.items[k].model:Dock(LEFT)
		self.items[k].model:SetModel(item.model)

	end
end

function PANEL:AddItem(id, intCost)
	if (!self.first) then
		self.purchase:TDLib():Background(Color(46, 204, 113))
		self.first = true
	end

	local item = self.cart:Add("DPanel")
	item:Dock(TOP)
	item:DockMargin(5, 0, 5, 5)
	item:SetTall(40)

	self.cost = self.cost + intCost

	self.purchase:SetText("Purchase ($"..self.cost..")")

end

function PANEL:Think()
	if input.IsKeyDown(KEY_F1) then
		self:Remove()
	end
end

vgui.Register("FusionShopMenu", PANEL, "EditablePanel")


concommand.Add("shop", function()
	PrintTable(Fusion.shops.database)
	if IsValid(shopmenu) then
		shopmenu:Remove()
		shopmenu = nil
	end

	shopmenu = vgui.Create("FusionShopMenu")
end)