
local PANEL = {}

function PANEL:Init()

	self:SetWide(ScrW() * 0.5, ScrH() * 0.5)



end

function PANEL:Think()
	if Input.input.IsKeyDown(KEY_F1) then
		self:Remove()
	end
end


vgui.Register('FusionClothes', PANEL, "EditablePanel")
