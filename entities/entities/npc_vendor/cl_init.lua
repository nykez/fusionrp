include( "shared.lua" )

function ENT:Initialize()
	self:InitializeAnimation()
end

function ENT:Draw()
	self:DrawModel()
end