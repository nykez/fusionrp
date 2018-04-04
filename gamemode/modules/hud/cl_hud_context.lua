
local PANEL = {}

function PANEL:Init()
	self:SetWide(ScrW()*0.3)
	self:SetTall(ScrH() * 0.25)

	self:Center()
	self:MakePopup()

	self:TDLib():Circle(Color(50, 50, 50))

	self:Build("door")
end

function PANEL:Build(stringType)
	if stringType == "door" then
		self.knock = self:Add("DPanel")
		self.knock:Center()
		self.knock:TDLib():On("Paint", function(s)
		end)
		
	end
end

function PANEL:Think()
	if input.IsKeyDown(KEY_F1) then
		self:Remove()
	end
end


vgui.Register("FusionContext", PANEL, "EditablePanel")