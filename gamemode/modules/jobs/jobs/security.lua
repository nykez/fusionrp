

local JOB = {}
JOB.ID = 2
JOB.Name = "Private Security"
JOB.Color = Color(60, 255, 60)
JOB.Salaray = 175
JOB.Enum = "TEAM_SECURITY"
JOB.NoJoin = "You need a private security license to become this job."

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
		return Fusion.license.Has("license_security", pPlayer)
	end
end


Fusion.jobs:RegisterJob(JOB)