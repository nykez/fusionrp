Fusion.jobs = Fusion.jobs or {}
Fusion.jobs.cache = Fusion.jobs.cache or {}

TEAM_CITIZEN = 1
TEAM_POLICE = 2
TEAM_MEDIC = 3
TEAM_FIREFIGHTER = 4

function Fusion.jobs:Load()
    local jobs = file.Find(GAMEMODE.FolderName .. "/gamemode/modules/jobs/jobs/*.lua", "LUA")

    for k, v in pairs(jobs) do
        local path = GAMEMODE.FolderName .. "/gamemode/modules/jobs/jobs/" .. v

        if SERVER then
            AddCSLuaFile(path)
        end

        include(path)
    end

    print("[Fusion RP] Loaded all jobs")
end
hook.Add("PostGamemodeLoaded", "Fusion.LoadJobs", Fusion.jobs.Load)

function Fusion.jobs:Register(tbl)
    if !tbl or !tbl.id then return end
    if Fusion.jobs.cache[tbl.id] then return end

    Fusion.jobs.cache[tbl.id] = tbl
    team.SetUp(tbl.id, tbl.name, tbl.color, true)
end

function PLAYER:Employed()
    if self:Team() > 1 then
        return true
    end

    return false
end

function Fusion.jobs:Get(id)
    return Fusion.jobs.cache[id]
end
