local job = {}

job.id = 1

job.name = "Citizen"

job.color = Color(60, 255, 60)

job.level = 0

job.pay = 5

-- job.onJoin = function(pPlayer)
-- 	pPlayer:Notify("You have joined this job.")

-- 	pPlayer:StripWeapons()

-- end

-- join.onQuit = function(pPlayer)
-- 	pPlayer:Notify("You quit your job.")

-- end

Fusion.jobs:Register(job)

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