
local npc = {}

npc.id = 1

npc.name = "Car Dealer"

npc.model = "models/Humans/Group01/Female_04.mdl"

npc.spawn = {
	["gm_construct"] = {
		Vector(491.350525, -680.441162, -145)
	},

	["rp_rockford_v2b"] = {
		Vector(-4199.316406, -684.886230, 0)
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
	Fusion.dialog.canvas:SetTitle('Car Dealer')

	Fusion.dialog.canvas:AddButton("I'm looking for a car.", npc.buy)
	Fusion.dialog.canvas:AddButton("I want to modify a vehicle.", npc.modify)
	Fusion.dialog.canvas:AddButton("What, do I look rich to you??", Fusion.dialog.Close)

	Fusion.dialog.canvas:Show()
end

npc.modify = function()
	Fusion.dialog:Close()

	if modify then
		modify:Remove()
		modify = nil
	end

	modify = vgui.Create("FusionVehicleModSelect")

end

npc.buy = function()
	Fusion.dialog:Close()

	if !Fusion.vehicles.panel then
		Fusion.vehicles.panel = vgui.Create("FusionVehicles")
	end
end


Fusion.npcs:RegisterNPC(npc)
