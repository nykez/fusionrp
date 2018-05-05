
local JOB = {}
JOB.ID = 1
JOB.Name = "Citizen"
JOB.Color = Color(60, 255, 60)
JOB.Salaray = 175
JOB.ENUM = "TEAM_CITIZEN"

function JOB:OnPlayerJoin(pPlayer)

end

function JOB:OnPlayerQuit(pPlayer)

end

if SERVER then
	function JOB:PlayerLoadout(pPlayer)
		pPlayer:Give("weapon_physgun")
	end
end

Fusion.jobs:RegisterJob(JOB)