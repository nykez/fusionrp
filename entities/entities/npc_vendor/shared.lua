
ENT.Type 				= "anim";
ENT.Base 				= "base_anim";
ENT.PrintName			= "NPC";
ENT.Author				= "Nykez";
ENT.Purpose				= "Fun & Games";

ENT.Spawnable			= false;
ENT.AdminSpawnable		= false;

function ENT:OnRemove() end

ENT.Type = "ai"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = false

function ENT:InitializeAnimation( animID )
	if SERVER then
		if animID then
			if animID ~= -1 then
				self:ResetSequence( animID )
			end
		else
			self:ResetSequence( 7 )
		end
	end
	
	self:SetAutomaticFrameAdvance( true )
end

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "ourName" );

	if SERVER then
		self:SetourName("Test")
	end

end