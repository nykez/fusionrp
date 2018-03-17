local PANEL = {}


surface.CreateFont( "Fusion_PhonePopup", {
	font = "Bebas Neue",
	extended = false,
	size = 22,
	weight = 100,
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

surface.CreateFont( "Fusion_PhonePopupBtn", {
	font = "Arial",
	extended = false,
	size = 16,
	weight = 100,
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


surface.CreateFont( "Fusion_PhoneLabel", {
	font = "Arial",
	extended = false,
	size = 24,
	weight = 400,
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

surface.CreateFont( "Fusion_PhoneContact", {
	font = "Bebas Neue",
	extended = false,
	size = 24,
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

local phone = Material("f_phone/frame.png", "noclamp smooth")
local background = Material("f_phone/background1.png", "noclamp smooth")
local background2 = Material("f_phone/background2.png", "noclamp smooth")
local background3 = Material("f_phone/background3.png", "noclamp smooth")
local background4 = Material("f_phone/background4.png", "noclamp smooth")
local settings = Material("f_phone/settingsicon.png", "noclamp smooth")
local text = Material("f_phone/texticon.png", "noclamp smooth")
local camera = Material("f_phone/cameraicon.png", "noclamp smooth")
local phoneicon = Material("f_phone/phoneicon.png", "noclamp smooth")

local tbl = {
	["Huskey"] = {
		total = 45,
		new = 0,
		chat = {
			"hello",
			"Whats up?",
			"Not much. Just chiling."
		}
	},
	["Pepper"] = {
		total = 16,
		new = 0,
	},
	["Jerry"] = {
		total = 4, 
		new = 0,
	},

}
function PANEL:Init()

	local w = 511
	local h = 977


	self:SetWide(ScrW() * 0.20)
	self:SetTall(ScrH() * 0.68)

	self:SetPos(ScrW() * 0.78, ScrH() * 0.23)

	self.background = self:Add("DPanel")
	self.background:Dock(FILL)
	function self.background:Paint(w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(background2)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	self.phone = self:Add("DPanel")
	self.phone:Dock(FILL)
	function self.phone:Paint(w, h)
		surface.SetDrawColor(Color(255, 255, 255))
		surface.SetMaterial(phone)
		surface.DrawTexturedRect(0, 0, w, h)
	end


	self.icons = self:Add("DIconLayout")
	self.icons:Dock(FILL)
	self.icons:DockMargin(25, 75, 5, 5)
	self.icons:SetSpaceY( 5 )
	self.icons:SetSpaceX( 5 )
	function self.icons:Paint() end

	self.notice = self:Add("DPanel")
	//self.notice:SetPos(self:GetWide() * 0.5, self:GetTall() * 0.5)
	self.notice:SetVisible(false)
	self.notice:DockMargin(20, 100, 30, 5)
	self.notice:SetWide(225)
	self.notice:SetTall(70)
	self.notice:Center()
	self.notice.Paint = function() end



	self.okbtn = self.notice:Add('DButton')
	self.okbtn:Dock(BOTTOM)
	self.okbtn.Paint = function() end
	self.okbtn:TDLib():Background(Color(231, 76, 60, 255)):Text("OK", "Fusion_PhonePopupBtn"):Outline(Color(0, 0, 0, 200))
	:FadeHover(Color(192, 57, 43))
	self.okbtn:On('DoClick', function(s)
		self.notice:SetVisible(false)
	end)
	self.okbtn:DockMargin(10, 5, 10, 5)

	self.buttons = {
		["phone"] = {
			mat = phoneicon,
			func = function() self:Remove() end,
		},
		["settings"] = {
			mat = settings, 
			func = function() self:AddHint("Settings not enabled") end,
		},
		["text"] = {
			mat = text,
			func = function() 
				self.icons:SetVisible(false)

				local panel = self:Add("DPanel")
				panel:Dock(FILL)
				panel:DockMargin(26, 55, 26, 50)
				panel:TDLib():Background(Color(32, 32, 32))

				local newText = panel:Add('DButton')
				newText:TDLib():Background(Color(46, 204, 113, 255)):Text("New Message", "Fusion_PhonePopupBtn")
				:Outline(Color(0, 0, 0, 200))
				newText:Dock(TOP)
				newText:DockMargin(5, 5, 5, 5)

				local container = panel:Add("DScrollPanel")
				container:Dock(FILL)
				container.Paint = function() end


			 end,
		},
		["camera"] = {
			mat = camera,
			func = function() 
				self.icons:SetVisible(false)

				local panel = self:Add("DPanel")
				panel:Dock(FILL)
				panel:DockMargin(26, 55, 26, 50)
				panel:TDLib():Background(Color(32, 32, 32))
				function panel:Paint()
					local x, y = self:GetPos()

					render.RenderView( {
						origin = LocalPlayer():GetPos() + Vector(0, 0, 20),
						angles = Angle( 0, 0, 0 ),
						x = x, y = y,
						w = w, h = h
					} )
				end




			 end,
		}
	}


	self:MakePopup()
	self:CreateButtons()

	self.animating = false
end

function PANEL:Paint()

end

function PANEL:AddHint(strText)
	self.notice:TDLib():Background(Color(30, 30, 30)):Outline(Color(0, 0, 0, 200)):Text(strText, "Fusion_PhonePopup", color_white, TEXT_ALIGN_CENTER, nil, -10)
	self.notice:SetVisible(true)
end


function PANEL:CreateButtons()
	for k,v in pairs(self.buttons) do
		local ListItem = self.icons:Add( "DPanel" ) -- Add DPanel to the DIconLayout
		ListItem:SetSize( 60, 70 ) -- Set the size of it
		ListItem.mat = v.mat
		ListItem.func = v.func
		function ListItem:Paint(w, h) 
			surface.SetDrawColor(Color(255, 255, 255))
			surface.SetMaterial(ListItem.mat)
			surface.DrawTexturedRect(0, 0, w, h)
		end

		ListItem.OnMouseReleased = function()
			ListItem.func()
		end
	end

end


function PANEL:Think()
	if input.IsButtonDown(KEY_F1) then
		self:Remove()
	end
end


vgui.Register("FusionPhone", PANEL, "DPanel")

concommand.Add("phone", function(player)
	if Fusionphone then
		Fusionphone:Remove()
	end

	Fusionphone = vgui.Create("FusionPhone")
end)