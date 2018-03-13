
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')


function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType( SIMPLE_USE )
	self.Entity:Activate()

	self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE  )

	
	self.Entity:GetPhysicsObject():Wake();

end
function ENT:Use( activator, caller )
	if IsValid( caller ) and caller:IsPlayer() then
		if caller:KeyDownLast(IN_SPEED) then
			if self.canedit then
				net.Start("Fusion.inventory.edit")
					net.WriteEntity(self)
					net.WriteInt(self.id, 16)
				net.Send(caller)
			end
		else
			Fusion.inventory:Add(caller, self.id, 1)
			self:Remove()
		end
	end
end
