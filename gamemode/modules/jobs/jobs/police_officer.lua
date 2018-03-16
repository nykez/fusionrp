local job = {}

job.id = TEAM_POLICE

job.name = "Police Officer"

job.level = 5

job.pay = 20

job.color = Color(60, 60, 255)

job.weapons = {}
job.ammo = {}

job.models = {}

job.ranks = {
    {1, "Cadet"},
    {2, "Newbie"},
    {3, "Veteran"}
}

Fusion.jobs:Register(job)
