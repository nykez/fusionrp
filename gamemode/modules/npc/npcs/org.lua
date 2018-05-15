
local npc = {}

npc.id = 5

npc.name = "Organization"

npc.model = "models/Humans/Group01/Female_03.mdl"

npc.spawn = {
	["gm_construct"] = {
		Vector(491.350525, -680.441162, -145)
	},

	["rp_rockford_v2b"] = {
		Vector(-4767.492676, -5153.28418, 64.031250)
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
	Fusion.dialog.canvas:SetTitle('Organization')

	if LocalPlayer():getChar():getOrg(false) then
		Fusion.dialog.canvas:AddButton("I'm wanting to leave my Organization.", npc.leave)
	else
		Fusion.dialog.canvas:AddButton("I'm wanting to start an Organization.", npc.create)
	end

	Fusion.dialog.canvas:AddButton("I want to check my Organization invites.", npc.invites)
	Fusion.dialog.canvas:AddButton("Nevermind.", Fusion.dialog.Close)

	Fusion.dialog.canvas:Show()
end

npc.leave = function()
	Fusion.dialog:Close()

	local org = LocalPlayer():OrgObject()

	if org:GetRank(LocalPlayer()) == "owner" then
		Derma_Query("You're the owner. Are you sure you want to disband?", "",
		"Yes", function() 
			netstream.Start("fusion_leaveorg")
		end,
		"No"
	)
	else
		netstream.Start("fusion_leaveorg")
	end

end

npc.create = function()
	Fusion.dialog:Close()

	Derma_StringRequest(
	"Create Organization",
	"Enter organization Name",
	"",
	function( text )
		local tblData = {}
		tblData.name = text 
		netstream.Start("fusion_createorg", tblData)
	end,
	function( text ) end
 )

end

npc.invites = function()

	Fusion.dialog:Close()
	
	if invites then
		invites:Remove()
		invites = nil
	end
	invites = vgui.Create("FusionOrgInvites")

end



Fusion.npcs:RegisterNPC(npc)