
local npc = {}

npc.id = 3

npc.name = "Licenses"

npc.model = "models/Humans/Group01/Female_01.mdl"

npc.spawn = {
	["gm_construct"] = {
		Vector(491.350525, -680.441162, -145)
	},

	["rp_rockford_v2b"] = {
		Vector(-4661.199707, -5163.968750, 70)
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
	Fusion.dialog.canvas:SetTitle('License Registration')

	Fusion.dialog.canvas:AddButton("I'm looking to buy a license.", npc.buy)
	Fusion.dialog.canvas:AddButton("I want to pay my car insurance.", npc.insurance)
	Fusion.dialog.canvas:AddButton("Nevermind.", Fusion.dialog.Close)

	Fusion.dialog.canvas:Show()
end

npc.buy = function()
	Fusion.dialog:Close()

	if Fusion.license.gui then
		Fusion.license.gui:Remove()
		Fusion.license.gui = nil
	end

	if !Fusion.license.gui then
		Fusion.license.gui = vgui.Create("FusionLicense")
	end
end

npc.insurance = function()
	Fusion.dialog:Close()

	if Fusion.license.gui then
		Fusion.license.gui:Remove()
		Fusion.license.gui = nil
	end

	if !Fusion.license.gui then
		Fusion.license.gui = vgui.Create("FusionInsurance")
	end
end


Fusion.npcs:RegisterNPC(npc)