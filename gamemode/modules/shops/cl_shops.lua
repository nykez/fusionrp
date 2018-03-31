

local PANEL = {}

function PANEL:Init()

end

function PANEL:Think()
	if input.IsKeyDown(KEY_F1) then
		self:Remove()
	end
end