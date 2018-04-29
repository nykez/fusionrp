
Msg("DiscordRPC loading: start\n")

if SERVER then
	CreateConVar("discordrpc", "1", 0, "This ConVar does nothing, don't bother! It just allows people to filter servers using it.") -- server ConVar to allow filtering
end

local function client(file)
	if SERVER then AddCSLuaFile(file) end

	if CLIENT then
		return include(file)
	end
end

local function server(file)
	if SERVER then
		return include(file)
	end
end

local function shared(file)
	return client(file) or server(file)
end

shared("init.lua")
shared("states/default.lua")
shared("main.lua")

Msg("DiscordRPC loading: done!\n")
