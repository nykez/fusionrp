

local npc = {}

npc.id = 4

npc.name = "Car Spawner"

npc.model = "models/Humans/Group01/Female_01.mdl"

npc.spawn = {
	["gm_construct"] = {
		Vector(491.350525, -680.441162, -145)
	},

	["rp_rockford_v2b"] = {
		Vector(-5444.560547, -7140.468750, 8.031250)
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
	Fusion.dialog.canvas:SetTitle('Car Spawner')

	Fusion.dialog.canvas:AddButton("I'm looking to get my car.", npc.buy)
	Fusion.dialog.canvas:AddButton("What, do I look rich to you??", Fusion.dialog.Close)

	Fusion.dialog.canvas:Show()
end

npc.buy = function()
	Fusion.dialog:Close()

	if Fusion.vehicles.panel then
		Fusion.vehicles.panel:Remove()
		Fusion.vehicles.panel = nil
	end

	if !Fusion.vehicles.panel then
		Fusion.vehicles.panel = vgui.Create("FusionGarage")
	end
end


Fusion.npcs:RegisterNPC(npc)
