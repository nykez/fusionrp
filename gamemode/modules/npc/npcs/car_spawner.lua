
local npc = {}

npc.id = 1

npc.name = "Car Dealer"

npc.model = "models/Humans/Group01/Female_04.mdl"

npc.spawn = {
	["gm_construct"] = {
		Vector(491.350525, -680.441162, -145)
	},

	["rp_rockford_v2b"] = {
		Vector(-4198, -669, 0)
	}
}

npc.angle = {
	["gm_construct"] = {
		Angle(0, 90, 0)
	},

	["rp_rockford_v2b"] = {
		Angle(0, -90, 0)
	}
}

npc.use = function()
	LocalPlayer():ChatPrint("It worked!")
end


Fusion.npcs:RegisterNPC(npc)
