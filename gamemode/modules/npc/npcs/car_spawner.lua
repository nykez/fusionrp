
local npc = {}

npc.id = 1

npc.name = "Car Dealer"

npc.model = "models/Humans/Group01/Female_04.mdl"

npc.spawn = {
	["gm_construct"] = {
		Vector(491.350525, -680.441162, -145)
	}
}

npc.angle = {
	["gm_construct"] = {
		Angle(0, 90, 0)
	}
}

npc.use = function()

end


Fusion.npcs:RegisterNPC(npc)
