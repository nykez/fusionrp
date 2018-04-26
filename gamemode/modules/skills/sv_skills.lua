
Fusion.skills = Fusion.skills or {}


util.AddNetworkString("Fusion.skills.sync")
function Fusion.skills:AddSkill(pPlayer, stringSkill, amount)
	if not Fusion.skills.list[stringSkill] then return end
	
	if not pPlayer.skills[stringSkill] then
		pPlayer.skills[stringSkill] = amount
	else
		local getSkill = self:GetSkillLevel(pPlayer, stringSkill)
		if getSkill then
			pPlayer.skills[stringSkill] = getSkill + amount
		end
	end

	self:SyncSkills(pPlayer, stringSkill)
	self:WriteSkills(pPlayer)
end

function Fusion.skills:SyncSkills(pPlayer, stringSkill)
	local getSkill = self:GetSkillLevel(pPlayer, stringSkill)

	if not getSkill then return end
	
	net.Start("Fusion.skills.sync")
		net.WriteString(stringSkill)
		net.WriteInt(getSkill, 32)
	net.Send(pPlayer)
end

function Fusion.skills:GetSkillLevel(pPlayer, stringSkill)
	return pPlayer.skills[stringSkill] or false
end

function Fusion.skills:WriteSkills(pPlayer)
	local tbl = Fusion.util:JSON(pPlayer.skills)

	Fusion.file:Write("skills_"..pPlayer:SteamID64(),  tbl)
end