include("shared.lua");

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    if(LocalPlayer():GetPos():Distance(self:GetPos()) > 1000) then return end
	
	self:DrawModel()

	local ang = EyeAngles()
	ang:RotateAroundAxis(ang:Right(),90)
	ang:RotateAroundAxis(ang:Up(),-90)

	local text = self:GetourName()
	local color = Color(255, 255, 255)

	cam.Start3D2D(self:GetPos() + Vector(0,0,75), ang,0.15)
		surface.SetFont("TargetID")
		local dX,dY = surface.GetTextSize(text)

		surface.SetDrawColor(32,32,32,130)
		surface.DrawRect(-(dX+32)/2,-dY-16,dX+32,dY+32)
		draw.SimpleTextOutlined(text,"TargetID",0,-dY,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,Color(25,25,25))
	cam.End3D2D()
end