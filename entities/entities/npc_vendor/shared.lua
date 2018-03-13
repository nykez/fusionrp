
ENT.Type 				= "anim";
ENT.Base 				= "base_anim";
ENT.PrintName			= "NPC";
ENT.Author				= "Nykez";
ENT.Purpose				= "Fun & Games";

ENT.Spawnable			= false;
ENT.AdminSpawnable		= false;

function ENT:OnRemove() end

ENT.Base = "base_ai" -- This entity is based on "base_ai"
ENT.Type = "ai" -- What type of entity is it, in this case, it's an AI.
ENT.AutomaticFrameAdvance = true -- This entity will animate itself.
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim ) -- This is called by the game to tell the entity if it should animate itself.
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "ourName" );

	if SERVER then
		self:SetourName("Test")
	end

end