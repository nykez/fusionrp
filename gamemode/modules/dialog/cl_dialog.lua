local PANEL = PANEL or {}

surface.CreateFont( "Fusion_Dialog_Title", {
	font = "Bebas Neue",
	extended = true,
	size = 32,
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


function PANEL:Init()

	self:SetWide(ScrW() * 0.3)
	self:SetTall(ScrW() * 0.12)

	self:Center()

	self.background = self:Add("DPanel")
	self.background:TDLib():Background(Color(32, 32, 32, 255)):Gradient(Color(35, 35, 35))
	self.background:Dock(FILL)

	self.title = self.background:Add("DLabel")
	self.title:Dock(TOP)
	self.title:DockMargin(5, 0, 0, 0)
	self.title:SetFont("Fusion_Dialog_Title")
	self.title:SetText("Car Dealer")
	self.title:SetTextColor(color_white)
	self.title:SetZPos(400)
	self.title:SetAlpha(255)
	self.title:SetTall(35)
	self.title:Center()

	self.container = self.background:Add("DScrollPanel")
	self.container:Dock(FILL)

	self:SetVisible(false);

	self:SetContentAlignment(2)

	self.buttons = {}
end

function PANEL:ClearCanvas()
	for k,v in pairs(self.buttons) do
		v:Remove()
	end

	self.buttons = {}
end

function PANEL:AddButton(strText, func)
	self.buttons[strText] = self.container:Add('Button')
	self.buttons[strText]:SetText(strText)
	self.buttons[strText]:Dock(TOP)
	self.buttons[strText]:DockMargin(5, 0, 5, 3)
	self.buttons[strText]:TDLib():Background(Color(37, 37, 37)):BarHover(Color(64, 64, 64, 255), 3)
	self.buttons[strText]:SetTextColor(color_white)
	self.buttons[strText]:On("DoClick", function(s)
		self:ClearCanvas()
		func()
	end)
end

function PANEL:SetTitle(strText)
	self.title:SetText(strText)
end

function PANEL:Think()
	if input.IsKeyDown(KEY_F1) then
		self:Hide()
	end
end

function PANEL:Show( )
	self:SetVisible(true);
	self:MakePopup();
end


function PANEL:Hide()
	self:SetVisible(false);
	self:ClearCanvas()
end

vgui.Register("FusionDialog", PANEL, "EditablePanel")





