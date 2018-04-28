local job = {}

job.id = TEAM_CITIZEN

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
