Fusion.jobs = Fusion.jobs or {}
Fusion.jobs.cache = Fusion.jobs.cache or {}

util.AddNetworkString("Fusion.jobs.join")
util.AddNetworkString("Fusion.jobs.quit")

function Fusion.jobs:Join(ply, id)
    if !Fusion.jobs.cache[id] then return end
    if !ply:Alive() then return end
    if ply:Team() == id then return end
    if id == TEAM_CITIZEN then return end

    if ply:Employed() then
		ply:Notify("You must quit your current job first!")
		return
	end

    local job = Fusion.jobs.cache[id]
    if !job.id then return end
    if !job.level then job.level = 0 end

    if ply:GetLevel() < job.level then
        ply:Notify("You are not the right level for that!")
        return
    end

    job.onJoin(ply)

    ply.playerModel = ply:GetModel()
    ply.jobModel = job.models[1]

    ply:SetTeam(job.id)

    ply.Loadout = {}
end

function Fusion.jobs:Quit(ply)
    if !ply:Alive() then return end
    if !ply:Employed() then return end

    local job = Fusion.jobs.cache[id]
    if not job then return end
    
    job.onQuit(ply)

    ply:SetModel(ply.playerModel)
    ply:SetTeam(TEAM_CITIZEN)
end

net.Receive("Fusion.jobs.join", function(len, ply)
    if !IsValid(ply) then return end

    Fusion.jobs:Join(net.ReadInt(16), ply)
end)

net.Receive("Fusion.jobs.quit", function(len, ply)
    if !IsValid(ply) then return end

    Fusion.jobs:Quit(ply)
end)
