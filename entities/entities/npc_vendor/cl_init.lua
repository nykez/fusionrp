include("shared.lua");

ENT.RenderGroup = RENDERGROUP_BOTH

surface.CreateFont( "Fusion_NPC", {
	font = "Bebas Neue",
	extended = true,
	size = ScreenScale(14),
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

function ENT:Draw()
    if(LocalPlayer():GetPos():Distance(self:GetPos()) > 1000) then return end
	
	self:DrawModel()
	self:DrawTranslucent()
end


function ENT:DrawTranslucent()
	-- local color = Color(255, 255, 255)


	-- local NPCNAME = self:GetourName() or "nil"

	-- local offset = Vector( 0, 0, 90 )

	-- local ang = LocalPlayer():EyeAngles()
	-- local pos = self:GetPos() + offset + ang:Up() * ( math.sin( CurTime() ) * 4 )

	-- ang:RotateAroundAxis( ang:Forward(), 90 )
	-- ang:RotateAroundAxis( ang:Right(), 90 )
	-- local dX,dY = surface.GetTextSize(NPCNAME or "nil")


	-- cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.14 )
	
	-- 	surface.SetDrawColor(32,32,32,130)
	-- 	surface.DrawRect(-(dX+32)/2,-dY-16,dX+32,dY+32)

	-- 	draw.DrawText( NPCNAME, "Fusion_NPC", 0, -dY, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	-- cam.End3D2D()
end
