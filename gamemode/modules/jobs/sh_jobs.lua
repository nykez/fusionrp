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

function Fusion.jobs:RegisterJob(tblData)
    Fusion.jobs.cache[tblData.ID] = tblData

    _G[tblData.Enum] = tblJob.ID
end

function Fusion.jobs:GetJobs()
    return Fusion.jobs.cache
end

function Fusion.jobs:GetJobByID(ID)
    return Fusion.jobs.cache[ID]
end

function Fusion.jobs:GetPlayerJob(pPlayer)
    return Fusion.jobs.cache[pPlayer.currentJob]
end

function Fusion.jobs:IsPlayerJob(pPlayer, jobID)
    return pPlayer.currentJob == jobID or false
end

if SERVER then
    function Fusion.jobs:SetJob(pPlayer, jobID)
        if not IsValid(pPlayer) then return end
        
        if pPlayer.currentJob then
            Fusion.jobs:GetJobByID(pPlayer.currentJob):OnPlayerQuitJob(pPlayer)
            hook.Call( "GamemodePlayerQuitJob", GAMEMODE, pPlayer, pPlayer.currentJob )
        end

        pPlayer.currentJob = jobID
        pPlayer:SetTeam(jobID)

        Fusion.jobs:GetJobByID( intJobID ):OnPlayerJoin( pPlayer )

        pPlayer:StripWeapons()

        hook.Call( "PlayerLoadout", GAMEMODE, pPlayer )
    end
end

