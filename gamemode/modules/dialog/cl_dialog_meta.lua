Fusion.dialog = Fusion.dialog or {}

function Fusion.dialog:Close()
	Fusion.dialog.canvas:Hide()
end


hook.Add( "InitPostEntity", "PlayerInitialSpawnDialog", function()
	Fusion.dialog.canvas = Fusion.menus:Create("FusionDialog")
	Fusion.dialog.canvas:SetVisible(false)
end )

hook.Add("OnReloaded", "OnReloadedDialog", function()
	if IsValid(Fusion.dialog.canvas) then
		Fusion.dialog.canvas:Remove()
	end

	Fusion.dialog.canvas = Fusion.menus:Create("FusionDialog")
	Fusion.dialog.canvas:SetVisible(false)
end)
