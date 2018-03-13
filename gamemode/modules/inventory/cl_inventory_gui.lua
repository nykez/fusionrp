//
concommand.Add("inventory_gui", function()

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() * 0.5, ScrH() * 0.5)
	frame:Center()
	frame:MakePopup()


	local sheet = vgui.Create( "DColumnSheet", frame )
	sheet:Dock( FILL )

	local panel2 = vgui.Create( "DPanel", sheet )
	panel2:Dock( FILL )
	panel2.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 128, 0 ) ) end
	sheet:AddSheet( "Settings", panel2)

	// Inventory
	local container = vgui.Create('DScrollPanel', sheet)
	container:Dock(FILL)
	container:DockMargin(5, 10, 5, 5)

	local data = LocalPlayer().inventory 

	local myItems = {}
	if data then
		for k,v in pairs(data) do
			local item = Fusion.inventory:GetItem(k)
			if not item then continue end


			local panel = vgui.Create("DPanel", container)
			panel:SetSize(frame:GetWide() * 0.3, frame:GetTall()*0.3)
			panel:SetPos(container:GetWide() * 0.2 * k, container:GetTall() * 0.2 * k)
			function panel:Paint(w, h)
				surface.SetDrawColor(32, 32, 32)
				surface.DrawRect(0, 0, w, h)

				local quan = LocalPlayer().inventory[k].quantity

				draw.SimpleText(quan, "TargetID", 5, 10, color_white, TEXT_ALIGN_LEFT)

			end

			local mdlpnl = vgui.Create('DModelPanel', panel)
			mdlpnl:Dock(FILL)
			mdlpnl:SetModel(item.model)

			panel.id = item.id

			local mn, mx = mdlpnl.Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

			mdlpnl:SetFOV( 45 )
			mdlpnl:SetCamPos( Vector( size, size, size ) )
			mdlpnl:SetLookAt( ( mn + mx ) * 0.5 )

			local spawn_btn = container:Add("DButton")
			spawn_btn:SetText("")
			function spawn_btn:Paint() end
			function spawn_btn:DoClick()
				net.Start("Fusion.inventory.spawn")
					net.WriteInt(item.id, 16)
				net.SendToServer()
				if LocalPlayer().inventory[panel.id].quantity <= 1 then
					panel:Remove()
				end
			end
			spawn_btn:Dock(FILL)

		end
	end

	sheet:AddSheet( "Inventory", container)
end)