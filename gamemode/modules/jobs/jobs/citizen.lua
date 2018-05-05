
local JOB = {}
JOB.ID = 1
JOB.Name = "Citizen"
JOB.Color = Color(60, 255, 60)
JOB.Salaray = 175
JOB.Enum = "TEAM_CITIZEN"

// REQUIRED FIELDS 
function JOB:OnPlayerJoin(pPlayer)
	pPlayer:Notify("You're now a citizen.")
end

function JOB:OnPlayerQuitJob(pPlayer)
	pPlayer:Notify("You quit your job.")
end

if SERVER then
	function JOB:PlayerLoadout(pPlayer)
		pPlayer:Give("weapon_ar2")
	end

	function JOB:CanJoinJob(pPlayer)
		return true
	end
end


Fusion.jobs:RegisterJob(JOB)