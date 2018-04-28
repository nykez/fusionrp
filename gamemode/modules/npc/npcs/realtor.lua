local npc = {}

npc.id = 2

npc.name = "Realtor"

npc.model = "models/Humans/Group01/Female_02.mdl"

npc.spawn = {
	["rp_rockford_v2b"] = {
		Vector(-1088.027466, 6630.270996, 544.031250)
	}
}

npc.angle = {
	["rp_rockford_v2b"] = {
		Angle(1.985361, -161.067749, 0.000000)
	}
}

npc.use = function()
	Fusion.dialog.canvas:SetTitle('Realtor Office')

	Fusion.dialog.canvas:AddButton("I'm looking to buy a property!", npc.property)
    Fusion.dialog.canvas:AddButton("Nevermind, I'm too poor for this.", Fusion.dialog.Close)

	Fusion.dialog.canvas:Show()
end

npc.property = function()
    Fusion.dialog:Close()

    Fusion.property.panel = vgui.Create("FusionProperty")
end

Fusion.npcs:RegisterNPC(npc)
