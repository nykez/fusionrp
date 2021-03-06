AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");

util.AddNetworkString("Fusion.npc.use")

function ENT:Initialize ( )
	if self.NoBBox then
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
	else
		self:SetSolid( SOLID_BBOX )
		self:PhysicsInit( SOLID_BBOX )
	end

	self:SetMoveType( MOVETYPE_NONE )
	self:DrawShadow( true )
	self:SetUseType( SIMPLE_USE )

end

function ENT:AcceptInput( Name, Player, Caller)
	if Name == "Use" and Caller:IsPlayer() then
		self:UseShort(Caller);
	end
end

function ENT:UseShort(Player)
	self:UseFake(Player);
end

function ENT:UseLong(Player)

end

function ENT:UseFake ( User )
	if (!IsValid(User) || !User:IsPlayer()) then return false; end

	net.Start("Fusion.npc.use")
		net.WriteInt(self.id, 16)
	net.Send(User)
end
