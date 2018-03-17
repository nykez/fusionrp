
Fusion.dialog = Fusion.dialog or {}

function Fusion.dialog:Close()
	if Fusion.dialog.Canvas then
		Fusion.dialog.Canvas:Hide()
	end
end


hook.Add( "InitPostEntity", "PlayerInitialSpawnDialog", function()
	Fusion.dialog.Canvas = vgui.Create("FusionDialog")
	Fusion.dialog.Canvas:SetVisible(false)
end )

hook.Add("OnReloaded", "OnReloadedDialog", function()
	if Fusion.dialog.Canvas then
		Fusion.dialog.Canvas:Remove()
	end

	Fusion.dialog.Canvas = vgui.Create("FusionDialog")
	Fusion.dialog.Canvas:SetVisible(false)
end)
//